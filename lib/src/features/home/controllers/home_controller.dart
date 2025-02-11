import 'package:get/get.dart';
import '../../auth/login_form_provider.dart';
import '../views/Cuestionario_Entrada.dart';

import '../views/Tematicas.dart';
import '../views/Complete_Cuestionario.dart';
import '../views/revision.dart';
import '../views/Menu.dart';
import '../views/Tecnicas.dart';
import '../views/ResumenTecnica.dart';
import '../views/Logros.dart';
import '../views/EjercicioGratitud.dart';
import '../views/Estadistica.dart';
import '../views/EscrituraExpresiva.dart';
import 'dart:async';

class HomeController extends GetxController {
  bool delay = true;

  

  void goToInicioSesion() async {
    if (delay) await Future.delayed(const Duration(seconds: 2));
    delay=false;
    Get.off(() => const InicioSesion(),transition: Transition.fade,duration: const Duration(milliseconds: 500));
  }

  void goToTematicasP() {
    Get.off(() => const Tematicas_P(),transition: Transition.fade,duration: const Duration(milliseconds: 500),
    );
  }

  void goToCuestionario(String categoryId) {
  Get.off(() => PantallaCuestionario(categoryId: categoryId), 
    transition: Transition.fade, 
    duration: const Duration(milliseconds: 500),
  );
}

  void goToComplete(int totalScore, String categoryId) {
    Get.off(() => Complete(totalScore: totalScore, categoryId: categoryId),
        transition: Transition.upToDown,
        duration: const Duration(milliseconds: 500));
  }


  void goToInforme(String categoryId) {
  Get.off(() => PantallaInforme(categoryId: categoryId),
      transition: Transition.circularReveal,
      duration: const Duration(milliseconds: 1000)); 
}


  void goToMenu(String categoryId) {
  Get.to(() => Menu(categoryId: categoryId));
}

   void goToT1(String categoryId, String methodId) {
    Get.off(() => Tecnicas(categoryId: categoryId.toLowerCase(), methodId: methodId.toLowerCase()),
        transition: Transition.fade,
        duration: const Duration(milliseconds: 500)); 
  }

  void goToResumenTecnica(){
    Get.off(()=> const ResumenTecnica(),transition: Transition.downToUp,duration: const Duration(microseconds: 1000));
  }
  void goToLogros(){
    Get.off(()=> const LogrosScreen(),transition: Transition.downToUp,duration: const Duration(microseconds: 1000));
  }
  void goToEjercicioG(){
    Get.off(()=> const GratitudScreen(),transition: Transition.zoom,duration: const Duration(microseconds: 1000));
  }
  void goToEstadistica(){
    Get.off(()=> const ResumenEjercicioScreen(),transition: Transition.downToUp,duration: const Duration(microseconds: 1000));
  }
  void goToEspresivo(){
    Get.off(()=> const EscrituraExpresivaScreen(),transition: Transition.downToUp,duration: const Duration(microseconds: 1000));
  }
}


















