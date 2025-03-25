import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class LocalNotifications {
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initializeLocalNotifications(
      Function(NotificationResponse) onTap) async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        onTap(response);
      },
    );

    print("Notificaciones locales inicializadas");
  }

  static Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? imageUrl,  
  }) async {
    AndroidNotificationDetails androidDetails;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      BigPictureStyleInformation bigPictureStyle = BigPictureStyleInformation(
        FilePathAndroidBitmap(imageUrl),
        contentTitle: title,
        summaryText: body,
      );

      androidDetails = AndroidNotificationDetails(
        'channelId',
        'channelName',
        channelDescription: 'Canal de notificaciones locales',
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: bigPictureStyle, 
        playSound: true,
      );
    } else {
      androidDetails = const AndroidNotificationDetails(
        'channelId',
        'channelName',
        channelDescription: 'Canal de notificaciones locales',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      );
    }

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _localNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
    );

    print("Notificación local enviada: $title");
  }

  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledTime,
    DateTimeComponents? matchDateTimeComponents, 
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'scheduled_channel_id',
      'Scheduled Notifications',
      channelDescription: 'Notificaciones programadas',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _localNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, 
      matchDateTimeComponents: matchDateTimeComponents,
    );

  }

}
