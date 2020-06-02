import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:template/logger.dart';
import 'package:template/push_notifications/push_notification_channel.dart';

class PushNotificationsRepository {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  static String PREFERENCES_PUSH_NOTIFICATIONS_KEY = 'pushNotifications';

  Future<List<PushNotificationChannel>> initialize(List<PushNotificationChannel> initialChannels) async {
    //TODO: Background notifications in IOS don't show up yet
    await _firebaseMessaging.requestNotificationPermissions();
    await _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        logger.d('Received notification $message');
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

    logger.d('FCM Token: ${await _firebaseMessaging.getToken()}');

    final preferences = await SharedPreferences.getInstance();
    final futures = <Future>[];
    final channels = <PushNotificationChannel>[];

    for (final channel in initialChannels) {
      var subscribed = false;

      try {
        subscribed = preferences.getBool(_preferencesChannelKey(channel));
      } catch (_) {}

      channels.add(channel.copyWith(isSubscribed: subscribed));

      if ((subscribed == null && channel.initiallySubscribedTo) || subscribed) {
        futures.add(_firebaseMessaging.subscribeToTopic(channel.identifier));
      }
    }
    await Future.wait(futures);
    return channels;
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
