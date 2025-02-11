import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/home_controller.dart';

class Menu extends StatelessWidget {
  final String categoryId;

  const Menu({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();
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

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No hay técnicas disponibles.",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  var techniques = snapshot.data!.docs;

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: techniques.map((doc) {
                        var data = doc.data() as Map<String, dynamic>;
                        String title = data["title"] ?? "Sin título";
                        String description = data["description"] ?? "Sin descripción";
                        String methodId = doc.id; 
                        int order = data["order"] ?? 0;

                        return _buildTechniqueCard(
                          title,
                          description,
                          order,
                          () {
                            _navigateToTechnique(homeController, categoryId, methodId);
                          },
                          rect3Width,
                          rect3Height,
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
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

  
  void _navigateToTechnique(HomeController homeController, String categoryId, String methodId) {
    if (methodId.toLowerCase() == "tecnica2") {
      print("Redirigiendo a Ejercicio de Gratitud...");
      homeController.goToEjercicioG();
    } else {
      print("Redirigiendo a Técnica 1...");
      homeController.goToT1(categoryId, methodId);
    }
  }
}
