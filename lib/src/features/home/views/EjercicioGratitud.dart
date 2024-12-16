import 'package:flutter/material.dart';

void main() {
  runApp(const GratitudScreen());
}

class GratitudScreen extends StatelessWidget {
  const GratitudScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    padding: EdgeInsets.only(top: 1.0, bottom: 1.0),
                    child: Text(
                      'Ejercicio de Gratitud',
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
                        'img/voz.png',
                        width: 270,
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                      const Positioned(
                        child: Text(
                          'Hola Mateo,'
                          'tomemos unos minutos '
                          'para\nreflexionar sobre'
                          'nuestro día. La gratitud\n'
                          'puede transformar tu día y tu \n'
                          'perspectiva.',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Fila con elementos
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Primera imagen en la fila
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Image.asset(
                          'img/marciano.png',
                          width: 180,
                          height: 140,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        children: [
                          // Imagen reloj
                          Image.asset(
                            'img/relo.png',
                            width: 70,
                            height: 70,
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
                                  horizontal: 50,
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
                  // Imágenes alineadas
                  SizedBox(
                    width: double.infinity,
                    child: Stack(
                      children: [
                        // Primera imagen: centrada a la izquierda
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Image.asset(
                            'img/cosa1.png',
                            width: 310,
                            height: 200,
                          ),
                        ),
                        // Segunda imagen: centrada a la derecha
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 150),
                            // Ajusta separación vertical
                            child: Image.asset(
                              'img/cosa2.png',
                              width: 310,
                              height: 200,
                            ),
                          ),
                        ),
                        // Tercera imagen: centrada a la izquierda
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 300),
                            // Ajusta separación vertical
                            child: Image.asset(
                              'img/cosa3.png',
                              width: 310,
                              height: 190,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Botón final
                  ElevatedButton(
                    onPressed: () {},
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
