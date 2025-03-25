part of 'notifications_bloc.dart';

sealed class NotificationsEvent {
  const NotificationsEvent();
}

class NotificationStatusChanged extends NotificationsEvent {
  final AuthorizationStatus status;
  NotificationStatusChanged(this.status);
}

class NotificationReceived extends NotificationsEvent {
  final PushMessage pushMessage;
  NotificationReceived(this.pushMessage);
}

class ScheduleNotification extends NotificationsEvent {
  final DateTime date;
  final TimeOfDay time;
  final String title;
  final String body;
  final String frequency; // "Diario", "Semanal", "Personalizado"
  final List<int>? selectedDays; // Lista de días seleccionados (0 = Domingo, 1 = Lunes, ..., 6 = Sábado)

  ScheduleNotification({
    required this.date,
    required this.time,
    required this.title, 
    required this.body, 
    required this.frequency,
    this.selectedDays, // Opcional
  });

  
}



class LoadNotifications extends NotificationsEvent {} 
