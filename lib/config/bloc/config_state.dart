part of 'config_bloc.dart';

abstract class ConfigState extends Equatable {
  @override
  List<Object> get props => [];
}

class ConfigUninitialized extends ConfigState {}

class ConfigLoaded<T> extends ConfigState {
  final T config;
  final bool remoteConfigInitialized;

  ConfigLoaded({
    @required this.config,
    @required this.remoteConfigInitialized,
  });

  @override
  List<Object> get props => [config];

  @override
  String toString() => 'ConfigLoaded { config: $config, remoteConfigInitialized: $remoteConfigInitialized }';
}
