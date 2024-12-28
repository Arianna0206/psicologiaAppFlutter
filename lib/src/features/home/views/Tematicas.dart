import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

void main() {
  runApp(const Tematicas_P());
}


class Tematicas_P extends StatelessWidget {

  const Tematicas_P({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;
            final maxHeight = constraints.maxHeight;

            final container1Left = maxWidth * 0.1; // Basado en left: 90
            final container1Top = maxHeight * -0.01; // Basado en top: -10

            final container2Left = maxWidth * 0.3; // Basado en left: 180
            final container2Top = maxHeight * 0.18; // Basado en top: 160

            final container3Left = maxWidth * 0.1; // Basado en left: 90
            final container3Top = maxHeight * 0.39; // Basado en top: 350

            final container4Left = maxWidth * 0.3; // Basado en left: 180
            final container4Top = maxHeight * 0.56; // Basado en top: 510

            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF398AD5),
                    Color(0xFFF8F8F8),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: maxHeight * 0.05, left: maxWidth * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            homeController.goToInicioSesion();
                          },
                          child: Container(
                            width: maxWidth * 0.15,
                            height: maxWidth * 0.08,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Color(0xFF398AD5),
                              size: 30,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Center(
                          child: Text(
                            'Selecciona una \n temática',
                            style: TextStyle(
                              fontSize: 29,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: SizedBox(
                      width: maxWidth * 0.77,
                      height: maxHeight * 0.77,
                      child: Stack(
                        children: [
                          // Contenedor 1
                          Positioned(
                            left: container1Left,
                            top: container1Top,
                            child: GestureDetector(
                              onTap: () {homeController.goToCuestionario();},
                              child: SizedBox(
                                width: 169,
                                height: 730,
                                child: Stack(
                                  alignment: Alignment.topCenter,
                                  children: [
                                    Image.asset(
                                      'lib/assets/images/columnaA.png',
                                      width: 169,
                                      height: 730,
                                      fit: BoxFit.cover,
                                    ),
                                    Positioned(
                                      top: 30,
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: const TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'ESTRES\n',
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                              ),
                                            ),
                                            TextSpan(
                                              text: '01',
                                              style: TextStyle(
                                                fontSize: 40,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Contenedor 2
                          Positioned(
                            left: container2Left,
                            top: container2Top,
                            child: SizedBox(
                              width: 169,
                              height: 600,
                              child: Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Image.asset(
                                    'lib/assets/images/columnaB.png',
                                    width: 169,
                                    height: 600,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 30,  // Ajusta la posición del texto
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'ANSIEDAD\n',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '02',
                                            style: TextStyle(
                                              fontSize: 40, // Número más grande
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Contenedor 3
                          Positioned(
                            left: container3Left,
                            top: container3Top,
                            child: SizedBox(
                              width: 169,
                              height: 350,
                              child: Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Image.asset(
                                    'lib/assets/images/columnac.png',
                                    width: 169,
                                    height: 350,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 30,  // Ajusta la posición del texto
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'TRANSTORNOS\n',
                                            style: TextStyle(
                                              fontSize: 19,
                                              color: Colors.white,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '03',
                                            style: TextStyle(
                                              fontSize: 40, // Número más grande
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Contenedor 4
                          Positioned(
                            left: container4Left,
                            top: container4Top,
                            child: SizedBox(
                              width: 169,
                              height: 195,
                              child: Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Image.asset(
                                    'lib/assets/images/columnad.png',
                                    width: 169,
                                    height: 195,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 30,  // Ajusta la posición del texto
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'FOBIAS\n',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '04',
                                            style: TextStyle(
                                              fontSize: 40, // Número más grande
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: Container(
          color: const Color(0xFF3284FF),
          height: 55,
          child: const Center(
            child: Text(
              'LiiD UTPL',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}




