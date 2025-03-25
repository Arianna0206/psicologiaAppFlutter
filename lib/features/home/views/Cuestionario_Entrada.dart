import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/controller_services.dart';
import '../controllers/home_controller.dart';

class PantallaCuestionario extends StatelessWidget {
  final String categoryId;

  const PantallaCuestionario({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final ControllerServices service = Get.find<ControllerServices>();
    final HomeController homeController = Get.find<HomeController>();

    return FutureBuilder<int?>(
      future: service.getLatestStressLevel(categoryId), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            homeController.goToMenu(categoryId);
          });
          return const Scaffold(); 
        }

        
        service.fetchQuestions(categoryId);

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFDD76F2), Color(0xFF80448C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 35.0),
                  child: Text(
                    'Cuestionario Breve: Factores\nPredisponentes del $categoryId',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.048,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF398AD5), Color(0xFFF8F8F8)],
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  _buildRobotInfo(context),
                  const SizedBox(height: 20),
                  _buildCuestionarioContainer(context, service, homeController),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRobotInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Image.network(
                'https://firebasestorage.googleapis.com/v0/b/psicologia-app-liid.firebasestorage.app/o/images%2FcuadroTextoa.png?alt=media&token=2358b580-bf99-4d56-9737-0422afbeb695',
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.13,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.05,
                left: MediaQuery.of(context).size.width * 0.089,
                child: Text(
                  'La información tiene como objetivo\ninvestigativo, sus resultados se presentan\nde manera anónima.',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.026,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          Image.network(
            'https://firebasestorage.googleapis.com/v0/b/psicologia-app-liid.firebasestorage.app/o/images%2Fcorazon.png?alt=media&token=8f694468-df87-4ba0-b306-c9f650787a66',
            width: MediaQuery.of(context).size.width * 0.23,
            height: MediaQuery.of(context).size.width * 0.25,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }

  Widget _buildCuestionarioContainer(BuildContext context, ControllerServices service, HomeController homeController) {
  return Container(
    margin: EdgeInsets.fromLTRB(
      MediaQuery.of(context).size.width * 0.05,
      20,
      MediaQuery.of(context).size.width * 0.05,
      MediaQuery.of(context).size.height * 0.04,
    ),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: SizedBox(
      height: MediaQuery.of(context).size.height * 0.55,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Obx(() {
                final preguntas = service.quest; // Obtiene las preguntas

                if (preguntas.isEmpty) {
                  return const Center(
                    child: Text("No hay preguntas disponibles"),
                  );
                }

                return _buildPreguntas(context, preguntas, service);
              }),
            ),
          ),
          const SizedBox(height: 20),
          _buildBotonSiguiente(context, service, homeController),
        ],
      ),
    ),
  );
}


  Widget _buildPreguntas(BuildContext context, Map<String, List<String>> preguntas, ControllerServices service) {
    return Column(
      children: preguntas.entries.map((mapa) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mapa.key,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Obx(() => Column(
                    children: List.generate(
                      mapa.value.length,
                      (index) => RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        title: Text(mapa.value[index], style: const TextStyle(fontSize: 12)),
                        value: mapa.value[index],
                        groupValue: service.questSelect[mapa.key],
                        onChanged: (valor) {
                          service.updateQuestionSelect(mapa.key, valor!);
                        },
                      ),
                    ),
                  )),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBotonSiguiente(BuildContext context, ControllerServices service, HomeController homeController) {
    return Obx(() => SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.07,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4C76D6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            ),
            onPressed: service.questSelect.length == service.quest.length
                ? () async {
                    int totalScore = service.calculateTotalScore();
                    await service.saveResultToFirebase(totalScore, categoryId);
                    homeController.goToComplete(totalScore, categoryId);
                  }
                : null,
            child: const Text('Siguiente', style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ));
  }
}
