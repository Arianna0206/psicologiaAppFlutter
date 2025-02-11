import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psicologia_app_liid/src/shared/widgets/audio_player_widget.dart';
import '../controllers/home_controller.dart';


class PantallaInforme extends StatelessWidget {
  final String categoryId; 

  const PantallaInforme({super.key, required this.categoryId});


  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();
    final AudioService audioService = AudioService();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
                        fontSize: 22,
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
                        fontSize: 15,
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
                          left: 35,
                          child: Text(
                            'Has indicado que\n frecuentemente te encuentras \n en entornos ruidosos.Considera\n el uso de tapones para los oídos\n o la búsqueda de momentos\n tranquilos durante el día para\n reducir la exposición al ruido.',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 11,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                       
                        Positioned(
                          top: 30,
                          right: 15,
                          child: GestureDetector(
                            onTap: () {
                              audioService.playAudio("audios/AudioInformePersonalizado.m4a");
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(
                                Icons.play_circle_fill,
                                color: Color(0xFF9C419E),
                                size: 30,
                              ),
                            ),
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
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Image.asset(
                            'lib/assets/images/mar_R.png',
                            width: 300,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              width: 117,
                              height: 40,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF9C419E),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onPressed: () {
                                  homeController.goToMenu(categoryId); 
                                },
                                child: const Text(
                                  'Siguiente',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
        ),
        bottomNavigationBar: Container(
          color: const Color(0xFF3284FF),
          height: MediaQuery.of(context).size.height * 0.08,
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
