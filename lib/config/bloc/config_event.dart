part of 'config_bloc.dart';

abstract class ConfigEvent extends Equatable {
  const ConfigEvent();

  @override
  List<Object> get props => [];
}

class InitConfig extends ConfigEvent {}

class UpdateConfig<T> extends ConfigEvent {
  final T config;

  UpdateConfig(this.config);

  @override
  List<Object> get props => [config];

  @override
  String toString() => 'UpdateConfig { config: $config }';
}

class UpdateRemoteConfig extends ConfigEvent {
  final Map<String, RemoteConfigValue> remoteConfig;

  UpdateRemoteConfig(this.remoteConfig);

  @override
  List<Object> get props => [remoteConfig];

  @override
  String toString() => 'UpdateRemoteConfig { remoteConfig: $remoteConfig }';
}
