import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/push_notification.dart';
import 'model/push_notification_channel.dart';
import 'model/push_notification_type.dart';

typedef NotificationHandler = Function(PushNotification notification);

/// {@template PushNotificationsRepository}
/// Repository with helper functions used for PushNotifications
/// {@endtemplate}
class PushNotificationsRepository {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  /// [SharedPreferences] key prefix for [PushNotificationChannel]'s
  static String preferencesPushNotificationsKeyPrefix = 'pushNotifications';

  /// [Logger] instance to use for debugging
  final Logger logger;

  /// {@macro PushNotificationsRepository}
  PushNotificationsRepository(this.logger);

  /// Initialize [FirebaseMessaging] with given [initialChannels]
  Future<List<PushNotificationChannel>> initialize({
    @required List<PushNotificationChannel> initialChannels,
    @required NotificationHandler onMessage,
  }) async {
    await _firebaseMessaging.requestNotificationPermissions();
    await _firebaseMessaging.configure(
      onMessage: (message) => onMessage(PushNotification(
        payload: message,
        pushNotificationType: PushNotificationType.message,
      )),
      onLaunch: (message) => onMessage(PushNotification(
        payload: message,
        pushNotificationType: PushNotificationType.launch,
      )),
      onResume: (message) => onMessage(PushNotification(
        payload: message,
        pushNotificationType: PushNotificationType.resume,
      )),
    );

    logger.d('FCM Token: ${await _firebaseMessaging.getToken()}');

    final preferences = await SharedPreferences.getInstance();
    final futures = <Future>[];
    final channels = <PushNotificationChannel>[];

    for (final channel in initialChannels) {
      var subscribed = false;

      try {
        subscribed = preferences.getBool(_preferencesChannelKey(channel));
      } on Exception catch (_) {}

      channels.add(channel.copyWith(isSubscribed: subscribed));

      if ((subscribed == null && channel.initiallySubscribedTo) || subscribed) {
        futures.add(_firebaseMessaging.subscribeToTopic(channel.identifier));
      }
    }
    await Future.wait(futures);
    return channels;
  }

  /// Toggle the [FirebaseMessaging] subscription of the given [channel]
  Future toggleSubscription(PushNotificationChannel channel) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(
        _preferencesChannelKey(channel), !channel.isSubscribed);

    if (channel.isSubscribed) {
      await _firebaseMessaging.unsubscribeFromTopic(channel.identifier);
    } else {
      await _firebaseMessaging.subscribeToTopic(channel.identifier);
    }
  }

  String _preferencesChannelKey(PushNotificationChannel channel) =>
      '$preferencesPushNotificationsKeyPrefix.${channel.identifier}';
}
