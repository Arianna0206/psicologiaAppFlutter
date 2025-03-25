import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io'; 

class ReminderController extends GetxController {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void onInit() {
    super.onInit();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings iosInit = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    final InitializationSettings settings = InitializationSettings(
      android: androidInit, 
      iOS: iosInit
    );

    await flutterLocalNotificationsPlugin.initialize(settings);
  }

  Future<void> requestNotificationPermissions() async {
    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid && (await _isAndroid13OrAbove())) {
      Get.snackbar("Permiso requerido", "Por favor, habilita las notificaciones en Configuración.");
    }
  }

  Future<bool> _isAndroid13OrAbove() async {
    return Platform.isAndroid && (await DeviceInfoPlugin().androidInfo).version.sdkInt >= 33;
  }

  Future<void> scheduleNotification(TimeOfDay selectedTime, String frequency) async {
    final now = DateTime.now();
    final scheduleTime = DateTime(now.year, now.month, now.day, selectedTime.hour, selectedTime.minute);

    tz.TZDateTime scheduledDate = tz.TZDateTime.from(scheduleTime, tz.local);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, 
      "⏰ Recordatorio de ejercicio",
      "Es hora de tu sesión de estiramiento 🏋️",
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails("recordatorio", "Recordatorios", importance: Importance.high),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, 
      matchDateTimeComponents: frequency == "Diariamente"
          ? DateTimeComponents.time
          : (frequency == "Semanal" ? DateTimeComponents.dayOfWeekAndTime : null),
    );


    Get.snackbar("Recordatorio programado", "Te notificaremos a las ${selectedTime.format(Get.context!)}");
  }
}
