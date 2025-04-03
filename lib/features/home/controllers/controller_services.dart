import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:psicologia_app_liid/core/services/color_service.dart';
import 'package:psicologia_app_liid/shared/extensions/string_extensions.dart';

class ControllerServices extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RxMap<String, List<String>> _questions = <String, List<String>>{}.obs;
  final RxMap<String, String> questSelect = <String, String>{}.obs;
  final RxList<Map<String, dynamic>> techniques = <Map<String, dynamic>>[].obs;
  final RxInt preguntasPorPagina = 3.obs;
  final RxList<DocumentSnapshot> exercises = <DocumentSnapshot>[].obs;
  final RxInt totalExercises = 1.obs;
  final RxBool isLoading = true.obs;
  String? _categoryId; 
  final Map<String, List<int>> _questionValues = {};
  final RxInt mensajeIndex = 0.obs;
  Map<String, List<String>> get quest => _questions;
  final RxList<Map<String, dynamic>> completedExercises = <Map<String, dynamic>>[].obs; 
  final RxInt selectedStressLevel = 0.obs; 
  final RxList<Map<String, dynamic>> gratitudeEntries = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> expressiveEntries = <Map<String, dynamic>>[].obs;
  final RxString fraseMotivacional = ''.obs;
  final RxString audioUrlMotivacional = ''.obs;


  final List<String> frasesMotivacionales = [
    "¡Sigue así! Cada pequeño paso cuenta.",
    "La gratitud es la clave para la felicidad.",
    "Cada día es una oportunidad para mejorar.",
    "Eres más fuerte de lo que piensas.",
    "Tu esfuerzo traerá grandes recompensas."
  ];

  void actualizarMensaje() {
    mensajeIndex.value = (mensajeIndex.value + 1) % frasesMotivacionales.length;
  }



  Stream<int> get colorStream => ColorService().fetchColors().map((colors) {
        if (colors.isNotEmpty) {
          return colors.first['color'] as int;
        }
        return 0xFF26A69A; 
      });

  // Método para obtener el Stream de categorías
  Stream<List<Map<String, dynamic>>> fetchCategories() {
    CollectionReference collection =
        FirebaseFirestore.instance.collection("categories");
    return collection.orderBy("order").snapshots().asyncMap((snapshot) async {
      try {
        List<Map<String, dynamic>> categories = [];
        for (var doc in snapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          String categoryId = doc.id;
          bool hasMethods = await doc.reference.collection("methods").limit(1).get().then((methodsSnapshot) {
            return methodsSnapshot.docs.isNotEmpty;
          });
          categories.add({
            ...data,
            "id": categoryId,
            "hasMethods": hasMethods, 
          });
        }
        return categories;
      } catch (e) {
        // print("Error al cargar datos: $e");
        return [];
      }
    });
  }

  Future<void> fetchQuestions(String categoryId) async {
    // print("Buscando preguntas en la categoría: $categoryId");
    try {
      QuerySnapshot? questionsSnapshot = await getQuestions(categoryId);
      if (questionsSnapshot == null || questionsSnapshot.docs.isEmpty) {
        _questions.clear();
        _questionValues.clear();
        return;
      }
      _questions.clear();
      _questionValues.clear();
      for (var doc in questionsSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String title = data["title"] ?? "Pregunta sin título";
        List<String> opciones = List<String>.from(data["options"] ?? []);
        List<int> valores = List<int>.from(data["values"] ?? []);
        if (opciones.length != valores.length) {
          continue;
        }
        _questions[title] = opciones;
        _questionValues[title] = valores;
      }
    } catch (error) {
      // print("Error al recuperar preguntas: $error");
    }
  }

  Future<QuerySnapshot?> getQuestions(String categoryId) async {
    try {
      return await _firestore
          .collection("categories")
          .doc(categoryId.trim().toLowerCase())
          .collection("questions")
          .orderBy("order")
          .get();
    } catch (e) {
      // print("Error al obtener preguntas: $e");
      return null;
    }
  }


  void fetchTechniques({required String categoryId}) {
    if (_categoryId == categoryId) return; 
    _categoryId = categoryId; 
    isLoading.value = true;
    FirebaseFirestore.instance
        .collection("categories")
        .doc(categoryId.toLowerCase().trim())
        .collection("methods")
        .orderBy("order")
        .snapshots()
        .listen((snapshot) {
          techniques.clear();
          techniques.addAll(snapshot.docs.map((doc) {
            var data = doc.data();
            data["id"] = doc.id; 
            return data;
          }).toList());
          isLoading.value = false;
        }, onError: (error) {
          // print("Error al obtener técnicas: $error");
          isLoading.value = false;
        });
  }

  //Resultados del cuestionario
  Future<void> saveResultToFirebase(int score, String category) async {
    await saveResult(score, category);
  }

  Future<void> saveResult(int score, String category) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection("users").doc(user.uid).set({
        "resultados": {
          category: {
            "puntaje": score,
            "fecha": Timestamp.now(),
          }
        }
      }, SetOptions(merge: true));
    }
  }

  // Se actualiza la barra de estres con el nuevo dato guardado por el usuario
  Future<int?> getLatestStressLevel(String categoryId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();
      if (!userDoc.exists) return null;
      final data = userDoc.data() as Map<String, dynamic>;
      if (data["stress_levels"] != null) {
        final stressLevels = data["stress_levels"] as Map<String, dynamic>;
        final matchedKey = stressLevels.keys.firstWhere(
          (k) => k.toLowerCase().removeDiacritics() == categoryId.toLowerCase().removeDiacritics(),
          orElse: () => '',
        );
        if (matchedKey.isNotEmpty) return stressLevels[matchedKey];
      }
      if (data["resultados"] != null) {
        final resultados = data["resultados"] as Map<String, dynamic>;
        final matchedKey = resultados.keys.firstWhere(
          (k) => k.toLowerCase().removeDiacritics() == categoryId.toLowerCase().removeDiacritics(),
          orElse: () => '',
        );
        if (matchedKey.isNotEmpty &&
            resultados[matchedKey]["puntaje"] != null) {
          final int score = resultados[matchedKey]["puntaje"];
          return _convertScoreToLevel(score);
        }
      }
      return null;
    } catch (e) {
      // print("Error al obtener nivel de estrés: $e");
      return null;
    }
  }

  // Conversión de puntaje a nivel de estrés
  int _convertScoreToLevel(int score) {
    if (score <= 10) return 0;
    if (score <= 14) return 1;
    if (score <= 17) return 2;
    if (score <= 20) return 3;
    return 4;
  }

  Future<void> fetchExercises(String categoryId, String methodId) async {
    try {
      isLoading.value = true;
      exercises.clear();
      totalExercises.value = 0;
      CollectionReference exercisesRef = FirebaseFirestore.instance
          .collection("categories")
          .doc(categoryId)
          .collection("methods")
          .doc(methodId)
          .collection("exercises");
      QuerySnapshot snapshot = await exercisesRef.get();
      if (snapshot.docs.isNotEmpty) {
        exercises.assignAll(snapshot.docs);
        totalExercises.value = snapshot.docs.length;
        // print("Ejercicios encontrados para $methodId: ${snapshot.docs.length}");
      } else {
        // print("No se encontraron ejercicios en la técnica $methodId.");
      }
    } catch (error) {
      // print("Error al obtener ejercicios: $error");
    } finally {
      Future.delayed(Duration.zero, () {
        isLoading.value = false; 
      });
    }
  }

  Future<void> fetchCompletedExercises() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection("completed_exercises")
          .get();
      completedExercises.clear();
      if (snapshot.docs.isEmpty) {
        // print("No se encontraron ejercicios completados para el usuario: ${user.uid}");
      } else {
        // print("Ejercicios obtenidos: ${snapshot.docs.length}");
      }
      for (var doc in snapshot.docs) {
        if (!doc.id.toLowerCase().startsWith('ejercicio')) continue;
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        // print("Ejercicio: ${data["title"]}, Duración: ${data["duration"]}");
        completedExercises.add({
          "name": data["title"] ?? "Ejercicio desconocido",
          "duration": data["duration"] ?? 20,
        });
      }
      update(); 
    } catch (error) {
      // print("Error al obtener ejercicios completados: $error");
    }
  }

  // Guarda el nivel de estres seleccionado por el usuario
  Future<void> saveStressLevel(String categoryId, int level) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .set({
          "stress_levels": {categoryId: level},
        }, SetOptions(merge: true));

    selectedStressLevel.value = level; 
  }

  Future<void> loadStressLevel(String categoryId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();

    if (userDoc.exists && userDoc.data() != null) {
      Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
      selectedStressLevel.value = data?["stress_levels"]?[categoryId] ?? 0;
    }
  }

  void updateSelectedStressLevel(int level) {
    print("updateSelectedStressLevel() llamado con nivel: $level");
    selectedStressLevel.value = level;
  }


  // Future<void> saveAttempt(String categoryId, String methodId, int currentExerciseIndex) async {
  //   if (currentExerciseIndex < exercises.length) {
  //     String exerciseId = exercises[currentExerciseIndex].id;
  //     await _firebaseService.saveAttempt(categoryId, methodId, exerciseId);
  //   }
  // }

  // Guarda los resultados de los ejercicios de la primera tecnica
  Future<void> saveCompletedExercise(String categoryId, String methodId, String exerciseId, String exerciseTitle, int duration) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = _firestore
        .collection("users")
        .doc(user.uid)
        .collection("completed_exercises")
        .doc(exerciseId);

    try {
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(docRef);

        if (!snapshot.exists) {
          transaction.set(docRef, {
            "completed_at": FieldValue.serverTimestamp(),
            "categoryId": categoryId,
            "methodId": methodId,
            "title": exerciseTitle,
            "duration": duration,
            "attempts": 1,
          });
        } else {
          final data = snapshot.data() as Map<String, dynamic>;
          int currentAttempts = data.containsKey("attempts") ? data["attempts"] as int : 0;

          transaction.update(docRef, {
            "attempts": currentAttempts + 1,
            "completed_at": FieldValue.serverTimestamp(),
            "duration": duration,
          });
        }
      });
      // print("Ejercicio '$exerciseTitle' guardado correctamente con duración de $duration segundos.");
    } catch (e) {
      // print("Error guardando el ejercicio '$exerciseTitle' con duración: $e");
    }
  }

  // Guarda los resultados de los ejercicios de la segunda tecnica
  Future<void> saveGratitudeExercise(
    String categoryId,
    String methodId,
    List<String> gratitudeEntries, {
    required int duration,
  }) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final docId = "gratitude_$methodId";
    final docRef = FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("completed_exercises")
        .doc(docId);
    final entriesRef = docRef.collection("entries").doc();
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(docRef);
        if (!snapshot.exists) {
          transaction.set(docRef, {
            "categoryId": categoryId,
            "methodId": methodId,
            "title": "Ejercicio de gratitud",
            "created_at": FieldValue.serverTimestamp(),
            "attempts": 1,
          });
        } else {
          int currentAttempts = (snapshot.get("attempts") ?? 0) as int;
          transaction.update(docRef, {
            "attempts": currentAttempts + 1,
          });
        }
        transaction.set(entriesRef, {
          "created_at": FieldValue.serverTimestamp(),
          "gratitude_entries": gratitudeEntries,
          "duration": duration, 
        });
      });
      Get.snackbar("Éxito", "Ejercicio de gratitud guardado con éxito.");
    } catch (e) {
      // print("Error al guardar ejercicio de gratitud: $e");
      Get.snackbar("Error", "No se pudo guardar el ejercicio.");
    }
  }


  Future<void> fetchGratitudeEntries(String methodId) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      try {
        final snapshot = await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .collection("completed_exercises")
            .doc("gratitude_$methodId")
            .collection("entries")
            .orderBy("created_at")
            .get();

        gratitudeEntries.clear();

        for (int i = 0; i < snapshot.docs.length; i++) {
          final data = snapshot.docs[i].data();
          if (data.containsKey("duration")) {
            gratitudeEntries.add({
              "attempt": i + 1,
              "duration": data["duration"],
            });
          }
        }
      } catch (e) {
        // print("Error al obtener entradas de gratitud: $e");
      }
  }

  // Guarda los resultados de los ejercicios de la tercera tecnica
  Future<void> saveExpressiveExercise(
    String categoryId,
    String methodId,
    String content, {
    required int duration,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docId = "expressive_$methodId";
    final docRef = FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("completed_exercises")
        .doc(docId);

    final entryRef = docRef.collection("entries").doc();

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);

        if (!snapshot.exists) {
          transaction.set(docRef, {
            "categoryId": categoryId,
            "methodId": methodId,
            "title": "Ejercicio de escritura expresiva",
            "created_at": FieldValue.serverTimestamp(),
            "attempts": 1,
          });
        } else {
          int attempts = (snapshot.get("attempts") ?? 0) as int;
          transaction.update(docRef, {
            "attempts": attempts + 1,
          });
        }

        transaction.set(entryRef, {
          "created_at": FieldValue.serverTimestamp(),
          "content": content,
          "duration": duration,
        });
      });

      Get.snackbar("Éxito", "Ejercicio guardado con éxito.");
    } catch (e) {
      // print("Error al guardar escritura expresiva: $e");
      Get.snackbar("Error", "No se pudo guardar el ejercicio.");
    }
  }


  Future<void> fetchExpressiveEntries(String methodId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection("completed_exercises")
          .doc("expressive_$methodId")
          .collection("entries")
          .orderBy("created_at")
          .get();

      expressiveEntries.clear();

      for (int i = 0; i < snapshot.docs.length; i++) {
        final data = snapshot.docs[i].data();
        if (data.containsKey("duration")) {
          expressiveEntries.add({
            "attempt": i + 1,
            "duration": data["duration"],
            "created_at": data["created_at"]
          });
        }
      }
    } catch (e) {
      // print("Error al obtener entradas de escritura expresiva: $e");
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
    // print("Puntaje calculado: $totalScore");
    return totalScore;
  }

  Future<String?> getUserCategoryId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists && userDoc.data() != null) {
        return userDoc['categoryId']; 
      }
    } catch (error) {
      // print("Error al obtener categoryId: $error");
    }
    return null; 
  }

  Future<Map<String, dynamic>> getUserAchievements() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // print("No hay usuario autenticado.");
      return {'totalExercises': 0, 'totalAttempts': 0, 'completedAll': false, 'uniqueSessions': 0};
    }
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        // print("No se encontró el documento del usuario en Firestore.");
        return {'totalExercises': 0, 'totalAttempts': 0, 'completedAll': false, 'uniqueSessions': 0};
      }
      // print("Datos del usuario en Firestore: ${userDoc.data()}");
      QuerySnapshot completedSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection("completed_exercises")
          .get();
      int totalExercises = completedSnapshot.docs.length;
      bool completedAll = totalExercises > 0;
      QuerySnapshot attemptsSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection("exercises_attempts")
          .get();
      int totalAttempts = 0;
      Map<int, int> sessionDayCounts = {}; 
      for (var doc in attemptsSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data.containsKey("attempts")) {
          totalAttempts += (data["attempts"] as num).toInt(); 
        }
        if (data.containsKey("last_attempt")) {
          Timestamp lastAttempt = data["last_attempt"];
          int sessionDay = lastAttempt.toDate().millisecondsSinceEpoch ~/ (1000 * 60 * 60 * 24);
          sessionDayCounts.update(sessionDay, (value) => value + 1, ifAbsent: () => 1);
        }
      }
      int uniqueSessions = sessionDayCounts.keys.length;
      // print("Sesiones únicas: $uniqueSessions, Intentos totales: $totalAttempts");
      return {
        'totalExercises': totalExercises,
        'totalAttempts': totalAttempts, 
        'completedAll': completedAll,
        'uniqueSessions': uniqueSessions, 
      };
    } catch (e) {
      // print("Error al obtener logros: $e");
      return {'totalExercises': 0, 'totalAttempts': 0, 'completedAll': false, 'uniqueSessions': 0};
    }
  }

  Future<void> fetchFraseMotivacional(String categoryId, String methodId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection("categories")
          .doc(categoryId)
          .collection("methods")
          .doc(methodId)
          .collection("exercises")
          .doc("ejercicio1")
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        fraseMotivacional.value = data["description"] ?? '';
        audioUrlMotivacional.value = data["audioUrl"] ?? '';
      }
    } catch (e) {
      // print("Error al obtener frase motivacional: $e");
    }
  }
}
