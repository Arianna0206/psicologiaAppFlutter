import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psicologia_app_liid/features/home/controllers/home_controller.dart';

class Complete extends StatelessWidget {
  final int totalScore; 
  final String categoryId; 

  const Complete({super.key, required this.totalScore, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF398AD5),
              Color(0xFF516FD1),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Image.asset(
                _getRobotImage(totalScore), 
                width: 150,
                height: 150,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20), 
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    const Text(
                      'Gracias por completar el cuestionario.\n\n'
                      'Tu nivel de estrés es:\n',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      _interpretStressLevel(totalScore), 
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.yellow,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40), 
                    const Text(
                      'A continuación,\n generaremos un informe \n personalizado basado en \n tus respuestas.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60), 
              GestureDetector(
                onTap: () {
                  final HomeController homeController = Get.find<HomeController>();
                  homeController.goToInforme(categoryId); 
                },
                child: Container(
                  width: 300,
                  height: 65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/psicologia-app-liid.firebasestorage.app/o/images%2Fbotona.png?alt=media&token=0a2c8c50-2684-42ce-ac7e-6d28641d45fd',
                          width: 300,
                          height: 65,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const Text(
                        'Ver informe',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
    );
  }

 
  String _interpretStressLevel(int score) {
    if (score <= 10) {
      return "Estrés Bajo";
    } else if (score <= 20) {
      return "Estrés Medio";
    } else {
      return "Estrés Alto";
    }
  }

  
  String _getRobotImage(int score) {
    if (score <= 10) {
      return 'lib/assets/images/robot_bajo.png'; 
    } else if (score <= 20) {
      return 'lib/assets/images/robot_medio.png'; 
    } else {
      return 'lib/assets/images/robot_alto.png'; 
    }
  }
}
