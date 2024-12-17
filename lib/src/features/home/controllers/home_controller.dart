import 'package:get/get.dart';
import '../views/inicio_secion.dart';
import '../views/pantalla_carga.dart';
import '../views/Tematicas.dart';

class HomeController extends GetxController {
  void goToPantallaCarga() {
    Get.off(() => const PantallaCarga(),transition: Transition.fade,duration: const Duration(milliseconds: 2000)
    );
  }
  void goToInicioSesion() async {
    await Future.delayed(const Duration(seconds: 2));
    Get.off(() => const InicioSecion(),transition: Transition.fade,duration: const Duration(milliseconds: 2000));
  }
  void goToTematicasP() {
    Get.to(() => const Tematicas_P(),transition: Transition.fade,duration: const Duration(milliseconds: 500),
    );
  }

}