import 'package:get/get.dart';
import 'package:psicologia_app_liid/features/auth/login/login_form_provider.dart' as login;
import 'package:psicologia_app_liid/features/auth/register/register_user.dart' as register;
import 'package:psicologia_app_liid/features/home/views/estres/activity_three/ResumenEjercicioEE.dart';
import 'package:psicologia_app_liid/features/home/views/estres/activity_two/ResumenEjercicio.dart';
import '../views/Cuestionario_Entrada.dart';
import '../views/Tematicas.dart';
import '../views/Complete_Cuestionario.dart';
import '../views/revision.dart';
import '../views/Menu.dart';
import '../views/estres/activity_one/Tecnicas.dart';
import '../views/Logros.dart';
import '../views/estres/activity_two/EjercicioGratitud.dart';
import '../views/estres/activity_one/Estadistica.dart';
import '../views/estres/activity_three/EscrituraExpresiva.dart';
import 'dart:async';

class HomeController extends GetxController {
  bool delay = true;

  void goToInicioSesion() async {
    if (delay) await Future.delayed(const Duration(seconds: 2));
    delay=false;
    Get.off(() => const login.InicioSesion(),transition: Transition.fade,duration: const Duration(milliseconds: 500));
  }

  void goToRegistro() {
    Get.to(() => const register.RegistroUsuario(), 
      transition: Transition.fade, 
      duration: const Duration(milliseconds: 500),
    );
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

  void goToEstadistica(String categoryId, String methodId){
    Get.off(()=> ResumenEjercicioScreen(categoryId: categoryId.toLowerCase(), methodId: methodId.toLowerCase()), transition: Transition.downToUp, duration: const Duration(milliseconds: 1000));
  }

  void goToLogros(String categoryId, String methodId) {
    Get.off(
      () => LogrosScreen(categoryId: categoryId, methodId: methodId),
      transition: Transition.downToUp,
      duration: const Duration(milliseconds: 1000),
    );
  }


  void goToResumenGratitud(String categoryId, String methodId) {
    Get.off(
      () => ResumenGratitudScreen(
        categoryId: categoryId,
        methodId: methodId,
      ),
      transition: Transition.downToUp,
      duration: const Duration(milliseconds: 1000),
    );
  }

  void goToEjercicioG(String categoryId, String methodId){
    Get.off(() => GratitudScreen(categoryId: categoryId.toLowerCase(), methodId: methodId.toLowerCase()),transition: Transition.zoom,duration: const Duration(microseconds: 1000));
  }

  void goToResumenExpresiva(String categoryId, String methodId) {
    Get.off(() => ResumenExpresivaScreen(categoryId: categoryId, methodId: methodId),
      transition: Transition.downToUp,
      duration: const Duration(milliseconds: 1000),
    );
  }

  void goToEspresivo(String categoryId, String methodId){
    Get.off(()=> EscrituraExpresivaScreen(categoryId: categoryId.toLowerCase(), methodId: methodId.toLowerCase()),transition: Transition.zoom,duration: const Duration(microseconds: 1000));
  }

}


















