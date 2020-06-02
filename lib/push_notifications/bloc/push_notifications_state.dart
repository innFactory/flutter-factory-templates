part of 'push_notifications_bloc.dart';

abstract class PushNotificationsState extends Equatable {
  const PushNotificationsState();

  @override
  List<Object> get props => [];
}

class PushNotificationsUninitialized extends PushNotificationsState {}

class PushNotificationsLoaded extends PushNotificationsState {
  final List<PushNotificationChannel> channels;

  PushNotificationsLoaded({
    @required this.channels,
  });

  @override
  List<Object> get props => channels;

  @override
  String toString() => 'PushNotificationsLoaded { channels: $channels }';
}
