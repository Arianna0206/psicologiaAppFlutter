import 'package:flutter/material.dart';
import 'inicio_secion.dart';
import '../../../shared/widgets/Animations.dart';

void main() {
  runApp(const PantallaCarga());
}

class PantallaCarga extends StatelessWidget {
  const PantallaCarga({super.key});

  @override
  Widget build(BuildContext context) {

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil(context,fade(const InicioSecion()),(Route<dynamic> route) => false);
    });
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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [


                Image.asset(
                  'img/marciano2.png',
                  width: 260,
                  height: 260,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20),

                const Text(
                  'Cargando.....',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
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
