import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:template/push_notifications/push_notification_channel.dart';
import 'package:template/push_notifications/push_notifications_repository.dart';

part 'push_notifications_event.dart';
part 'push_notifications_state.dart';

class PushNotificationsBloc extends Bloc<PushNotificationsEvent, PushNotificationsState> {
  final List<PushNotificationChannel> channels;
  PushNotificationsRepository _pushNotificationRepository;

  PushNotificationsBloc({
    @required this.channels,
  }) {
    _pushNotificationRepository = PushNotificationsRepository();
  }

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
    }
  }

  Stream<PushNotificationsState> _mapInitPushNotificationsToState() async* {
    yield PushNotificationsLoaded(channels: await _pushNotificationRepository.initialize(channels));
  }

  Stream<PushNotificationsState> _mapTogglePushNotificationChannelToState(PushNotificationChannel channel) async* {
    await _pushNotificationRepository.toggleSubscription(channel);
    yield PushNotificationsLoaded(
      channels: (state as PushNotificationsLoaded).channels.map((e) {
        if (e.identifier == channel.identifier) return channel.copyWith(isSubscribed: !channel.isSubscribed);
        return e;
      }).toList(),
    );
  }
}
