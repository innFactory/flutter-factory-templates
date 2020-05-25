import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import 'package:template/blocs/settings/settings_repository.dart';
import 'package:template/model/settings.dart';

part 'settings_event.dart';

class SettingsBloc extends Bloc<SettingsEvent, Settings> {
  final SettingsRepository _settingsRepository;

  SettingsBloc() : _settingsRepository = SettingsRepository();

  @override
  Settings get initialState => Settings(initialized: false, remoteConfigInitialized: false);

  @override
  Stream<Settings> mapEventToState(
    SettingsEvent event,
  ) async* {
    if (event is InitSettings) {
      yield* _mapAppStartedToState();
    } else if (event is UpdateRemoteConfig) {
      yield* _mapUpdateRemoteConfigToState(event.config);
    } else if (event is UpdateSettings) {
      yield* _mapUpdateSettingsToState(event.settings);
    }
  }

  Stream<Settings> _mapAppStartedToState() async* {
    final settings = await _settingsRepository.load();
    yield settings;

    final setupRemoteConfig = _settingsRepository.setupRemoteConfig((Map<String, RemoteConfigValue> config) => add(UpdateRemoteConfig(config)));
    if (!settings.remoteConfigInitialized) await setupRemoteConfig;
  }

  Stream<Settings> _mapUpdateRemoteConfigToState(Map<String, RemoteConfigValue> config) async* {
    // TODO: Map Remote Config values
    yield state.merge(
      Settings(
        welcome: config['welcome'].toString(),
        remoteConfigInitialized: true,
      ),
    );
  }

  Stream<Settings> _mapUpdateSettingsToState(Settings settings) async* {
    yield state.merge(settings);
  }
}
