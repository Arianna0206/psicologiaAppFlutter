import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:psicologia_app_liid/src/core/services/color_service.dart';
import 'package:psicologia_app_liid/src/shared/services/firebase_service.dart';

class ControllerServices extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();

  final RxMap<String, List<String>> _questions = <String, List<String>>{}.obs;
  final RxMap<String, String> questSelect = <String, String>{}.obs;
  final RxList<Map<String, dynamic>> techniques = <Map<String, dynamic>>[].obs;
  final RxInt preguntasPorPagina = 3.obs;
  final RxList<DocumentSnapshot> exercises = <DocumentSnapshot>[].obs;
  final RxInt totalExercises = 1.obs;
  final RxBool isLoading = true.obs;
   final Map<String, List<int>> _questionValues = {};

  Map<String, List<String>> get quest => _questions;

  Stream<int> get colorStream => ColorService().fetchColors().map((colors) {
        if (colors.isNotEmpty) {
          return colors.first['color'] as int;
        }
        return 0xFF26A69A; // Color por defecto
      });

  Future<void> fetchQuestions(String categoryId) async {
    print("Buscando preguntas en la categoría: $categoryId");

    try {
      DocumentSnapshot? categoryDoc = await _firebaseService.getCategory(categoryId);
      if (categoryDoc != null && categoryDoc.exists) {
        preguntasPorPagina.value = categoryDoc["preguntasPorPagina"] ?? 3;
      }

      QuerySnapshot? questionsSnapshot = await _firebaseService.getQuestions(categoryId);
      if (questionsSnapshot == null || questionsSnapshot.docs.isEmpty) {
        _questions.clear();
        return;
      }

      _questions.clear();
      for (var doc in questionsSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        _questions[data["title"] ?? "Pregunta sin título"] = List<String>.from(data["options"] ?? []);
      }
    } catch (error) {
      print("Error al recuperar preguntas: $error");
    }
  }

  Future<void> fetchTechniques(String categoryId) async {
    print("Buscando técnicas para la categoría: $categoryId");

    try {
      QuerySnapshot? snapshot = await _firebaseService.getTechniques(categoryId);
      if (snapshot != null) {
        techniques.clear();
        techniques.addAll(snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>));
      }
    } catch (error) {
      print("Error al recuperar técnicas: $error");
    }
  }

  Future<void> saveResultToFirebase(int score, String category) async {
    await _firebaseService.saveResult(score, category);
  }

  Future<int?> getStoredResult(String categoryId) async {
    return await _firebaseService.getStoredResult(categoryId);
  }

  Future<void> fetchExercises(String categoryId, String methodId) async {
    isLoading.value = true;

    try {
      QuerySnapshot? snapshot = await _firebaseService.getExercises(categoryId, methodId);
      if (snapshot != null && snapshot.docs.isNotEmpty) {
        exercises.assignAll(snapshot.docs);
        totalExercises.value = snapshot.docs.length;
      }
    } catch (error) {
      print("Error al obtener ejercicios: $error");
    }

    isLoading.value = false;
  }

  Future<void> saveCompletedExercise(String categoryId, String methodId, int currentExerciseIndex) async {
    if (currentExerciseIndex < exercises.length) {
      String exerciseId = exercises[currentExerciseIndex].id;
      await _firebaseService.saveCompletedExercise(categoryId, methodId, exerciseId);
    }
  }

  void updateQuestionSelect(String key, String value) {
    questSelect[key] = value; 
  }

  int calculateTotalScore() {
  int totalScore = 0;

  questSelect.forEach((pregunta, respuesta) {
    if (_questions.containsKey(pregunta) && _questionValues.containsKey(pregunta)) {
      List<String> opciones = _questions[pregunta]!;
      List<int> valores = _questionValues[pregunta]!;

      int index = opciones.indexOf(respuesta);
      if (index != -1 && index < valores.length) {
        totalScore += valores[index]; 
      }
    }
  });

  print("Puntaje calculado: $totalScore");
  return totalScore;
}
}
