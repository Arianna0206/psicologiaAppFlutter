import 'package:flutter/material.dart';

void main() {
  runApp(const Tecnica1());
}

class Tecnica1 extends StatelessWidget {
  const Tecnica1({super.key});

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
                            'img/voz.png',
                            width: 270,
                            height: 270,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'img/marciano.png',
                                width: 170,
                                height: 170,
                              ),
                              const SizedBox(width: 50),
                              Image.asset(
                                'img/relo.png',
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
                                'img/voz2.png',
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
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        ),
                        child: const Text('Siguiente ejercicio'),
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


List<String> procesarNumeros(List<int> numeros) {
  var filtrados = numeros.where((n) => n > 5).toList();

  var mapeados = filtrados.map((n) {
    bool esPar = n % 2 == 0;
    return '$n es ${esPar ? "par" : "impar"}';
  }).toList();
  mapeados.forEach((mensaje) {
    print(mensaje);
  });
  procesarNumeros(numeros);
  return mapeados;
}
