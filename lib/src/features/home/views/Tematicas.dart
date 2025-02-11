import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/home_controller.dart';

class Tematicas_P extends StatelessWidget {
  const Tematicas_P({super.key});

  Stream<List<Map<String, dynamic>>> fetchCategories() {
    CollectionReference collection =
        FirebaseFirestore.instance.collection("categories");

    return collection.snapshots().map((QuerySnapshot snapshot) {
      return snapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();
    final User? user = FirebaseAuth.instance.currentUser;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF398AD5),
          title: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(user?.photoURL ?? ''),
              ),
              const SizedBox(width: 10),
              Text(
                user?.displayName ?? 'Usuario',
                style: const TextStyle(fontSize: 16),
              ),
              const Spacer(),
              IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  homeController.goToInicioSesion();
                },
                icon: const Icon(Icons.logout),
                tooltip: 'Cerrar sesión',
              ),
            ],
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;
            final maxHeight = constraints.maxHeight;

            return Container(
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
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'Selecciona una temática',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<List<Map<String, dynamic>>>(
                      stream: fetchCategories(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text(
                              "Error al cargar datos",
                              style: TextStyle(color: Colors.red),
                            ),
                          );
                        }
                        final categories = snapshot.data ?? [];
                        if (categories.isEmpty) {
                          return const Center(
                            child: Text(
                              "No hay temáticas disponibles",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          );
                        }
                        return Center(
                          child: SizedBox(
                            width: maxWidth * 0.9,
                            height: maxHeight,
                            child: Stack(
                              children: List.generate(
                                categories.length,
                                (index) {
                                  final category = categories[index];
                                  final gradientColors = (category['colors'] as List)
                                      .map((color) => Color(int.parse(
                                          color.replaceFirst('#', '0xFF'))))
                                      .toList();

                                  // Posiciones en escalera
                                  final leftOffset = index % 2 == 0
                                      ? maxWidth * 0.1
                                      : maxWidth * 0.3;
                                  final topOffset = maxHeight * 0.15 * index;

                                  return Positioned(
                                    left: leftOffset,
                                    top: topOffset,
                                    child: _buildDynamicColumn(
                                      width: maxWidth * 0.5,
                                      height: maxHeight * 0.6,
                                      title: category['title'] ?? 'Sin título',
                                      number: index + 1,
                                      gradientColors: gradientColors.cast<Color>(),
                                      onTap: () {
                                        final selectedCategory = category['title'] ?? "";
                                        if (selectedCategory.isNotEmpty) {
                                          homeController.goToCuestionario(selectedCategory);
                                        } else {
                                          print("Error: Categoría vacía");
                                        }
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: Container(
          color: const Color(0xFF3284FF),
          height: MediaQuery.of(context).size.height * 0.08,
          child: const Center(
            child: Text(
              'LiiD UTPL',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

    Widget _buildDynamicColumn({
    required double width,
    required double height,
    required String title,
    required int number,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradientColors,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start, 
            children: [
              // **Título en la parte superior**
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              // **Número debajo del título**
              Text(
                number.toString().padLeft(2, '0'),
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
