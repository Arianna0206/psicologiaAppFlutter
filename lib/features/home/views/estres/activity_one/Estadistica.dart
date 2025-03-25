import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:psicologia_app_liid/features/home/controllers/controller_services.dart';
import 'package:psicologia_app_liid/shared/widgets/cached_image.dart';
import '../../../controllers/home_controller.dart';

class ResumenEjercicioScreen extends StatefulWidget {
  final String categoryId;
  final String methodId;

  const ResumenEjercicioScreen({
    super.key,
    required this.categoryId,
    required this.methodId,
  });

  @override
  ResumenEjercicioScreenState createState() => ResumenEjercicioScreenState();
}

class ResumenEjercicioScreenState extends State<ResumenEjercicioScreen> {
  late final HomeController homeController;
  late final ControllerServices service;

  late Future<void> _fetchExercisesFuture;

  final List<String> frasesMotivacionales = [
    "¡Sigue así! Cada pequeño paso cuenta.",
    "La gratitud es la clave para la felicidad.",
    "Cada día es una oportunidad para mejorar.",
    "Eres más fuerte de lo que piensas.",
    "Tu esfuerzo traerá grandes recompensas."
  ];

   @override
  void initState() {
    super.initState();
    homeController = Get.find<HomeController>();
    service = Get.find<ControllerServices>();
    service.actualizarMensaje();
    _fetchExercisesFuture = service.fetchExercises(widget.categoryId, widget.methodId);
    service.loadStressLevel(widget.categoryId);
    Future.delayed(Duration(milliseconds: 500), () async {
      await service.fetchCompletedExercises();
    });
  }


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
          child: FutureBuilder<void>(
            future: _fetchExercisesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'RESUMEN DE LA TÉCNICA',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CachedNetworkAsset(
                            url: 'https://firebasestorage.googleapis.com/v0/b/psicologia-app-liid.firebasestorage.app/o/images%2Fmarciano_copa.png?alt=media&token=c1b220dc-1372-4728-ba56-fb34ac76f853',
                            width: 150,
                            height: 150,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: GetBuilder<ControllerServices>(
                              builder: (service) {
                                return Text(
                                  frasesMotivacionales[service.mensajeIndex.value],
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(fontSize: 16, color: Colors.white),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "TU PROGRESO",
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                    const SizedBox(height: 5),
                                    Obx(() {
                                      double progressValue = service.totalExercises.value > 0
                                          ? service.exercises.length / service.totalExercises.value
                                          : 0;
                                      return LinearProgressIndicator(
                                        value: progressValue,
                                        backgroundColor: Colors.grey[300],
                                        color: Colors.blueAccent,
                                        minHeight: 10,
                                        borderRadius: BorderRadius.circular(5),
                                      );
                                    }),
                                    const SizedBox(height: 5),
                                    Obx(() {
                                      return Text(
                                        "Ejercicio ${service.exercises.length} de ${service.totalExercises.value}",
                                        style: const TextStyle(color: Colors.white, fontSize: 14),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 15),
                              ElevatedButton(
                                onPressed: () async {
                                  homeController.goToLogros();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                ),
                                child: const Text('Ver logros', style: TextStyle(color: Colors.black)),
                              ),
                            ],
                          ),

                          const SizedBox(height: 50),

                          _buildStressSelectionBar(context),

                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                    _buildSummaryCard(),
                    const SizedBox(height: 20),
                    _buildCommentBox(),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        homeController.goToMenu(widget.categoryId);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      child: const Text('MENÚ', style: TextStyle(color: Colors.black)),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }


  Widget _buildStressSelectionBar(BuildContext context) {
  double barWidth = MediaQuery.of(context).size.width * 0.9;
  double buttonWidth = barWidth / 5;

  return Column(
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
                          color: service.selectedStressLevel.value == index 
                              ? Colors.white 
                              : Colors.transparent, 
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
            Obx(() { // Indicador de estrés
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
                    // placeholderBuilder: (BuildContext context) => const CircularProgressIndicator(),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    ],
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

  Widget _buildSummaryCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Los ejercicios realizados fueron",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 10),

            Obx(() {
              if (service.completedExercises.isEmpty) {
                return const Text("No has completado ejercicios aún.",
                    style: TextStyle(fontSize: 16, color: Colors.black));
              }

              return Column(
                children: service.completedExercises.map((exercise) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          exercise["name"],
                          style: const TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        Text(
                          "${exercise["duration"]} segundos",
                          style: const TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            }),
            const SizedBox(height: 10),
            const Text(
              "¡Te esperamos mañana! 💪",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildCommentBox() {
    TextEditingController commentController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Danos tus comentarios",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: commentController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Escribe aquí tu comentario...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () async {
                  if (commentController.text.isNotEmpty) {
                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection("comments")
                        .add({
                      "comment": commentController.text,
                      "timestamp": FieldValue.serverTimestamp(),
                    });

                    // Get.snackbar("Comentario enviado", "Gracias por tu feedback!");
                    commentController.clear();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: const Text("Enviar", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}