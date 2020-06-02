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
  final PushNotificationsRepository _pushNotificationRepository;

  PushNotificationsBloc({
    @required this.channels,
  }) : _pushNotificationRepository = PushNotificationsRepository();

  @override
  PushNotificationsState get initialState => PushNotificationsUninitialized();

  @override
  Stream<PushNotificationsState> mapEventToState(
    PushNotificationsEvent event,
  ) async* {
    if (event is InitPushNotifications) {
      yield* _mapInitPushNotificationsToState();
    } else if (event is TogglePushNotificationChannel) {
      yield* _mapTogglePushNotificationChannelToState();
    }
  }

  Stream<PushNotificationsState> _mapInitPushNotificationsToState() async* {
    await _pushNotificationRepository.initialize(channels);
    yield PushNotificationsLoaded(channels: channels);
  }

  Stream<PushNotificationsState> _mapTogglePushNotificationChannelToState() async* {}
}
