import 'package:get/get.dart';
import '../views/Cuestionario_Entrada.dart';
import '../views/inicio_secion.dart';
import '../views/Tematicas.dart';
import '../views/Complete_Cuestionario.dart';
import '../views/revision.dart';
import '../views/Menu.dart';
import '../views/Tecnica_1.dart';
import '../views/Tecnica_2.dart';
import '../views/Tecnica_3.dart';
import '../views/Tecnica_4.dart';
import '../views/Tecnica_5.dart';
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
    Get.off(() => const InicioSecion(),transition: Transition.fade,duration: const Duration(milliseconds: 500));
  }

  void goToTematicasP() {
    Get.off(() => const Tematicas_P(),transition: Transition.fade,duration: const Duration(milliseconds: 500),
    );
  }

  void goToCuestionario() {
    Get.off(() => const PantallaCuestionario(), transition: Transition.fade, duration: const Duration(milliseconds: 500));
  }

  void goToComplete(){
    Get.off(() => const Complete(),transition: Transition.upToDown,duration: const Duration(milliseconds: 500));
  }

  void goToInforme(){
    Get.off(()=> const PantallaInforme(),transition: Transition.circularReveal,duration: const Duration(microseconds: 1000));
  }

  void goToMenu(){
    Get.off(()=> const Menu(),transition: Transition.fade,duration: const Duration(microseconds: 500));
  }

  void goToT1(){
    Get.off(()=> const Tecnica1(),transition: Transition.fade,duration: const Duration(microseconds: 500));
  }

  void goToT2(){
    Get.off(()=> const Tecnica2(),transition: Transition.downToUp,duration: const Duration(microseconds: 1000));
  }

  void goToT3(){
    Get.off(()=> const Tecnica3(),transition: Transition.downToUp,duration: const Duration(microseconds: 1000));
  }

  void goToT4(){
    Get.off(()=> const Tecnica4(),transition: Transition.downToUp,duration: const Duration(microseconds: 1000));
  }

  void goToT5(){
    Get.off(()=> const Tecnica5(),transition: Transition.downToUp,duration: const Duration(microseconds: 1000));
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


















