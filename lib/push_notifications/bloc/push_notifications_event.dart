part of 'push_notifications_bloc.dart';

abstract class PushNotificationsEvent extends Equatable {
  const PushNotificationsEvent();

  @override
  List<Object> get props => [];
}

class InitPushNotifications extends PushNotificationsEvent {}

class TogglePushNotificationChannel extends PushNotificationsEvent {
  final PushNotificationChannel channel;

  TogglePushNotificationChannel(this.channel);

  @override
  List<Object> get props => [channel];

  @override
  String toString() => 'TogglePushNotificationChannel { channel: $channel }';
}
