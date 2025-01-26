import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../home/controllers/controller_services.dart';
import '../home/controllers/home_controller.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const Intermediario());
}

class Intermediario extends StatelessWidget {
  const Intermediario({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InicioSesion(), // Corrige nombre (de "InicioSecion" a "InicioSesion")
    );
  }
}

class InicioSesion extends StatefulWidget {
  const InicioSesion({super.key});

  @override
  State<InicioSesion> createState() => _InicioSesionState();
}

class _InicioSesionState extends State<InicioSesion> {
  late final HomeController _homeController = Get.find<HomeController>(); // Controlador para navegación
  final ControllerServices service = Get.find<ControllerServices>(); // Controlador para flujo de colores dinámicos
  final AuthService _authService = AuthService(); // Servicio de autenticación

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF398AD5), // Color superior
              Color(0xFFF8F8F8), // Color inferior
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Imagen decorativa
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

                    // Botón dinámico (basado en StreamBuilder)
                    StreamBuilder<int>(
                      stream: service.colorStream, // Flujo de colores
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator(); // Indicador de carga
                        }
                        if (snapshot.hasError) {
                          return const Text('Error al cargar el color'); // Error
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
                                // Nuevo: Acción del botón UTPL
                                Get.snackbar(
                                  'UTPL',
                                  'Botón dinámico activado con color ${snapshot.data!}',
                                );
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

                    // Botón para iniciar sesión con Google
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
                        onPressed: () async {
                          // Nuevo: Lógica de inicio de sesión con Google
                          final user = await _authService.signInWithGoogle();
                          if (user != null) {
                            Get.snackbar(
                              'Bienvenido',
                              'Inicio de sesión exitoso: ${user.displayName}',
                            );
                            _homeController.goToTematicasP(); // Navegar a temáticas
                          } else {
                            Get.snackbar(
                              'Error',
                              'No se pudo iniciar sesión con Google',
                            );
                          }
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
