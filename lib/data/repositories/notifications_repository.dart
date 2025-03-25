import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:psicologia_app_liid/domain/entities/push_message.dart';

class NotificationsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveNotification(PushMessage message) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      print("Error: Usuario no autenticado.");
      return;
    }

    try {
      final notificationsRef = _firestore.collection('users').doc(userId).collection('notifications');

      String notificationId = notificationsRef.doc().id;

      await notificationsRef.doc(notificationId).set({
        "messageId": notificationId, 
        "title": message.title,
        "body": message.body,
        "sentDate": message.sentDate.toIso8601String(),
        "frequency": message.frequency, 
        "selectedDays": message.selectedDays, 
      });

      print("Notificación guardada con ID: $notificationId en Firebase");
    } catch (e) {
      print("Error guardando la notificación: $e");
    }
  }


  Future<List<PushMessage>> getUserNotifications() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      print("Error: Usuario no autenticado.");
      return [];
    }

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) => PushMessage.fromMap(doc.data(), doc.id)).toList();
    } catch (e) {
      print("Error al obtener notificaciones: $e");
      return [];
    }
  }

  Future<void> saveFCMToken(String userId) async {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    final String? token = await messaging.getToken();

    if (token != null) {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'fcmToken': token,
      });
      print("Token de FCM guardado en Firestore: $token");
    } else {
      print("Error obteniendo el token de FCM");
    }
  }
}
