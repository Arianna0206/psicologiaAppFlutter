import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controllers/home_controller.dart';
import '../controllers/controller_services.dart';

class Tematicas_P extends StatelessWidget {
  const Tematicas_P({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();


    final HomeController homeController = Get.find<HomeController>();
    final ControllerServices controllerServices =
        Get.find<ControllerServices>();
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF398AD5),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: user?.photoURL != null &&
                      user!.photoURL!.isNotEmpty
                  ? NetworkImage(user.photoURL!)
                  : const NetworkImage(
                          'https://firebasestorage.googleapis.com/v0/b/psicologia-app-liid.firebasestorage.app/o/images%2FmarcianoLogin.png?alt=media&token=18eb7af9-c30b-4dd8-b134-2abcf42ae056')
                      as ImageProvider,
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
                    stream: controllerServices.fetchCategories(),
                    initialData: [],
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                                final gradientColors =
                                    (category['colors'] as List)
                                        .map((color) => Color(int.parse(
                                            color.replaceFirst('#', '0xFF'))))
                                        .toList();

                                final leftOffset = index % 2 == 0
                                    ? maxWidth * 0.1
                                    : maxWidth * 0.3;
                                final topOffset = maxHeight * 0.15 * index;

                                final bool hasMethods =
                                    category['hasMethods'] ?? false;

                                return Positioned(
                                  left: leftOffset,
                                  top: topOffset,
                                  child: _buildDynamicColumn(
                                    width: maxWidth * 0.5,
                                    height: maxHeight * 0.6,
                                    title: category['title'] ?? 'Sin título',
                                    number: index + 1,
                                    gradientColors:
                                        gradientColors.cast<Color>(),
                                    hasMethods: hasMethods,
                                    onTap: () {
                                      if (hasMethods) {
                                        final selectedCategory =
                                            category['title'] ?? "";
                                        if (selectedCategory.isNotEmpty) {
                                          homeController.goToCuestionario(
                                              selectedCategory);
                                        } else {
                                          print("Error: Categoría vacía");
                                        }
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
            'Prototipo desarrollado por LiiD UTPL',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
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
    required bool hasMethods,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: hasMethods ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: () {
          if (hasMethods) {
            onTap();
          } else {
            Get.snackbar(
              "Próximamente",
              "Esta temática aún no está disponible.",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.orangeAccent,
              colorText: Colors.white,
              duration: const Duration(seconds: 2),
            );
          }
        },
        child: Stack(
          children: [
            Container(
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
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
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
            if (!hasMethods)
              Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.withOpacity(0.5),
                ),
                alignment: Alignment.center,
                child: const Text(
                  "Próximamente",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
