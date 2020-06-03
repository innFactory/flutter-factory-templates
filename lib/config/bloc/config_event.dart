part of 'config_bloc.dart';

/// {@template ConfigEvent}
/// Base class for config events handled in a [ConfigBloc]
/// {@endtemplate}
abstract class ConfigEvent extends Equatable {
  /// {@macro ConfigEvent}
  const ConfigEvent();

  @override
  List<Object> get props => [];
}

/// Event fired when the App starts to initialize Configuration
class InitConfig extends ConfigEvent {}

/// Event fired to update the config with a new [config] payload
class UpdateConfig<T> extends ConfigEvent {
  /// The new config payload
  final T config;

  /// {@macro UpdateConfig}
  UpdateConfig(this.config);

  @override
  List<Object> get props => [config];

  @override
  String toString() => 'UpdateConfig { config: $config }';
}

/// {@template UpdateRemoteConfig}
/// Event fired when the [RemoteConfig] has updated
/// {@endtemplate}
class UpdateRemoteConfig extends ConfigEvent {
  /// The new [RemoteConfig] values
  final Map<String, RemoteConfigValue> remoteConfig;

  /// {@macro UpdateRemoteConfig}
  UpdateRemoteConfig(this.remoteConfig);

  @override
  List<Object> get props => [remoteConfig];

  @override
  String toString() => 'UpdateRemoteConfig { remoteConfig: $remoteConfig }';
}
