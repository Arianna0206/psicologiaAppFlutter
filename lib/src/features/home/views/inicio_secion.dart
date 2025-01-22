import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';
import '../controllers/controller_services.dart';
import 'package:get/get.dart';

void main() {
  runApp(const Intermediario());

}

class Intermediario extends StatelessWidget {
  const Intermediario({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InicioSecion(),
    );
  }
}

class InicioSecion extends StatefulWidget {
  const InicioSecion({super.key});

  @override
  State<InicioSecion> createState() => _InicioSecionState();
}

class _InicioSecionState extends State<InicioSecion> {
  late final HomeController _homeController  = Get.find<HomeController>();
  final ControllerServices service = Get.find<ControllerServices>();


  @override
  void initState() {
    super.initState();
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Image.asset(
                'lib/assets/images/marciano3.png',
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 60),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(48),
                    topRight: Radius.circular(48),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 48,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Inicia Sesión',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),




                    StreamBuilder<int>(
                      stream: service.colorStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          return const Text('Error al cargar el color');
                        }
                        if (snapshot.hasData) {
                          return SizedBox(
                            width: 250,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(snapshot.data!),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(60),
                                ),
                              ),
                              onPressed: () {
                                print("UTPL");
                              },
                              child: const Text(
                                'UTPL',
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ),
                          );
                        }
                        return const Text('Sin datos disponibles');
                      },
                    ),




                    const SizedBox(height: 20),
                    SizedBox(
                      width: 250,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3284FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60),
                          ),
                        ),
                        onPressed: () {
                          _homeController.goToTematicasP();
                        },
                        child: const Text(
                          'Google',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
