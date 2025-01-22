import 'package:flutter/material.dart';
import 'package:psicologia_app_liid/src/features/home/controllers/controller_Inicio.dart';
import 'package:psicologia_app_liid/src/features/home/controllers/controller_services.dart';
import 'package:psicologia_app_liid/src/features/home/controllers/home_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().then((value){
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final ControllerInicio homeController = Get.put(ControllerInicio());
    final HomeController _homeController = Get.put(HomeController());
    final ControllerServices services = Get.put(ControllerServices());

    homeController.goToInicio();
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}








