import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psicologia_app_liid/features/home/controllers/home_controller.dart';
import 'package:psicologia_app_liid/features/home/controllers/controller_services.dart';
import 'package:psicologia_app_liid/shared/widgets/cached_image.dart';

class EscrituraExpresivaScreen extends StatefulWidget {
  final String categoryId;
  final String methodId;

  const EscrituraExpresivaScreen(
      {super.key, required this.categoryId, required this.methodId});

  @override
  State<EscrituraExpresivaScreen> createState() =>
      _EscrituraExpresivaScreenState();
}

class _EscrituraExpresivaScreenState extends State<EscrituraExpresivaScreen>
    with SingleTickerProviderStateMixin {
  final HomeController homeController = Get.find<HomeController>();
  final ControllerServices service = Get.find<ControllerServices>();

  final RxBool isPlaying = false.obs;
  final AudioPlayer player = AudioPlayer();
  late final AnimationController _animationController;
  late final Animation<double> scaleAnimation;
  final TextEditingController _textController = TextEditingController();
  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _isRunning = false;
  bool _isStopped = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
      service.fetchFraseMotivacional(widget.categoryId, widget.methodId);
    });

    player.onPlayerComplete.listen((event) {
      isPlaying.value = false;
    });

    _textController.addListener(() {
      setState(() {});
    });
  }

  void _startTimer() {
    if (_isRunning) return;
    setState(() {
      _isRunning = true;
      _isStopped = false;
      // _elapsedSeconds = 0;
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

  void _saveEscrituraExpresiva() async {
    await service.saveExpressiveExercise(
      widget.categoryId,
      widget.methodId,
      _textController.text,
      duration: _elapsedSeconds,
    );
    homeController.goToResumenExpresiva(widget.categoryId, widget.methodId);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    _textController.dispose();
    player.dispose();
    super.dispose();
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Escritura expresiva',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Stack(
                  children: [
                    // Imagen del globo de voz
                    CachedNetworkAsset(
                      url:
                          'https://firebasestorage.googleapis.com/v0/b/psicologia-app-liid.firebasestorage.app/o/images%2Fvoz.png?alt=media&token=6f376c2d-a533-4d5a-9a3e-d2e65780fff4',
                      width: 280,
                      height: 270,
                      fit: BoxFit.contain,
                    ),

                    // Botón de audio (posicionado arriba)
                    Obx(() {
                      final audioUrl = service.audioUrlMotivacional.value;
                      if (audioUrl.isEmpty) return const SizedBox.shrink();

                      return Positioned(
                        top: 20,
                        right: 20,
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
                              Get.snackbar(
                                  "Error", "No se pudo reproducir el audio.");
                            }
                          },
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: Colors.black26, blurRadius: 4)
                              ],
                            ),
                            child: Obx(() => Icon(
                                  isPlaying.value
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: Colors.purple,
                                  size: 32,
                                )),
                          ),
                        ),
                      );
                    }),

                    // Texto de la frase (centrado dentro del globo)
                    Obx(() {
                      final frase = service.fraseMotivacional.value;
                      return Positioned(
                        top: 90,
                        left: 30,
                        right: 40,
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth:
                                  200, 
                            ),
                            child: Text(
                              frase.isNotEmpty ? frase : 'Cargando frase...',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CachedNetworkAsset(
                      url:
                          'https://firebasestorage.googleapis.com/v0/b/psicologia-app-liid.firebasestorage.app/o/images%2Fmarciano.png?alt=media&token=3ed0d751-264c-4b62-b6cf-4e93b877bc58',
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(width: 30),
                    Column(
                      children: [
                        Text(
                          "$_elapsedSeconds s",
                          style: const TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _isRunning ? _stopTimer : _startTimer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFBC57B8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 10),
                          ),
                          child: Text(_isRunning ? 'Finalizar' : 'Comenzar',
                              style: const TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 350,
                      height: 350,
                      padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: TextField(
                        controller: _textController,
                        maxLines: null,
                        expands: true,
                        decoration: const InputDecoration.collapsed(
                            hintText: 'Escribe aquí...'),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    Positioned(
                      top: -20,
                      left: 140,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.black, width: 2),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Tu desafío",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed:
                      (_isStopped && _textController.text.trim().isNotEmpty)
                          ? _saveEscrituraExpresiva
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 10),
                  ),
                  child: const Text('Terminar',
                      style: TextStyle(color: Colors.black)),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
