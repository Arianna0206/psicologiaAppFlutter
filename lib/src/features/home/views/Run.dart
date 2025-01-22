import 'package:flutter/material.dart';
import '../controllers/controller_Inicio.dart';
import 'package:get/get.dart';


class Inicio extends StatefulWidget {
  const Inicio({super.key});
  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  final ControllerInicio _homeController = Get.find<ControllerInicio>();
  late bool isConnected = false;

  @override
  void initState() {
    super.initState();
    _checkConnectionAndSetup();
    _homeController.startMessageTimer();
  }
  Future<void> _checkConnectionAndSetup() async {
    isConnected = await _homeController.checkInternetConnection();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF398AD5),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Fondo de la pantalla
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF398AD5),
                  Color(0xFFF8F8F8),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "ALKIUM",
                  style: TextStyle(color: Colors.white, fontSize: 40),
                ),
                const Text(
                  "Desarrollo personal,\nmental y emocional",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                const Text(
                  "Psicología Clínica",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 23),
                Container(
                  width: 139,
                  height: 50,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFAEFFFF), Color(0xFF497FC8)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(60)),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                    ),
                    onPressed: () {_homeController.goToPantallaCarga();},
                    child: const Text(
                      "INICIAR",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Align(
                  alignment: Alignment.centerRight,
                  child: Image.asset(
                    'lib/assets/images/marciano.png',
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Image.asset(
                    'lib/assets/images/pie.png',
                    width: 100,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          Obx(() => AnimatedOpacity(
            opacity: _homeController.showMessage.value ? 1.0 : 0.0,
            duration: const Duration(seconds: 1),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(color: isConnected ? Colors.green : Colors.red, borderRadius: BorderRadius.circular(10),),
                child: Text(isConnected ? "Tienes conexión a Internet"  : "No hay conexión a Internet",
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }
}

























