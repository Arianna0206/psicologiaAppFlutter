
import 'package:flutter/material.dart';

class EncuestaControlador {
  final Map<String, List<String>> preguntasRespuestas = {
    "¿Cuál es tu color favorito?": ["Rojo", "Azul"],
    "¿Qué actividad prefieres?": ["Leer", "Correr"],
    "¿Qué tipo de música prefieres?": ["Rock", "Jazz"],
    "¿Cuál es tu deporte favorito?": ["Fútbol", "Baloncesto"],
  };

  final int numeroPaginas = 2;
  bool esUltimaPagina = false;

  void verificarEstadoPagina(int iterador) {
    esUltimaPagina = iterador == numeroPaginas;
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Encuesta',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: EncuestaPage(
        controlador: EncuestaControlador(),
      ),
    );
  }
}



class EncuestaPage extends StatefulWidget {
  final EncuestaControlador controlador;

  const EncuestaPage({Key? key, required this.controlador}) : super(key: key);

  @override
  State<EncuestaPage> createState() => _EncuestaPageState();
}



class _EncuestaPageState extends State<EncuestaPage> {


  final Map<String, String> respuestasSeleccionadas = {};
  int iterador = 0;

  void procesarPagina() {
    widget.controlador.verificarEstadoPagina(iterador);
    if (widget.controlador.esUltimaPagina) {
      //aqui pasar a la siguiente pantalla
    } else {
      setState(() {
        widget.controlador.preguntasRespuestas.removeWhere(
              (pregunta, respuestas) => respuestasSeleccionadas.keys.contains(pregunta),
        );
      });
    }
  }

  Widget construirPreguntas() {
    List<Widget> widgetsPreguntas = [];
    int preguntasPorPagina = 3;
    int contadorPreguntas = 0;

    for (var mapa in widget.controlador.preguntasRespuestas.entries) {
      if (contadorPreguntas == preguntasPorPagina) break;

      widgetsPreguntas.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(mapa.key,style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
          const SizedBox(height: 10),
          Wrap(
            spacing: 16,
            runSpacing: 10,
            children: List.generate(
              mapa.value.length,(index) => SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 24,
                child: RadioListTile<String>(
                  title: Text(mapa.value[index]),
                  value: mapa.value[index],
                  groupValue: respuestasSeleccionadas[mapa.key],
                  onChanged: (valor) {
                    setState(() {
                      respuestasSeleccionadas[mapa.key] = valor!;
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ));

      contadorPreguntas++;
    }

    return Column(children: widgetsPreguntas);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Encuesta")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: construirPreguntas(),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            iterador++;
            procesarPagina();
          },
          child: Text(widget.controlador.esUltimaPagina ? "Finalizar" : "Continuar"),
        ),
      ),
    );
  }
}



























