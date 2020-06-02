import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:template/push_notifications/push_notification_channel.dart';

class PushNotificationsRepository {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  static String PREFERENCES_PUSH_NOTIFICATIONS_KEY = 'pushNotifications';

  Future<void> initialize(List<PushNotificationChannel> channels) async {
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        BotToast.showSimpleNotification(
          title: message['notification']['title'],
          subTitle: message['notification']['body'],
          duration: Duration(seconds: 5),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        //TODO: Implement navigation
        print('PushNotificationHandler.onLaunch: $message');
      },
      onResume: (Map<String, dynamic> message) async {
        //TODO: Implement navigation
        print('PushNotificationHandler.onResume: $message');
      },
    );
    final futures = <Future>[];

    for (final channel in channels) {
      final isSubscribed = await _isSubscribed(channel);

      if ((isSubscribed == null && channel.initiallySubscribedTo) || isSubscribed) {
        futures.add(_firebaseMessaging.subscribeToTopic(channel.identifier));
      }
    }

    return Future.wait(futures);
  }

  Future<bool> _isSubscribed(PushNotificationChannel channel) async {
    final preferences = await SharedPreferences.getInstance();

    try {
      return preferences.getBool(_preferencesChannelKey(channel));
    } catch (e) {
      return null;
    }
  }

  Future toggleSubscription(PushNotificationChannel channel) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_preferencesChannelKey(channel), !channel.isSubscribed);

    if (channel.isSubscribed) {
      await _firebaseMessaging.unsubscribeFromTopic(channel.identifier);
    } else {
      await _firebaseMessaging.subscribeToTopic(channel.identifier);
    }
  }

  String _preferencesChannelKey(PushNotificationChannel channel) => '$PREFERENCES_PUSH_NOTIFICATIONS_KEY.${channel.identifier}';
}
