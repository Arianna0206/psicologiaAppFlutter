import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

void main() {
  runApp(const ResumenTecnica());
}

class ResumenTecnica extends StatelessWidget {
  const ResumenTecnica({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener dimensiones de la pantalla
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Contenedor Padre
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: Text(
                              'Resumen de la técnica',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Image.asset(
                            'lib/assets/images/copa.png',
                            width: screenWidth * 0.35,
                            height: screenWidth * 0.35,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const Text(
                          'TU PROGRESO',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Rectángulo con bordes redondeados
                            Container(
                              width: screenWidth * 0.55,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(60),
                              ),
                            ),
                            // Botón con texto blanco
                            ElevatedButton(
                              onPressed: () {homeController.goToLogros();},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white, // Color del fondo del botón
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                              ),
                              child: const Text(
                                'Ver logros',
                                style: TextStyle(color: Colors.black), // Color blanco para el texto
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          'Ejercicio 5 de 5',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 60),
                        Container(
                          width: screenWidth * 0.9,
                          height: screenHeight * 0.065,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(60),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          width: screenWidth * 0.9,
                          height: screenHeight * 0.11,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        const SizedBox(height: 25),
                        Container(
                          width: screenWidth * 0.9,
                          height: screenHeight * 0.17,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          width: screenWidth * 0.9,
                          height: screenHeight * 0.10,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        const SizedBox(height: 30), // Espacio adicional
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
