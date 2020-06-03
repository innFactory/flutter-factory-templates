part of 'push_notifications_bloc.dart';

/// {@template PushNotificationsState}
/// Base class for PushNotifications states provided
/// in an [PushNotificationsBloc]
/// {@endtemplate}
abstract class PushNotificationsState extends Equatable {
  /// {@macro PushNotificationsState}
  const PushNotificationsState();

  @override
  List<Object> get props => [];
}

/// [PushNotificationsBloc] State when PushNotifications
/// have not been initialized
class PushNotificationsUninitialized extends PushNotificationsState {}

/// {@template PushNotificationsLoaded}
/// [PushNotificationsBloc] State when the [PushNotificationChannel]'s
/// have been loaded and subscribed to
/// {@endtemplate}
class PushNotificationsLoaded extends PushNotificationsState {
  /// The availabel channels with their subscription status
  final List<PushNotificationChannel> channels;

  /// {@macro PushNotificationsLoaded}
  PushNotificationsLoaded({
    @required this.channels,
  });

  @override
  List<Object> get props => channels;

  @override
  String toString() => 'PushNotificationsLoaded { channels: $channels }';
}
