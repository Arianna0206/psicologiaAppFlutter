import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

void main() {
  runApp(const LogrosScreen());
}

class LogrosScreen extends StatelessWidget {
  const LogrosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
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
                  // Contenedor Padre
                  Column(
                    children: [
                      // Contenedor A
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Column(
                          children: [
                            // Título principal
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              child: Text(
                                'LOGROS',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            // ScrollPane mediano debajo del título
                            Container(
                              height: 150 * (screenHeight / 880), // Escalar altura según la pantalla
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(horizontal: 20.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const SingleChildScrollView(
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    "Contenido de logros\n",
                                    style: TextStyle(fontSize: 16, color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Contenedor con imagen y ScrollPane pequeño
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  // Imagen
                                  Image.asset(
                                    'lib/assets/images/marciano3.png',
                                    width: 180 * (screenWidth / 450), // Escalar ancho
                                    height: 180 * (screenHeight / 850), // Escalar altura
                                  ),
                                  const SizedBox(width: 15),
                                  // ScrollPane pequeño
                                  Expanded(
                                    child: Container(
                                      height: 200 * (screenHeight / 900), // Escalar altura
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const SingleChildScrollView(
                                        child: Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Text(
                                            "Contenido adicional\n",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Elementos debajo de Contenedor A
                      const Text(
                        'RECORDATORIO',
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Rectángulo centrado
                      Container(
                        width: 410 * (screenWidth / 440), // Escalar ancho
                        height: 75 * (screenHeight / 900), // Escalar altura
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Fila de botones
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Diariamente',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Semanal',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Personalizada',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      // Botón final MENÚ
                      ElevatedButton(
                        onPressed: () {homeController.goToMenu();},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 50 * (screenWidth / 400),
                            vertical: 15 * (screenHeight / 800),
                          ),
                        ),
                        child: const Text(
                          'Menú',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 60), // Espacio final
                    ],
                  ),
                 // Salto de línea final
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
