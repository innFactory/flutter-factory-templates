part of 'push_notifications_bloc.dart';

/// {@template PushNotificationsEvent}
/// Base class for PushNotification events handled in an [PushNotificationsBloc]
/// {@endtemplate}
abstract class PushNotificationsEvent extends Equatable {
  /// {@macro PushNotificationsEvent}
  const PushNotificationsEvent();

  @override
  List<Object> get props => [];
}

/// Event fired when the App starts to initialize PushNotifications
class InitPushNotifications extends PushNotificationsEvent {}

/// {@template TogglePushNotificationChannel}
/// Event fired to toggle the subscription of a [PushNotificationChannel]
/// {@endtemplate}
class TogglePushNotificationChannel extends PushNotificationsEvent {
  /// The Channel of which to toggle the [FirebaseMessaging] subscription
  final PushNotificationChannel channel;

  /// {@macro TogglePushNotificationChannel}
  TogglePushNotificationChannel(this.channel);

  @override
  List<Object> get props => [channel];

  @override
  String toString() => 'TogglePushNotificationChannel { channel: $channel }';
}

/// {@template PushNotificationReceived}
/// Event fired when a [PushNotification] is received
/// {@endtemplate}
class PushNotificationReceived extends PushNotificationsEvent {
  /// The received notification
  final PushNotification notification;

  /// {@macro PushNotificationReceived}
  PushNotificationReceived(this.notification);

  @override
  List<Object> get props => [notification];

  @override
  String toString() =>
      'PushNotificationReceived { notification: $notification }';
}
