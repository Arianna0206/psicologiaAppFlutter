import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:psicologia_app_liid/presentation/blocs/notifications/notifications_bloc.dart';
import '../controllers/home_controller.dart';
import '../controllers/controller_services.dart';

class LogrosScreen extends StatefulWidget {
  final String categoryId;
  final String methodId;

  const LogrosScreen({
    super.key,
    required this.categoryId,
    required this.methodId,
  });

  @override
  LogrosScreenState createState() => LogrosScreenState();
}

class LogrosScreenState extends State<LogrosScreen> {
  final HomeController homeController = Get.find<HomeController>();
  final ControllerServices service = Get.find<ControllerServices>();

  TimeOfDay? selectedTime;
  DateTime? selectedDateTime;
  String selectedFrequency = "Diariamente";
  List<int> selectedDays = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4475D5), Color(0x8C61C6FF), Color(0xFF3D496F)],
            stops: [0.0, 0.53, 1.0],
          ),
        ),
        child: SafeArea(
          child: FutureBuilder<Map<String, dynamic>>(
          future: service.getTechniqueAchievements(widget.methodId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text('Error al cargar los logros', style: TextStyle(color: Colors.white)),
              );
            }

            final data = snapshot.data ?? {};
            final completados = List<String>.from(data["completados"] ?? []);
            final desafios = List<String>.from(data["desafios"] ?? []);
            final int puntosTotales = data["puntos"] ?? 0;

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'LOGROS',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "🎖️ Total de puntos ganados: $puntosTotales",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber),
                  ),
                  const SizedBox(height: 20),
                  _buildAchievementsSection('✅ Ejercicios Completados', completados),
                  const SizedBox(height: 20),
                  _buildAchievementsSection('⚡ Desafíos Logrados', desafios),
                  const SizedBox(height: 30),
                  _buildReminderSection(),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      homeController.goToMenu(widget.categoryId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: const Text('MENÚ', style: TextStyle(color: Colors.black)),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        )
        ),
      ),
    );
  }

  Widget _buildAchievementsSection(String title, List<String> achievements) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: achievements.isNotEmpty
                  ? achievements.map((e) => Text('- $e', style: const TextStyle(fontSize: 16, color: Colors.black))).toList()
                  : [const Text('No hay logros aún.', style: TextStyle(fontSize: 16, color: Colors.black))],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderSection() {
    return Column(
      children: [
        const Text(
          '📅 RECORDATORIO',
          style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildFrequencyButton("Diariamente"),
            _buildFrequencyButton("Semanal"),
            _buildFrequencyButton("Personalizado"),
          ],
        ),
        const SizedBox(height: 15),
        Container(
          width: 300,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Fecha y Hora", style: TextStyle(fontSize: 18, color: Colors.black)),
                  GestureDetector(
                    onTap: _pickDateTime,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        selectedDateTime == null
                            ? "Seleccionar"
                            : "${selectedDateTime!.day}/${selectedDateTime!.month}/${selectedDateTime!.year} "
                              "${selectedDateTime!.hour}:${selectedDateTime!.minute}",
                        style: const TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              if (selectedFrequency == "Personalizado") _buildDaySelection(),
              const SizedBox(height: 15),
            ],
          ),
        ),
        const SizedBox(height: 15),
        ElevatedButton(
          onPressed: _scheduleNotification,
          child: const Text("Guardar Recordatorio"),
        ),
      ],
    );
  }

  Widget _buildFrequencyButton(String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFrequency = text;
          if (text != "Personalizado") {
            selectedDays.clear();
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: selectedFrequency == text ? Colors.blue : Colors.white),
          borderRadius: BorderRadius.circular(10),
          color: selectedFrequency == text ? Colors.blue[300] : Colors.transparent,
        ),
        child: Text(
          text,
          style: TextStyle(color: selectedFrequency == text ? Colors.white : Colors.white70, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildDaySelection() {
    return Column(
      children: [
        const Text("Selecciona los días:", style: TextStyle(fontSize: 18, color: Colors.black)),
        Wrap(
          spacing: 5,
          children: List.generate(7, (index) {
            final daysOfWeek = ["L", "M", "X", "J", "V", "S", "D"];
            final dayIndex = index + 1;
            final isSelected = selectedDays.contains(dayIndex);

            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedDays.remove(dayIndex);
                  } else {
                    selectedDays.add(dayIndex);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  daysOfWeek[index],
                  style: TextStyle(
                    fontSize: 16,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Future<void> _pickDateTime() async {
    DateTime now = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime ?? now,
      firstDate: now,
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime ?? now),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _scheduleNotification() async {
    if (selectedDateTime != null) {
      final state = context.read<NotificationsBloc>().state;

      String notificationTitle = "Título predeterminado";
      String notificationBody = "Mensaje predeterminado";

      if (state is NotificationsLoaded && state.notifications.isNotEmpty) {
        notificationTitle = state.notifications.first.title;
        notificationBody = state.notifications.first.body;
      }

      await service.saveUserNotification(
        dateTime: selectedDateTime!,
        title: notificationTitle,
        body: notificationBody,
        frequency: selectedFrequency,
        selectedDays: selectedDays,
      );

      context.read<NotificationsBloc>().add(
        ScheduleNotification(
          date: selectedDateTime!,
          time: TimeOfDay(hour: selectedDateTime!.hour, minute: selectedDateTime!.minute),
          title: notificationTitle,
          body: notificationBody,
          frequency: selectedFrequency,
          selectedDays: selectedDays.isEmpty ? null : selectedDays,
        ),
      );

      Get.snackbar("Recordatorio Guardado", "Notificación programada: $notificationTitle - $notificationBody");
    } else {
      Get.snackbar("Error", "Selecciona una fecha y hora primero.");
    }
  }

}
