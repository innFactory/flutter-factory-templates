final pushNotificationChannelIdentifierRegex = RegExp('[a-zA-Z0-9-_.~%]{1,900}');

class PushNotificationChannel {
  final String identifier;
  final bool initiallySubscribedTo;
  final bool isSubscribed;

  PushNotificationChannel(
    this.identifier, {
    this.initiallySubscribedTo = false,
    this.isSubscribed = false,
  }) : assert(pushNotificationChannelIdentifierRegex.hasMatch(identifier));

  PushNotificationChannel copyWith({
    bool isSubscribed,
  }) =>
      PushNotificationChannel(
        identifier,
        initiallySubscribedTo: initiallySubscribedTo,
        isSubscribed: isSubscribed ?? this.isSubscribed,
      );

  @override
  String toString() => 'PushNotificationChannel { identifier: $identifier, isSubscribed: $isSubscribed }';
}
