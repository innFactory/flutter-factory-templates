import 'package:template/push_notifications/model/push_notification.dart';

class PushNotificationChannel {
  final String identifier;
  final bool initiallySubscribedTo;
  final bool isSubscribed;
  final List<PushNotification> pushNotifications;

  PushNotificationChannel(
    this.identifier, {
    this.initiallySubscribedTo = false,
    this.isSubscribed = false,
    this.pushNotifications = const [],
  });
}
