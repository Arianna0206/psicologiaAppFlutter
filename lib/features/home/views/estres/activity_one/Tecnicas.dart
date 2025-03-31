import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:psicologia_app_liid/shared/widgets/animatedTimer.dart';
import 'package:psicologia_app_liid/shared/widgets/cached_image.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../shared/services/video_service.dart';
import '../../../controllers/controller_services.dart';
import '../../../controllers/home_controller.dart';

class Tecnicas extends StatefulWidget {
  final String categoryId;
  final String methodId;

  const Tecnicas({super.key, required this.categoryId, required this.methodId});

  @override
  TecnicasState createState() => TecnicasState();
}

class TecnicasState extends State<Tecnicas> {
  final HomeController homeController = Get.find<HomeController>();
  final ControllerServices service = Get.find<ControllerServices>();
  final VideoService videoService = VideoService();
  final RxBool isPlaying = false.obs;
  final AudioPlayer player = AudioPlayer();
  VideoPlayerController? _videoController;
  int currentExerciseIndex = 0;
  int exerciseDuration = 20;
  bool isTimerFinished = false;
  String userId = FirebaseAuth.instance.currentUser?.uid ?? ""; 

  final List<String> exerciseImages = [
    'https://firebasestorage.googleapis.com/v0/b/psicologia-app-liid.firebasestorage.app/o/images%2Fvoz.png?alt=media&token=6f376c2d-a533-4d5a-9a3e-d2e65780fff4',
    'https://firebasestorage.googleapis.com/v0/b/psicologia-app-liid.firebasestorage.app/o/images%2Fvoz3.png?alt=media&token=918bfc87-63b7-430b-a6af-ce42e3265d6d',
    'https://firebasestorage.googleapis.com/v0/b/psicologia-app-liid.firebasestorage.app/o/images%2Fvoz4.png?alt=media&token=c6fa321f-e786-4464-a3e8-ce1d6ed4bb02',
    'https://firebasestorage.googleapis.com/v0/b/psicologia-app-liid.firebasestorage.app/o/images%2Fvoz5.png?alt=media&token=cef08a22-7467-4249-944d-d56c67cd6307',
    'https://firebasestorage.googleapis.com/v0/b/psicologia-app-liid.firebasestorage.app/o/images%2Fvoz6.png?alt=media&token=97e74084-9dc9-4a18-86d0-5223613a535a'
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!service.isLoading.value) {
        service.fetchExercises(widget.categoryId, widget.methodId).then((_) {
          loadVideo();
        });
      }
    });

    player.onPlayerComplete.listen((event) {
      isPlaying.value = false;
    });
  }


  Future<void> loadVideo() async {
    if (service.exercises.isEmpty) return;
    var currentExercise = service.exercises[currentExerciseIndex].data() as Map<String, dynamic>;
    setState(() {
      exerciseDuration = currentExercise["duration"] ?? 20;
      isTimerFinished = false;
    });
    if (!currentExercise.containsKey("videoUrl") || currentExercise["videoUrl"].toString().isEmpty) {
      // print("No se encontró una ruta de video.");
      return;
    }
    String videoUrl = currentExercise["videoUrl"].toString();
    // print("Cargando video cacheado: $videoUrl");
    try {
      FileInfo fileInfo = await DefaultCacheManager().getFileFromCache(videoUrl) ??
          await DefaultCacheManager().downloadFile(videoUrl);

      if (fileInfo.file.existsSync()) {
        _videoController?.dispose();
        _videoController = VideoPlayerController.file(fileInfo.file)
          ..initialize().then((_) {
            _videoController!.setLooping(true);
            _videoController!.play();
            setState(() {});
          });
      } else {
        // print("No se pudo cargar el video.");
      }
    } catch (e) {
      // print("Error en loadVideo(): $e");
    }
  }

  Future<void> goToNextExercise() async {
    if (!isTimerFinished) return;
    var currentExercise = service.exercises[currentExerciseIndex].data() as Map<String, dynamic>;
    String exerciseId = service.exercises[currentExerciseIndex].id;
    String exerciseTitle = currentExercise["title"] ?? "Ejercicio sin título"; 
    int duration = currentExercise["duration"] ?? 20; 
    await service.saveCompletedExercise(widget.categoryId, widget.methodId, exerciseId, exerciseTitle, duration);
    if (currentExerciseIndex < service.exercises.length - 1) {
      setState(() {
        currentExerciseIndex++;
        isTimerFinished = false;
      });
      loadVideo();
    } else {
      // print("Último ejercicio completado.");
      homeController.goToEstadistica(widget.categoryId, widget.methodId);
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    player.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (service.isLoading.value) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      if (service.exercises.isEmpty) {
        return const Scaffold(
          body: Center(
            child: Text(
              "No hay ejercicios disponibles.",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        );
      }

      var currentExercise = service.exercises[currentExerciseIndex].data() as Map<String, dynamic>;
      String exerciseDescription = currentExercise["description"] ?? "Descripción no disponible";
      double progress = (currentExerciseIndex + 1) / service.totalExercises.value;
      String selectedImage = exerciseImages[currentExerciseIndex % exerciseImages.length];

      return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF4475D5),
                Color(0x8C61C6FF),
                Color(0xFF3D496F),
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'TU PROGRESO CON LA TÉCNICA',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          color: Colors.greenAccent,
                          minHeight: 10,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Ejercicio ${currentExerciseIndex + 1} de ${service.totalExercises.value}",
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  Stack(
                    children: [
                      CachedNetworkAsset(
                        url: selectedImage,
                        width: 270,
                        height: 270,
                      ),

                      // Texto dentro del globo
                      Positioned(
                        top: 87,
                        left: 30,
                        right: 30,
                        child: Text(
                          exerciseDescription,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      // Botón de audio
                      Obx(() {
                        final currentExercise = service.exercises[currentExerciseIndex].data() as Map<String, dynamic>;
                        final audioUrl = currentExercise["audioUrl"] ?? "";
                        if (audioUrl.isEmpty) return const SizedBox.shrink();

                        return Positioned(
                          top: 15,
                          right: 15,
                          child: GestureDetector(
                            onTap: () async {
                              try {
                                if (isPlaying.value) {
                                  await player.pause();
                                  isPlaying.value = false;
                                } else {
                                  await player.setVolume(1.0);
                                  await player.play(UrlSource(audioUrl));
                                  isPlaying.value = true;
                                }
                              } catch (e) {
                                Get.snackbar("Error", "No se pudo reproducir el audio.");
                              }
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                              ),
                              child: Obx(() => Icon(
                                isPlaying.value ? Icons.pause : Icons.play_arrow,
                                color: Colors.purple,
                                size: 24,
                              )),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),


                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CachedNetworkAsset(
                        url: 'https://firebasestorage.googleapis.com/v0/b/psicologia-app-liid.firebasestorage.app/o/images%2Fmarciano.png?alt=media&token=3ed0d751-264c-4b62-b6cf-4e93b877bc58',
                        width: 150,
                        height: 150,
                      ),
                      const SizedBox(width: 50),
                      AnimatedTimer(
                        key: ValueKey(currentExerciseIndex),
                        duration: exerciseDuration,
                        categoryId: widget.categoryId, 
                        methodId: widget.methodId, 
                        exerciseIndex: currentExerciseIndex, 
                        onFinish: () {
                          setState(() {
                            isTimerFinished = true;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: () {
                      if (_videoController != null && _videoController!.value.isInitialized) {
                        setState(() {
                          _videoController!.value.isPlaying ? _videoController!.pause() : _videoController!.play();
                        });
                      }
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20), 
                      child: SizedBox(
                        width: 330,
                        height: 180,
                        child: _videoController != null && _videoController!.value.isInitialized
                            ? VideoPlayer(_videoController!)
                            : const Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: isTimerFinished ? goToNextExercise : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: const Text('Siguiente ejercicio'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}