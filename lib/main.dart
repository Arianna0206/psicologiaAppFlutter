import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/date_symbol_data_local.dart';
// import 'package:psicologia_app_liid/config/local_notifications/local_notifications.dart';
import 'package:psicologia_app_liid/presentation/blocs/notifications/notifications_bloc.dart';
import 'package:psicologia_app_liid/features/home/controllers/home_controller.dart';
import 'package:psicologia_app_liid/features/home/controllers/controller_services.dart';
import 'package:psicologia_app_liid/features/home/controllers/controller_inicio.dart';

// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print("Notificación recibida en segundo plano: ${message.notification?.title}");
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting('es_ES', '');

  // void _onNotificationTapped(NotificationResponse response) {
  //   print("Notificación tocada: ${response.payload}");
  // }

  // await LocalNotifications.initializeLocalNotifications(_onNotificationTapped);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await _requestNotificationPermission();

  Get.lazyPut<ControllerInicio>(() => ControllerInicio(), fenix: true);
  Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
  Get.put(ControllerServices(), permanent: true);


  runApp(MultiBlocProvider(
    providers: [BlocProvider(create: (_) => NotificationsBloc())],
    child: const MainApp()));
}


class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      smartManagement: SmartManagement.keepFactory,
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            homeController.goToTematicasP();
          });
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            homeController.goToInicioSesion();
          });
        }

        return const SizedBox
            .shrink(); 
      },
    );
  }
}

  Future<void> _requestNotificationPermission() async {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;

    if (Platform.isAndroid) {
      final settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: true,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        print("Permiso de notificaciones denegado.");
      } else {
        print("Permiso de notificaciones concedido: ${settings.authorizationStatus}");
      }
    }
  }


