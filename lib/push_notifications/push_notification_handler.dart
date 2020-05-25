import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:template/push_notifications/model/push_notification_channel.dart';

class PushNotificationHandler {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

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
      //TODO: Check local storage and maybe don't subscribe
      if (channel.initiallySubscribedTo) {
        futures.add(_firebaseMessaging.subscribeToTopic(channel.identifier));
      }
    }

    return Future.wait(futures);
  }
}
