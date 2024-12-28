import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
void main() {
  runApp(const PantallaCuestionario());
}

class PantallaCuestionario extends StatelessWidget {
  const PantallaCuestionario({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFDD76F2),
                  Color(0xFF80448C),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 35.0),
                child: Text(
                  'Cuestionario Breve:Factores\nPredisponentes del Estrés',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
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
          child: Column(
            children: [
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'lib/assets/images/cuadroTextoa.png',
                          width: 295,
                          height: 130,
                          fit: BoxFit.cover,
                        ),
                        const Positioned(
                          top: 45,
                          child: Text(
                            'La información tiene como objetivo\ninvestigativo, sus resultados se presentan\nde manera anónima.',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    Image.asset(
                      'lib/assets/images/corazon.png',
                      width: 130,
                      height: 130,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 20, 20, 70),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: 300,
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4C76D6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        onPressed: () {homeController.goToComplete();},
                        child: const Text(
                          'Siguiente',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
