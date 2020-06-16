import 'package:flutter/foundation.dart';

import 'push_notification_type.dart';

export 'push_notification_type.dart';

/// {@template PushNotification}
/// Model class to store received PushNotification data
/// {@endtemplate}
class PushNotification {
  /// The Notification payload received by [FirebaseMessaging]
  final Map<String, dynamic> payload;

  /// The Type of the notification
  final PushNotificationType type;

  /// {@macro PushNotification}
  PushNotification({
    @required this.payload,
    @required this.type,
  });

  /// Gets the notification title out of the [payload]
  String get title => payload['notification']['title'];

  /// Gets the notification message out of the [payload]
  String get message => payload['notification']['body'];

  /// Gets the route out of the [payload]
  String get route => payload['data']['route'];

  /// Wether or not the payload contains a route
  bool get hasRoute => payload['data']['route'] != null;

  @override
  String toString() => 'PushNotification { payload: $payload }';
}
