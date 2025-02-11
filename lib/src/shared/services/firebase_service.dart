import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot?> getCategory(String categoryId) async {
    try {
      return await _firestore.collection("categories").doc(categoryId.trim().toLowerCase()).get();
    } catch (e) {
      print("Error al obtener la categoría: $e");
      return null;
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
      print("Error al obtener preguntas: $e");
      return null;
    }
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

  Future<QuerySnapshot?> getTechniques(String categoryId) async {
    try {
      return await _firestore
          .collection("categories")
          .doc(categoryId.trim().toLowerCase())
          .collection("methods")
          .orderBy("order")
          .get();
    } catch (e) {
      print("Error al obtener técnicas: $e");
      return null;
    }
  }

  Future<int?> getStoredResult(String categoryId) async {
    final user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection("users").doc(user.uid).get();
      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
        return userData?["resultados"]?[categoryId]?["puntaje"];
      }
    }
    return null;
  }

  Future<QuerySnapshot?> getExercises(String categoryId, String methodId) async {
    try {
      return await _firestore
          .collection("categories")
          .doc(categoryId.toLowerCase())
          .collection("methods")
          .doc(methodId.toLowerCase())
          .collection("exercises")
          .orderBy("order")
          .get();
    } catch (e) {
      print("Error al obtener ejercicios: $e");
      return null;
    }
  }

  Future<void> saveCompletedExercise(String categoryId, String methodId, String exerciseId) async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection("users").doc(user.uid).collection("completed_exercises").doc(exerciseId).set({
          "completed_at": FieldValue.serverTimestamp(),
          "categoryId": categoryId,
          "methodId": methodId,
        }, SetOptions(merge: true));
        print("Ejercicio guardado correctamente.");
      } catch (e) {
        print("Error guardando el ejercicio: $e");
      }
    }
  }
}
