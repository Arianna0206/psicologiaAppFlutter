import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class PantallaCarga extends StatefulWidget {
  const PantallaCarga({super.key});
  @override
  _PantallaCargaState createState() => _PantallaCargaState();
}

class _PantallaCargaState extends State<PantallaCarga> {
  final HomeController _homeController = Get.find();

  @override
  void initState() {
    super.initState();
    _homeController.goToInicioSesion();
  }

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
              Color(0xFFF8F8F8),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/assets/images/marciano2.png',
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
    );
  }
}
