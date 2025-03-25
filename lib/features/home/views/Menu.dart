import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:psicologia_app_liid/features/home/controllers/controller_services.dart';
import 'package:psicologia_app_liid/shared/widgets/cached_image.dart';
import '../controllers/home_controller.dart';

class Menu extends StatelessWidget {
  final String categoryId;

  const Menu({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();
    final ControllerServices controllerServices = Get.put(ControllerServices());
    

    controllerServices.fetchTechniques(categoryId: categoryId);
    
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double rect3Width = screenWidth * 0.90;
    double rect3Height = screenHeight * 0.35;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF398AD5),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), 
          onPressed: () {
            homeController.goToTematicasP(); 
          },
        ),
        title: GestureDetector(
          child: const Text(
            'IR A TEMÁTICAS',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              shadows: [
                Shadow(
                  offset: Offset(2, 2),
                  blurRadius: 4.0,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF398AD5), Color(0xFFF8F8F8)],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Bienvenido a la búsqueda\n del bienestar',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
           
            const SizedBox(height: 40),
            _buildStressLevelBar(context, categoryId), 
           
            const SizedBox(height: 40),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("categories")
                    .doc(categoryId.toLowerCase().trim())
                    .collection("methods")
                    .orderBy("order")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Error al cargar datos: ${snapshot.error}",
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No hay técnicas disponibles.",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }


                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: controllerServices.techniques.map((tech) {
                        String title = tech["title"] ?? "Sin título";
                        String description = tech["description"] ?? "Sin descripción";
                        String methodId = tech["id"] ?? "";
                        String route = tech.containsKey("route") ? tech["route"] : "";

                        print("Cargando técnica: $title, ID: $methodId, Ruta: $route"); 

                        return _buildTechniqueCard(
                          title,
                          description,
                          tech["order"] ?? 0,
                          () {
                            _navigateToTechnique(homeController, categoryId, methodId, route);
                          },
                          rect3Width,
                          rect3Height,
                        );
                      }).toList(),
                    ),
                  );
                },
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechniqueCard(String title, String description, int order,
      VoidCallback onTap, double width, double height) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFF7BBBE3),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(height: 1, color: Colors.black),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                description,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 12),
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3F80F7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              ),
              child: const Text(
                'INICIAR',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  
  void _navigateToTechnique(HomeController homeController, String categoryId, String methodId, String route) {
    switch (route) {
      case "tecnica3":
        homeController.goToEspresivo(categoryId, methodId);
        break;
      case "tecnica2":
        homeController.goToEjercicioG(categoryId, methodId);
        break;
      case "tecnica1":
        homeController.goToT1(categoryId, methodId);
        break;
      default:
        print("Ruta desconocida: $route");
    }
  }

   Widget _buildStressLevelBar(BuildContext context, String categoryId) {
    return FutureBuilder<int?>(
      future: Get.find<ControllerServices>().getLatestStressLevel(
        categoryId[0].toUpperCase() + categoryId.substring(1).toLowerCase()
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        int stressLevel = snapshot.data ?? 0;
        String indicatorImage = _getIndicatorImage(stressLevel);

        double barWidth = MediaQuery.of(context).size.width * 0.9;
        double buttonWidth = barWidth / 5; 

        return Column(
          children: [
            SizedBox(
              height: 90, 
              child: Stack(
                clipBehavior: Clip.none, 
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          print("Botón ${_getStressLabel(index)} presionado");
                        },
                        child: Container(
                          width: buttonWidth,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _getButtonColor(index),
                            border: Border.all(color: const Color(0xFFD6DDE5), width: 3.5),
                            borderRadius: BorderRadius.only(
                              topLeft: index == 0 ? const Radius.circular(20) : Radius.zero,
                              bottomLeft: index == 0 ? const Radius.circular(20) : Radius.zero,
                              topRight: index == 4 ? const Radius.circular(20) : Radius.zero,
                              bottomRight: index == 4 ? const Radius.circular(20) : Radius.zero,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  Positioned(
                    left: buttonWidth * stressLevel + (buttonWidth / 2) - 7,
                    top: -25, 
                    child: Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      child: CachedNetworkAsset(
                        url: indicatorImage,
                        width: 50,
                        height: 50,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  // int _getStressLevel(int score) {
  //   if (score <= 10) return 0;  // Bajo
  //   if (score <= 14) return 1;  // Regular
  //   if (score <= 17) return 2;  // Normal
  //   if (score <= 20) return 3;  // Bueno
  //   return 4;  // Genial
  // }


  String _getStressLabel(int level) {
    switch (level) {
      case 0: return "BAJO";
      case 1: return "REGULAR";
      case 2: return "NORMAL";
      case 3: return "BUENO";
      case 4: return "GENIAL";
      default: return "";
    }
  }

  String _getIndicatorImage(int level) {
    return [
      'https://firebasestorage.googleapis.com/v0/b/psicologia-app-liid.firebasestorage.app/o/images%2Findicador_malo.png?alt=media&token=fec04575-5d1f-459f-9356-f8b1f79583c1',
      'https://firebasestorage.googleapis.com/v0/b/psicologia-app-liid.firebasestorage.app/o/images%2Findicador_regular.png?alt=media&token=93551925-9a47-471e-9a9f-fbededc74979',
      'https://firebasestorage.googleapis.com/v0/b/psicologia-app-liid.firebasestorage.app/o/images%2Findicador_normal.png?alt=media&token=ad70ba6e-f24c-47c6-9c27-fe4f6cf5e064',
      'https://firebasestorage.googleapis.com/v0/b/psicologia-app-liid.firebasestorage.app/o/images%2Findicador_bueno.png?alt=media&token=81e2b534-e018-4444-9492-a5d64f3194ba',
      'https://firebasestorage.googleapis.com/v0/b/psicologia-app-liid.firebasestorage.app/o/images%2Findicador_genial.png?alt=media&token=38b23052-ac3b-4a73-98a5-99aa50b9bf6d',
    ][level];
  }

  Color _getButtonColor(int index) {
    return [
      Colors.red,     
      Colors.orange, 
      Colors.yellow,  
      Colors.teal,    
      Colors.green,   
    ][index];
  }



}
