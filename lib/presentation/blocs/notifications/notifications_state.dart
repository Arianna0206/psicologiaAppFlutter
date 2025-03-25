part of 'notifications_bloc.dart';

sealed class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object?> get props => [];
}

final class NotificationsInitial extends NotificationsState {}

final class NotificationsLoaded extends NotificationsState {
  final AuthorizationStatus status;
  final List<PushMessage> notifications;

  const NotificationsLoaded({
    required this.status,
    required this.notifications,
  });

  NotificationsLoaded copyWith({
    AuthorizationStatus? status,
    List<PushMessage>? notifications,
  }) {
    return NotificationsLoaded(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
    );
  }

  @override
  List<Object?> get props => [status, notifications];
}
