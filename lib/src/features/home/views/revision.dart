import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

void main() {
  runApp(const PantallaInforme());
}

class PantallaInforme extends StatelessWidget {
  const PantallaInforme({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();
    return MaterialApp(
      home: Scaffold(
        body: Container(
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
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 75),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'INFORME PERSONALIZADO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 29, // Tamaño mayor
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Basado en tus respuestas al cuestionario, hemos identificado los siguientes factores que pueden estar contribuyendo a tu nivel de estrés. A continuación, te ofrecemos algunas sugerencias personalizadas para abordar estos factores.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'lib/assets/images/cuadroTextob.png',
                          width: 280,
                          height: 260,
                          fit: BoxFit.contain,
                        ),
                        const Positioned(
                          top: 60,
                          left: 30,
                          child: Text(
                            'Has indicado que\n frecuentemente te encuentras \n en entornos ruidosos.Considera\n el uso de tapones para los oídos\n o la búsqueda de momentos\n tranquilos durante el día para\n reducir la exposición al ruido.',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.only(right: 30),
                    child: Transform.translate(
                      offset: const Offset(0, -50),
                      child: Column(
                        children: [
                          Image.asset(
                            'lib/assets/images/mar_R.png',
                            width: 300,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: 110,
                            height: 40,
                            child: Builder(
                              builder: (BuildContext innerContext) {
                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF9C419E),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  onPressed: () {homeController.goToMenu();},
                                  child: const Text(
                                    'Siguiente',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                );
                              },
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
      ),
    );
  }
}
