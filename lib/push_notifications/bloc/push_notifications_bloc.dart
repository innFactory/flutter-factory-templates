import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../model/push_notification.dart';
import '../model/push_notification_channel.dart';
import '../push_notifications_repository.dart';

part 'push_notifications_event.dart';
part 'push_notifications_state.dart';

/// {@template PushNotificationsBloc}
/// Handles PushNotification logic with [FirebaseMessaging]
/// {@endtemplate}
class PushNotificationsBloc
    extends Bloc<PushNotificationsEvent, PushNotificationsState> {
  /// The [Logger] instance used for debugging
  final Logger logger;

  /// A list of [PushNotificationChannel] to initialize
  final List<PushNotificationChannel> channels;

  final PushNotificationsRepository _pushNotificationRepository;

  /// {@macro PushNotificationsBloc}
  PushNotificationsBloc({
    @required this.logger,
    @required this.channels,
  }) : _pushNotificationRepository = PushNotificationsRepository(logger);

  @override
  PushNotificationsState get initialState => PushNotificationsUninitialized();

  @override
  Stream<PushNotificationsState> mapEventToState(
    PushNotificationsEvent event,
  ) async* {
    if (event is InitPushNotifications) {
      yield* _mapInitPushNotificationsToState();
    } else if (event is TogglePushNotificationChannel) {
      yield* _mapTogglePushNotificationChannelToState(event.channel);
    } else if (event is PushNotificationReceived) {
      yield* _mapPushNotificationReceivedToState(event.notification);
    }
  }

  Stream<PushNotificationsState> _mapInitPushNotificationsToState() async* {
    yield PushNotificationsLoaded(
      channels: await _pushNotificationRepository.initialize(
        initialChannels: channels,
        onMessage: (notification) =>
            add(PushNotificationReceived(notification)),
      ),
    );
  }

  Stream<PushNotificationsState> _mapTogglePushNotificationChannelToState(
      PushNotificationChannel channel) async* {
    await _pushNotificationRepository.toggleSubscription(channel);
    yield PushNotificationsLoaded(
      channels: (state as PushNotificationsLoaded).channels.map((e) {
        if (e.identifier == channel.identifier) {
          return channel.copyWith(isSubscribed: !channel.isSubscribed);
        }

        return e;
      }).toList(),
    );
  }

  Stream<PushNotificationsState> _mapPushNotificationReceivedToState(
      PushNotification notification) async* {
    logger.d('Received notification $notification');

    BotToast.showSimpleNotification(
      title: notification.title,
      subTitle: notification.message,
      duration: Duration(seconds: 5),
    );
  }
}
