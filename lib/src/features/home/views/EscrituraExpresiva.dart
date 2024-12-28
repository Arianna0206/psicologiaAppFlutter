import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

void main() {
  runApp(const EscrituraExpresivaScreen());
}

class EscrituraExpresivaScreen extends StatelessWidget {
  const EscrituraExpresivaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();
    return MaterialApp(
      home: Scaffold(
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Título principal
                  const Padding(
                    padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                    child: Text(
                      'Escritura Expresiva',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Imagen principal con texto superpuesto
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'lib/assets/images/voz.png',
                        width: 280,
                        height: 270,
                        fit: BoxFit.contain,
                      ),
                      const Positioned(
                        child: Text(
                          'Hola Mateo,'
                              'tomemos unos minutos '
                              'para\nreflexionar sobre'
                              'nuestro día.La gratitud\n'
                              'puede transformar tu día\n'
                              'y tu perspectiva.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Fila con elementos
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Primera imagen en la fila
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Image.asset(
                          'lib/assets/images/marciano.png',
                          width: 150,
                          height: 150,
                        ),
                      ),
                      const SizedBox(width: 30),
                      Column(
                        children: [
                          // Imagen reloj
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Image.asset(
                              'lib/assets/images/relo.png',
                              width: 80,
                              height: 80,
                            ),
                          ),
                          const SizedBox(height: 5),
                          // Botón "Comenzar"
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFBC57B8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 10,
                                )
                            ),
                            child: const Text(
                              'Comenzar',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Imagen grande centrada
                  Center(
                    child: Image.asset(
                      'lib/assets/images/desafio.png',
                      width: 350,
                      height: 350,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Botón final
                  ElevatedButton(
                    onPressed: () {homeController.goToEstadistica();},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 100,
                        vertical: 10,
                      ),
                    ),
                    child: const Text(
                      'Terminar',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 30), // Espacio final
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
