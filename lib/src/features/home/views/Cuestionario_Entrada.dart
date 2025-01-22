import 'package:flutter/material.dart';
import '../controllers/controller_services.dart';
import '../controllers/home_controller.dart';
import 'package:get/get.dart';

//primero estudiar el codigo tanto los metodos como
//como los getter y mapas y metodos de los controladores de servicio
//dos eliminar el numero d epaginas en la ultima respuesta de la pregunta
//tres ver por que las respuestas no s eapilaron al lado como dos columnas
//cuatro bloquear que el usuario no pueda pasar a la siguiente pagina si no ha selecionado una respuesta por pregunta
// cinco comportamiento extraño cuando hacemos el cuestionairo acabamos y pasamos al menu y volvemos a tematicas el cuestionario ya no funciona
//seis que pasa si pasamos a la siguiente pagina sin haber selecionado una o dos respuestas por pregunta revisar
//en esta variable int preguntasPorPagina = 3; hay que en la base buscar una manear de poner el numero
//de preguntas por pagina para que no este limitado a solo 3 preguntas por pagina y revisar lo de la cahe para que
//pueda reutilizar el mismo cuestionario que ya se trajo de la base si esque no hay cambios en la base.

void main() {
  runApp(const PantallaCuestionario());
}

class PantallaCuestionario extends StatelessWidget {
  const PantallaCuestionario({super.key});

  @override
  Widget build(BuildContext context) {
    final ControllerServices service = Get.find<ControllerServices>();
    final HomeController homeController = Get.find<HomeController>();
    int iterador = 0;

    void procesarPagina() {
      service.veryPages(iterador);
      if (service.endPages) {
        homeController.goToComplete();
      } else {
        service.deleteQuestion(service.questSelect);
      }
    }

    Widget construirPreguntas() {
      List<Widget> widgetsPreguntas = [];
      int preguntasPorPagina = 3;
      int contadorPreguntas = 0;

      for (var mapa in service.quest.entries) {
        if (contadorPreguntas == preguntasPorPagina) break;
        widgetsPreguntas.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mapa.key,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 16,
                runSpacing: 10,
                children: List.generate(
                  mapa.value.length,
                  (index) => SizedBox(
                    width: MediaQuery.of(context).size.width / 2 - 24,
                    child: StreamBuilder<Map<String, String>>(
                      stream: service.questionSelectStream,
                      initialData: {},
                      builder: (context, snapshot) {
                        final currentSelection = snapshot.data ?? {};
                        return RadioListTile<String>(
                          title: Text(mapa.value[index]),
                          value: mapa.value[index],
                          groupValue: currentSelection[mapa.key],
                          onChanged: (valor) {
                            service.updateQuestionSelect(mapa.key, valor!);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
        contadorPreguntas++;
      }
      return Column(children: widgetsPreguntas);
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFDD76F2),
                  Color(0xFF80448C),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 35.0),
                child: StreamBuilder<List<String>>(
                  stream: service.categories(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return const Text(
                        "Error al cargar datos",
                        style: TextStyle(color: Colors.white),
                      );
                    }

                    final categories = snapshot.data ?? [];
                    final categoryText =
                        categories.isNotEmpty ? categories[0] : "Sin datos";

                    return Text(
                      'Cuestionario Breve:Factores\nPredisponentes del $categoryText',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.048,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
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
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'lib/assets/images/cuadroTextoa.png',
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
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.026,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                      Image.asset(
                        'lib/assets/images/corazon.png',
                        width: MediaQuery.of(context).size.width * 0.23,
                        height: MediaQuery.of(context).size.width * 0.25,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
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
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.55,
                        child: StreamBuilder<Map<String, List<String>>>(
                          stream: service.questionsStream,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return const Center(
                                child: Text(
                                  "Error al cargar las preguntas.",
                                  style: TextStyle(color: Colors.red),
                                ),
                              );
                            }
                            return SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: construirPreguntas(),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4C76D6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          onPressed: () {
                            iterador++;
                            procesarPagina();
                          },
                          child: const Text(
                            'Siguiente',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
