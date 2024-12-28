import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

void main() {
  runApp(const Tecnica5());
}

class Tecnica5 extends StatelessWidget {
  const Tecnica5({super.key});

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
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Primer container
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: const Text(
                        'TU PROGRESO CON LA TÉCNICA',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: Colors.white),
                      ),
                    ),

                    // Segundo container
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text(
                            'Estiramiento del cuello',
                            style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(height: 5),
                          // Imagen centrada
                          Image.asset(
                            'lib/assets/images/voz6.png',
                            width: 270,
                            height: 270,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'lib/assets/images/marciano.png',
                                width: 170,
                                height: 170,
                              ),
                              const SizedBox(width: 50),
                              Image.asset(
                                'lib/assets/images/relo.png',
                                width: 80,
                                height: 80,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                ),
                                child: const Text('Comenzar'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Tercer container
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 299,
                                height: 252,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(48),
                                ),
                              ),
                              Image.asset(
                                'lib/assets/images/voz2.png',
                                width: 250,
                                height: 212,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {homeController.goToResumenTecnica();},
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          ),
                          child: const Text('Siguiente ejercicio'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
