import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../home/controllers/controller_services.dart';
import '../../home/controllers/home_controller.dart';
import '../services/auth_service.dart';

class Intermediario extends StatelessWidget {
  const Intermediario({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InicioSesion(),
    );
  }
}

class InicioSesion extends StatefulWidget {
  const InicioSesion({super.key});

  @override
  State<InicioSesion> createState() => _InicioSesionState();
}

class _InicioSesionState extends State<InicioSesion> {
  late final HomeController _homeController = Get.find<HomeController>();
  final ControllerServices service = Get.find<ControllerServices>();
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
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Image.network(
                'https://firebasestorage.googleapis.com/v0/b/psicologia-app-liid.firebasestorage.app/o/images%2FmarcianoLogin.png?alt=media&token=18eb7af9-c30b-4dd8-b134-2abcf42ae056',
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

                    // Botón para iniciar sesión con Google con color dinámico
                    StreamBuilder<int>(
                      stream: service.colorStream,
                      builder: (context, snapshot) {
                        final buttonColor = snapshot.hasData ? Color(snapshot.data!) : const Color(0xFF3284FF);

                        return SizedBox(
                          width: 250,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60),
                              ),
                              elevation: 2,
                            ),
                            onPressed: () async {
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(
                                  'https://firebasestorage.googleapis.com/v0/b/psicologia-app-liid.firebasestorage.app/o/images%2Flogo_google.png?alt=media&token=0cf71c6e-d0a9-4866-b600-5d862962c1ad',
                                  height: 24,
                                  width: 24,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Continuar con Google',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // Navegación a la pantalla de registro
                    TextButton(
                      onPressed: () => _homeController.goToRegistro(),
                      child: const Text("¿No tienes cuenta? Regístrate aquí"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
