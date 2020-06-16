/// RegExp for validating a [PushNotificationChannel]'s identifier
final RegExp pushNotificationChannelIdentifierRegExp =
    RegExp('[a-zA-Z0-9-_.~%]{1,900}');

/// {@template PushNotificationChannel}
/// Model for a [FirebaseMessaging] topic
/// {@endtemplate}
class PushNotificationChannel {
  /// The identifier of the Channel in [FirebaseMessaging]
  final String identifier;

  /// Wether or not this channel should initially be subscribed to
  final bool initiallySubscribedTo;

  /// Wether or not this channel is currently subscribed to
  final bool isSubscribed;

  /// {@macro PushNotificationChannel}
  PushNotificationChannel(
    this.identifier, {
    this.initiallySubscribedTo = false,
    this.isSubscribed = false,
  }) : assert(pushNotificationChannelIdentifierRegExp.hasMatch(identifier));

  /// Update the subscription status of this channel
  PushNotificationChannel copyWith({
    bool isSubscribed,
  }) =>
      PushNotificationChannel(
        identifier,
        initiallySubscribedTo: initiallySubscribedTo,
        isSubscribed: isSubscribed ?? this.isSubscribed,
      );

  @override
  String toString() => '''PushNotificationChannel {
    identifier: $identifier,
    isSubscribed: $isSubscribed
  }''';
}
