import 'dart:async';
import 'package:get/get.dart';
import 'package:psicologia_app_liid/src/core/services/color_service.dart';



class ControllerServices extends GetxController {
  final Map<String, List<String>> _questions = {};
  final Map<String, String> _questionSelect = {};
  final StreamController<Map<String, List<String>>> _questionsController = StreamController<Map<String, List<String>>>.broadcast();
  final StreamController<Map<String, String>> _questionSelectController = StreamController<Map<String, String>>.broadcast();
  final int numPages = 2;
  bool endPages = false;


  Stream<int> get colorStream => ColorService().fetchColors().map((colors) {
    if (colors.isNotEmpty) {
      Map<String, dynamic> firstDoc = colors.first;
      return firstDoc['color'] as int;
    }
    return 0xFF26A69A;
  });

  Stream<Map<String, List<String>>> get questionsStream => _questionsController.stream;
  Stream<Map<String, String>> get questionSelectStream => _questionSelectController.stream;
  Map<String, List<String>> get quest => _questions;
  Map<String, String> get questSelect => _questionSelect;

  void updateQuestionSelect(String key, String value) {
    _questionSelect[key] = value;
    _questionSelectController.add(_questionSelect);
  }


  void deleteQuestion(Map<String, String> respuestasSeleccionadas) {
    _questions.removeWhere(
          (pregunta, respuestas) => respuestasSeleccionadas.keys.contains(pregunta),
    );
    _questionsController.add(_questions);
  }

  void updateQuestions(Map<String, dynamic> twoDoc) {
    twoDoc.forEach((key, value) {if (value is List<dynamic>) {_questions[key] = value.cast<String>();}});
    _questionsController.add(_questions);
  }

  Stream<List<String>> categories() {
    return ColorService().Categories().map((cate) {
      if (cate.isNotEmpty) {
        Map<String, dynamic> firstDoc = cate.first;
        List<String> updatedList = firstDoc.values.map((value) => value as String).toList();
        updateQuestions(cate[1]);
        return updatedList;
      }
      return [];
    });
  }
  void veryPages(int iterador) {
    endPages = iterador == numPages;
  }
}










