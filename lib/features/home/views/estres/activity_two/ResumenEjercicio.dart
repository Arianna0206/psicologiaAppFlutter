import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:psicologia_app_liid/features/home/controllers/controller_services.dart';
import 'package:psicologia_app_liid/features/home/controllers/home_controller.dart';
import 'package:psicologia_app_liid/shared/widgets/cached_image.dart';

class ResumenGratitudScreen extends StatefulWidget {
  final String categoryId;
  final String methodId;

  const ResumenGratitudScreen({
    super.key,
    required this.categoryId,
    required this.methodId,
  });

  @override
  State<ResumenGratitudScreen> createState() => _ResumenGratitudScreenState();
}

class _ResumenGratitudScreenState extends State<ResumenGratitudScreen> with SingleTickerProviderStateMixin {
  final ControllerServices service = Get.find<ControllerServices>();
   final HomeController homeController = Get.find<HomeController>();

  final List<String> frasesMotivacionales = [
    "¡Sigue así! Cada pequeño paso cuenta.",
    "La gratitud es la clave para la felicidad.",
    "Cada día es una oportunidad para mejorar.",
    "Eres más fuerte de lo que piensas.",
    "Tu esfuerzo traerá grandes recompensas."
  ];

  final List<Color> lineColors = [
    Colors.cyanAccent,
    Colors.amberAccent,
    Colors.lightGreenAccent,
    Colors.deepOrangeAccent,
    Colors.pinkAccent,
    Colors.blueAccent,
    Colors.tealAccent
  ];

  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    service.fetchCompletedExercises();
    service.actualizarMensaje();
    service.loadStressLevel(widget.categoryId);
    service.fetchGratitudeEntries(widget.methodId);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double barWidth = MediaQuery.of(context).size.width * 0.9;
    double buttonWidth = barWidth / 5;

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
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'RESUMEN DE LA TÉCNICA',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CachedNetworkAsset(
                      url: 'https://firebasestorage.googleapis.com/v0/b/psicologia-app-liid.firebasestorage.app/o/images%2Fmarciano_copa.png?alt=media&token=c1b220dc-1372-4728-ba56-fb34ac76f853',
                      width: 180,
                      height: 180,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 40),
                    Flexible(
                      child: GetBuilder<ControllerServices>(
                        builder: (service) {
                          return Text(
                            frasesMotivacionales[service.mensajeIndex.value],
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16, color: Colors.white),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                ScaleTransition(
                  scale: _scaleAnimation,
                  child: ElevatedButton(
                    onPressed: () => homeController.goToLogros(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text('Logros'),
                  ),
                ),

                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const Text(
                        "¡Ahora es momento de evaluar cómo te sientes! Elige tu nivel de estrés actual:",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        height: 90,
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(5, (index) {
                                return GestureDetector(
                                  onTap: () async {
                                    await service.saveStressLevel(widget.categoryId, index);
                                    service.updateSelectedStressLevel(index);
                                  },
                                  child: Obx(() {
                                    return Container(
                                      width: buttonWidth,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: _getButtonColor(index),
                                        border: Border.all(
                                          color: service.selectedStressLevel.value == index ? Colors.white : Colors.transparent,
                                          width: 3.5,
                                        ),
                                        borderRadius: BorderRadius.only(
                                          topLeft: index == 0 ? const Radius.circular(20) : Radius.zero,
                                          bottomLeft: index == 0 ? const Radius.circular(20) : Radius.zero,
                                          topRight: index == 4 ? const Radius.circular(20) : Radius.zero,
                                          bottomRight: index == 4 ? const Radius.circular(20) : Radius.zero,
                                        ),
                                      ),
                                    );
                                  }),
                                );
                              }),
                            ),
                            Obx(() {
                              return AnimatedPositioned(
                                duration: const Duration(milliseconds: 300),
                                left: buttonWidth * service.selectedStressLevel.value + (buttonWidth / 2) - 25,
                                top: -30,
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  alignment: Alignment.center,
                                  child: CachedNetworkAsset(
                                    url: _getIndicatorImage(service.selectedStressLevel.value),
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      Obx(() {
                        final entries = List<Map<String, dynamic>>.from(service.gratitudeEntries);
                        if (entries.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              "Aún no hay datos suficientes para mostrar la gráfica.",
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }

                        final maxDuration = entries.map((e) => e['duration'] as num).reduce((a, b) => a > b ? a : b);
                        final maxY = ((maxDuration + 59) / 60).ceil() * 60;
                        final double interval = ((maxY / 5).round()).toDouble().clamp(60.0, double.infinity);

                        final sortedEntries = [...entries];
                        sortedEntries.sort((a, b) {
                          final aTimestamp = a['created_at'];
                          final bTimestamp = b['created_at'];
                          if (aTimestamp == null || bTimestamp == null) return 0;
                          return (bTimestamp.toDate()).compareTo(aTimestamp.toDate());
                        });

                        final last = sortedEntries.first;
                        final createdAt = last['created_at'];
                        final date = createdAt != null ? createdAt.toDate() : DateTime.now();
                        final formattedDate = DateFormat("EEEE d/MM/yyyy 'a las' h:mm a", 'es_ES').format(date);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 30),
                            const Text(
                              "Rendimiento de ejercicio",
                              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 260,
                              child: BarChart(
                                BarChartData(
                                  barGroups: entries.asMap().entries.map((entry) {
                                    final i = entry.key;
                                    final data = entry.value;
                                    final duration = (data["duration"] as num).toDouble();
                                    return BarChartGroupData(
                                      x: i,
                                      barRods: [
                                        BarChartRodData(
                                          toY: duration,
                                          width: 18,
                                          color: lineColors[i % lineColors.length],
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                  maxY: maxY.toDouble(),
                                  titlesData: FlTitlesData(
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 40,
                                        getTitlesWidget: (value, meta) => Padding(
                                          padding: const EdgeInsets.only(right: 4),
                                          child: Text("${(value / 60).toStringAsFixed(0)}m", style: const TextStyle(color: Colors.white, fontSize: 12)),
                                        ),
                                        interval: interval,
                                      ),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) => Text("Int ${value.toInt() + 1}", style: const TextStyle(color: Colors.white, fontSize: 10)),
                                      ),
                                    ),
                                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  ),
                                  gridData: FlGridData(show: true, horizontalInterval: interval),
                                  borderData: FlBorderData(show: true),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Día y hora", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  const SizedBox(height: 10),
                                  Text("Tu último intento fue el $formattedDate.", style: const TextStyle(color: Colors.black)),
                                  const SizedBox(height: 10),
                                  const Text("¡Nos encantaría verte nuevamente mañana!", style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold))
                                ],
                              ),
                            )
                          ],
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                ScaleTransition(
                  scale: _scaleAnimation,
                  child: ElevatedButton(
                    onPressed: () => homeController.goToMenu(widget.categoryId),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                    ),
                    child: const Text('MENÚ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 30),

              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getIndicatorImage(int level) {
    return [
      'https://firebasestorage.googleapis.com/v0/b/psicologia-app-liid.firebasestorage.app/o/images%2Findicador_malo.png?alt=media&token=fec04575-5d1f-459f-9356-f8b1f79583c1',
      'https://firebasestorage.googleapis.com/v0/b/psicologia-app-liid.firebasestorage.app/o/images%2Findicador_regular.png?alt=media&token=93551925-9a47-471e-9a9f-fbededc74979',
      'https://firebasestorage.googleapis.com/v0/b/psicologia-app-liid.firebasestorage.app/o/images%2Findicador_normal.png?alt=media&token=ad70ba6e-f24c-47c6-9c27-fe4f6cf5e064',
      'https://firebasestorage.googleapis.com/v0/b/psicologia-app-liid.firebasestorage.app/o/images%2Findicador_bueno.png?alt=media&token=81e2b534-e018-4444-9492-a5d64f3194ba',
      'https://firebasestorage.googleapis.com/v0/b/psicologia-app-liid.firebasestorage.app/o/images%2Findicador_genial.png?alt=media&token=38b23052-ac3b-4a73-98a5-99aa50b9bf6d',
    ][level];
  }

  Color _getButtonColor(int index) {
    return [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.teal,
      Colors.green,
    ][index];
  }
}
