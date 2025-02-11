import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:psicologia_app_liid/src/features/home/controllers/home_controller.dart';
import 'package:psicologia_app_liid/src/features/home/controllers/controller_services.dart';
import 'package:psicologia_app_liid/src/features/home/controllers/controller_inicio.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Inicializa los controladores con Get.put()
  Get.put(ControllerInicio());
  Get.put(HomeController());
  Get.put(ControllerServices());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();

    // Escucha los cambios de autenticación
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Muestra un indicador de carga mientras verifica el estado del usuario
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          // Si el usuario está autenticado, usa el controlador para ir al inicio
          Future.microtask(() => homeController.goToTematicasP());
        } else {
          // Si no está autenticado, usa el controlador para ir al inicio de sesión
          Future.microtask(() => homeController.goToInicioSesion());
        }

        return const SizedBox
            .shrink(); // Retorna un widget vacío mientras se procesa la navegación
      },
    );
  }
}
