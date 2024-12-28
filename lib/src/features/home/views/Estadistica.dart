import 'package:flutter/material.dart';

void main() {
  runApp(const ResumenEjercicioScreen());
}

class ResumenEjercicioScreen extends StatelessWidget {
  const ResumenEjercicioScreen({super.key});

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
                  // Contenedor Padre
                  Column(
                    children: [
                      // Contenedor A
                      Container(
                        child: Column(
                          children: [
                            // Título
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                'RESUMEN DEL EJERCICIO',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            // Fila con imagen y texto
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Imagen: Copa
                                Image.asset(
                                  'lib/assets/images/copa.png',
                                  width: 180,
                                  height: 180,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(width: 40), // Espaciado entre imagen y texto
                                // Texto a la derecha
                                const Flexible(
                                  child: Text(
                                    "¡Excelente\ntrabajo! La\ngratitud diaria\npuede tener un\ngran impacto en\ntu bienestar.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30), // Espaciado después de la fila
                            // Botón "Ver Logros"
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 10,
                                ),
                              ),
                              child: const Text(
                                'Ver Logros',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            const SizedBox(height: 60), // Espaciado después del botón
                            // Rectángulo blanco
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final screenWidth = constraints.maxWidth;
                                final screenHeight =
                                    MediaQuery.of(context).size.height;
                                return Container(
                                  width: screenWidth * 0.9,
                                  height: screenHeight * 0.065,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(60),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30), // Espaciado después del contenedor A

                      // Elementos adicionales debajo de Contenedor A
                      Container(
                        width: 400,
                        height: 225,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white,
                            width: 1,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'Rendimiento de ejercicio',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10), // Espaciado
                      // Rectángulo blanco más pequeño
                      Container(
                        width: 400,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      const SizedBox(height: 20), // Espaciado
                      // Botón "Menú"
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 10,
                          ),
                        ),
                        child: const Text(
                          'Menú',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 30), // Espaciado final
                    ],
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
