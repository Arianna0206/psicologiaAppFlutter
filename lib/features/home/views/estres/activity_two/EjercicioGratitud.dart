import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:psicologia_app_liid/features/home/controllers/controller_services.dart';
import 'package:psicologia_app_liid/features/home/controllers/home_controller.dart';
import 'package:psicologia_app_liid/shared/widgets/cached_image.dart';

class GratitudScreen extends StatefulWidget {
  final String categoryId;
  final String methodId;

  const GratitudScreen({super.key, required this.categoryId, required this.methodId});

  @override
  GratitudScreenState createState() => GratitudScreenState();
}

class GratitudScreenState extends State<GratitudScreen> {
  String userName = "Usuario";
  // String message = "Tomemos unos minutos para reflexionar sobre nuestro día.";
  // List<String> messages = [
  //   "La gratitud puede transformar tu día y tu perspectiva.",
  //   "Agradece las pequeñas cosas y la vida se vuelve más grande.",
  //   "Cada día es una nueva oportunidad para agradecer.",
  //   "La gratitud es la clave para la felicidad.",
  //   "Hoy es un buen día para decir gracias."
  // ];

  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();
  final TextEditingController controller3 = TextEditingController();
  final ControllerServices service = Get.find<ControllerServices>();

  final RxBool isFilled1 = false.obs;
  final RxBool isFilled2 = false.obs;
  final RxBool isFilled3 = false.obs;
  final AudioPlayer player = AudioPlayer();
  final RxBool isPlaying = false.obs;

  Timer? _timer;
  Timer? _messageTimer;
  int _elapsedSeconds = 0;
  bool _isRunning = false;
  bool _isStopped = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    service.fetchFraseMotivacional(widget.categoryId, widget.methodId);
    // _startMessageRotation();

    player.onPlayerComplete.listen((event) {
      isPlaying.value = false;
    });

     player.setAudioContext(AudioContext(
      android: const AudioContextAndroid(
        isSpeakerphoneOn: true,
        stayAwake: true,
        contentType: AndroidContentType.music,
        usageType: AndroidUsageType.media,
        audioFocus: AndroidAudioFocus.gain,
      ),
      iOS: const AudioContextIOS(
        category: AVAudioSessionCategory.playback,
        options: [AVAudioSessionOptions.defaultToSpeaker],
      ),
    ));

    controller1.addListener(() => checkFilled(controller1, isFilled1));
    controller2.addListener(() => checkFilled(controller2, isFilled2));
    controller3.addListener(() => checkFilled(controller3, isFilled3));
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists && userDoc['name'] != null) {
        setState(() {
          userName = userDoc['name'];
        });
      }
    }
  }

  // void _startMessageRotation() {
  //   _messageTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
  //     if (mounted) {
  //       setState(() {
  //         message = (messages..shuffle()).first;
  //       });
  //     }
  //   });
  // }

  void checkFilled(TextEditingController controller, RxBool isFilled) {
    isFilled.value = controller.text.length >= 120;
  }

  void _startTimer() {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
      _isStopped = false;
      _elapsedSeconds = 0;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  void _stopTimer() {
    if (!_isRunning) return;

    setState(() {
      _isRunning = false;
      _isStopped = true;
    });

    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _messageTimer?.cancel();
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4475D5),
        centerTitle: true, 
        automaticallyImplyLeading: false,
        title: const Text(
          "Ejercicio de Gratitud",
          style: TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
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
            stops: [0.0, 0.53, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 800,
                        height: 220,
                        child: CachedNetworkAsset(
                          url: 'https://firebasestorage.googleapis.com/v0/b/psicologia-app-liid.firebasestorage.app/o/images%2Fvoz.png?alt=media&token=6f376c2d-a533-4d5a-9a3e-d2e65780fff4',
                          fit: BoxFit.contain,
                        ),
                      ),
                      Positioned(
                        top: 60,
                        left: 117,
                        right: 100,
                        bottom: 2,
                        child: Obx(() {
                          final frase = service.fraseMotivacional.value;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hola, $userName",
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                frase.isNotEmpty ? frase : "Cargando descripción...",
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                      Positioned(
                        top: 0,
                        left: 80,
                        child: Obx(() {
                          final audioUrl = service.audioUrlMotivacional.value;
                          if (audioUrl.isEmpty) return const SizedBox.shrink();
                          return GestureDetector(
                            onTap: () async {
                              final audioUrl = service.audioUrlMotivacional.value;
                              try {
                                if (isPlaying.value) {
                                  await player.pause();
                                  isPlaying.value = false;
                                } else {
                                  await player.play(UrlSource(audioUrl));
                                  isPlaying.value = true;
                                }
                              } catch (e) {
                                print("Error: $e");
                                Get.snackbar("Error", "No se pudo reproducir el audio.");
                              }
                            },
                            child: Container(
                              width: 56,
                              height: 56,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                              ),
                              child: Obx(() => Icon(
                                isPlaying.value ? Icons.pause : Icons.play_arrow,
                                color: Colors.purple,
                                size: 32,
                              )),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),


                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CachedNetworkAsset(
                        url: 'https://firebasestorage.googleapis.com/v0/b/psicologia-app-liid.firebasestorage.app/o/images%2Fmarciano.png?alt=media&token=3ed0d751-264c-4b62-b6cf-4e93b877bc58',
                        width: 180,
                        height: 172,
                      ),

                      const SizedBox(width: 20),

                      Column(
                        children: [
                          Text(
                            "${_elapsedSeconds}s",
                            style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: _isRunning ? _stopTimer : _startTimer,
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                            child: Text(_isRunning ? "Finalizar" : "Comenzar", style: const TextStyle(color: Colors.black)),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  buildTextField("COSA 1", controller1, isFilled1),
                  const SizedBox(height: 20),

                  buildTextField("COSA 2", controller2, isFilled2),
                  const SizedBox(height: 20),

                  buildTextField("COSA 3", controller3, isFilled3),

                  const SizedBox(height: 40),

                  ElevatedButton(
                    onPressed: _isStopped
                        ? () async {
                            if (controller1.text.isNotEmpty &&
                                controller2.text.isNotEmpty &&
                                controller3.text.isNotEmpty) {
                              await service.saveGratitudeExercise(
                                widget.categoryId,
                                widget.methodId,
                                [controller1.text, controller2.text, controller3.text],
                                duration: _elapsedSeconds,
                              );
                              Get.find<HomeController>().goToResumenGratitud(widget.categoryId, widget.methodId);
                            } else {
                              Get.snackbar("Atención", "Por favor, completa todas las respuestas.");
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                    ),
                    child: const Text('Terminar', style: TextStyle(color: Colors.black)),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, RxBool isFilled) {
    return Obx(() => Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(top: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: isFilled.value ? Colors.green : Colors.black,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: controller,
                maxLength: 120,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  counterText: "",
                ),
                style: const TextStyle(fontSize: 16),
              ),
            ),

            Positioned(
              top: 0,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(
                    color: isFilled.value ? Colors.green : Colors.black,
                    width: 2,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            if (isFilled.value)
              Positioned(
                top: 8,
                right: 12,
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 24,
                ),
              ),
          ],
        ));
  }
}
