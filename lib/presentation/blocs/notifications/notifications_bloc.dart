import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:psicologia_app_liid/config/local_notifications/local_notifications.dart';
import 'package:psicologia_app_liid/domain/entities/push_message.dart';
import 'package:psicologia_app_liid/data/repositories/notifications_repository.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter/material.dart'; 

part 'notifications_event.dart';
part 'notifications_state.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Notificación recibida en SEGUNDO PLANO: ${message.messageId}");

  if (message.notification != null) {
    print("Título: ${message.notification!.title}");
    print("Cuerpo: ${message.notification!.body}");
  } else {
    print("`notification` es NULL en segundo plano");
  }
}

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final NotificationsRepository notificationsRepository = NotificationsRepository();

  NotificationsBloc() : super(NotificationsInitial()) {
    on<NotificationStatusChanged>(_notificationStatusChanged);
    on<NotificationReceived>(_onPushMessageReceived);
    on<ScheduleNotification>(_scheduleNotification);
    on<LoadNotifications>(_loadNotifications);

    _initializeNotifications();
    _initialStatusCheck();
    _getFCMToken();
    _onForegroundMessage();
  }

  Future<void> _initializeNotifications() async {
    tz.initializeTimeZones();
    await LocalNotifications.initializeLocalNotifications(_onNotificationTapped);
    print("Inicializando listener de mensajes en primer plano...");
    _onForegroundMessage();
    add(LoadNotifications());
  }

  Future<void> _getFCMToken() async {
    try {
      final token = await messaging.getToken();
      if (token == null) {
        print("FCM Token es null.");
      } else {
        print("FCM Token: $token");
      }
    } catch (e) {
      print("Error obteniendo el token de FCM: $e");
    }
  }

  Future<void> _initialStatusCheck() async {
    final settings = await messaging.getNotificationSettings();

    if (settings.authorizationStatus == AuthorizationStatus.notDetermined) {
      await messaging.requestPermission();
    }

    print("Estado de permisos de notificaciones: ${settings.authorizationStatus}");
  }

  void _notificationStatusChanged(NotificationStatusChanged event, Emitter<NotificationsState> emit) {
    print("Permiso de notificaciones cambiado a: \${event.status}");
    emit(NotificationsLoaded(status: event.status, notifications: []));
  }

  void _onForegroundMessage() {
    FirebaseMessaging.onMessage.listen((message) async {
      print("Mensaje recibido de FCM: ${message.toMap()}");

      String title = message.notification?.title ?? message.data['title'] ?? "Título predeterminado";
      String body = message.notification?.body ?? message.data['body'] ?? "Mensaje predeterminado";
      
      String? imageUrl = message.notification?.android?.imageUrl ?? message.data['imageUrl'];

      print("Notificación procesada: $title - $body");
      print("Imagen recibida: $imageUrl");

      final pushMessage = PushMessage(
        messageId: message.messageId ?? "unknown_id",
        title: title,
        body: body,
        sentDate: message.sentTime ?? DateTime.now(),
        data: message.data,
        imageUrl: imageUrl,  
      );

      await notificationsRepository.saveNotification(pushMessage);

      LocalNotifications.showLocalNotification(
        id: pushMessage.messageId.hashCode,
        title: pushMessage.title,
        body: pushMessage.body,
        imageUrl: pushMessage.imageUrl, 
      );

      add(NotificationReceived(pushMessage));
    });
  }

  Future<void> _loadNotifications(LoadNotifications event, Emitter<NotificationsState> emit) async {
    final List<PushMessage> notifications = await notificationsRepository.getUserNotifications();
    emit(NotificationsLoaded(status: AuthorizationStatus.authorized, notifications: notifications)); 
  }

  Future<void> _scheduleNotification(ScheduleNotification event, Emitter<NotificationsState> emit) async {
    final now = DateTime.now();
    var scheduledTime = DateTime(
      event.date.year, event.date.month, event.date.day,
      event.time.hour, event.time.minute,
    );

    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    DateTimeComponents? repeatComponent;
    if (event.frequency == "Diariamente") {
      repeatComponent = DateTimeComponents.time;
    } else if (event.frequency == "Semanal") {
      repeatComponent = DateTimeComponents.dayOfWeekAndTime;
    } else if (event.frequency == "Personalizado" && event.selectedDays != null) {
      for (int day in event.selectedDays!) {
        DateTime customTime = scheduledTime.add(Duration(days: (day - scheduledTime.weekday) % 7));
        final tz.TZDateTime tzCustomTime = tz.TZDateTime.from(customTime, tz.local);

        await LocalNotifications.scheduleNotification(
          id: tzCustomTime.hashCode,
          title: event.title, 
          body: event.body, 
          scheduledTime: tzCustomTime,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        );
      }

      await notificationsRepository.saveNotification(
        PushMessage(
          messageId: scheduledTime.toString(),
          title: event.title, 
          body: event.body,
          sentDate: scheduledTime,
          frequency: event.frequency,
          selectedDays: event.selectedDays,
        ),
      );
      return;
    }

    final tz.TZDateTime tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);

    await LocalNotifications.scheduleNotification(
      id: tzScheduledTime.hashCode,
      title: event.title, 
      body: event.body, 
      scheduledTime: tzScheduledTime,
      matchDateTimeComponents: repeatComponent,
    );

    await notificationsRepository.saveNotification(
      PushMessage(
        messageId: tzScheduledTime.toString(),
        title: event.title,
        body: event.body, 
        sentDate: tzScheduledTime.toLocal(),
        frequency: event.frequency,
        selectedDays: event.selectedDays,
      ),
    );

    emit(NotificationsLoaded(
      status: AuthorizationStatus.authorized,
      notifications: (state is NotificationsLoaded) ? (state as NotificationsLoaded).notifications : [],
    ));
  }

  void _onNotificationTapped(NotificationResponse response) {
    print("Notificación tocada: ${response.payload}");
  }

  void _onPushMessageReceived(NotificationReceived event, Emitter<NotificationsState> emit) {
    print("Notificación recibida y almacenada: \${event.pushMessage.title}");

    if (state is NotificationsLoaded) {
      final currentState = state as NotificationsLoaded;
      emit(currentState.copyWith(notifications: [event.pushMessage, ...currentState.notifications]));
    }
  }
}
