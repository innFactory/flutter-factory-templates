part of 'config_bloc.dart';

/// {@template AuthState}
/// Base class for configuration states provided in a [ConfigBloc]
/// {@endtemplate}
abstract class ConfigState extends Equatable {
  @override
  List<Object> get props => [];
}

/// [ConfigBloc] State when Configuration has not been initialized
class ConfigUninitialized extends ConfigState {}

/// {@template ConfigLoaded}
/// [ConfigBloc] State when the Configuration has been loaded
/// {@endtemplate}
class ConfigLoaded<T> extends ConfigState {
  /// The current config
  final T config;

  /// The current [RemoteConfig] if enabled
  final Map<String, String> remoteConfig;

  /// {@macro ConfigLoaded}
  ConfigLoaded({
    @required this.config,
    @required this.remoteConfig,
  });

  @override
  List<Object> get props => [config];

  @override
  String toString() => '''ConfigLoaded {
    config: $config,
    remoteConfig: $remoteConfig,
  }''';
}

class RemoteConfigNotInitialized extends ConfigState {}
