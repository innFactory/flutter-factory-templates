part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class InitSettings extends SettingsEvent {}

class UpdateSettings extends SettingsEvent {
  final Settings settings;

  UpdateSettings(this.settings);

  @override
  List<Object> get props => [settings];

  @override
  String toString() => 'UpdateSettings { settings: $settings }';
}

class UpdateRemoteConfig extends SettingsEvent {
  final Map<String, RemoteConfigValue> config;

  UpdateRemoteConfig(this.config);

  @override
  List<Object> get props => [config];

  @override
  String toString() => 'UpdateRemoteConfig { config: $config }';
}
