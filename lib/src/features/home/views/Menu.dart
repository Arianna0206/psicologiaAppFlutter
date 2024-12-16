import 'package:flutter/material.dart';

void main() {
  runApp(const Menu());
}

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Calculamos las dimensiones responsivas para los rectángulos
    double rect1Width = screenWidth * 0.9; // 90% del ancho de la pantalla
    double rect1Height = screenHeight * 0.07; // Ajuste proporcional para la altura
    double rect2Width = screenWidth * 0.9; // 90% del ancho de la pantalla
    double rect2Height = screenHeight * 0.15; // Ajuste proporcional para la altura
    double rect3Width = screenWidth * 0.94; // 94% del ancho de la pantalla
    double rect3Height = screenHeight * 0.22; // Ajuste proporcional para la altura

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF3284FF),
          title: const Text(
            'IR A TEMATICAS',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.share,color: Colors.white),
              onPressed: () {

              },
            ),
          ],
        ),
        body: Container(
          width: screenWidth,
          height: screenHeight,
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
            child: Column(
              children: [
                // Primer contenedor con texto y rectángulos
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                  child: Column(
                    children: [
                      const Text(
                        'Bienvenido a la búsqueda\n del bienestar',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 60),
                      // Rectángulo con imagen de fondo
                      Container(
                        width: rect1Width,
                        height: rect1Height,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          image: const DecorationImage(
                            image: AssetImage('img/fill.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: rect2Width,
                        height: rect2Height,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(color: Colors.white),
                        ),
                        child: const Center(
                          child: Text(
                            'Recordatorios',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Segundo contenedor con otro rectángulo
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    width: rect3Width,
                    height: rect3Height,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
