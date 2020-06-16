/// The type of PushNotification stating when it was received
enum PushNotificationType {
  /// The notification was received while the app was open
  message,

  /// The notification was received in the background and the app was closed
  launch,

  /// The notification was received in the background and the app was
  /// still open in the background as well
  resume
}
