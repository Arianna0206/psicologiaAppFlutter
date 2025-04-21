import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'package:get/get.dart';
// import '../../../../features/home/views/pantalla_carga.dart';

class ControllerInicio extends GetxController {
  bool delay = true;
  final RxBool _isConnected = RxBool(false);
  var showMessage = true.obs;

  Future<bool> checkInternetConnection() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      _isConnected.value = connectivityResult.contains(ConnectivityResult.wifi) || connectivityResult.contains(ConnectivityResult.mobile);
      return _isConnected.value;
    } catch (e) {
      _isConnected.value = false;
      return false;
    }
  }

  // void goToInicio() async {
  //   if (delay) await Future.delayed(const Duration(seconds: 1));
  //   Get.off(() => const Inicio(),transition: Transition.fade,duration: const Duration(milliseconds: 1000));
  // }

  void startMessageTimer() {
    Timer(const Duration(seconds: 4), () {
      showMessage.value = false;
    });
  }
  // void goToPantallaCarga() {
  //   Get.off(() => const PantallaCarga(),transition: Transition.fade,duration: const Duration(milliseconds: 2000)
  //   );
  // }
}