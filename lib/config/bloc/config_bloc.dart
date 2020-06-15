import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../config_repository.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

part 'config_event.dart';
part 'config_state.dart';

typedef ConfigFromJson<T> = T Function(Map<String, dynamic> json);
typedef ConfigToJson<T> = Map<String, dynamic> Function(T config);
typedef ConfigMerge<T> = T Function(T configA, T configB);

typedef RemoteConfigToConfig<T> = T Function(Map<String, RemoteConfigValue> remoteConfigMap);

/// {@template ConfigBloc}
/// Handles configuration logic based on a generic Config class
/// {@endtemplate}
class ConfigBloc<T> extends Bloc<ConfigEvent, ConfigState> {
  final ConfigRepository<T> _configRepository;

  /// The [Logger] instance to use for debugging.
  final Logger logger;

  /// The default / initial configuration.
  final T defaultConfig;

  /// Helper method for converting the generic Config class to a json map
  final ConfigFromJson<T> configFromJson;

  /// Helper method for converting a json map to the generic Config class
  final ConfigToJson<T> configToJson;

  /// Helper method to merge an existing Config state with a new payload
  final ConfigMerge<T> configMerge;

  /// Flag wether or not to enable [RemoteConfig]
  final bool remoteConfigEnabled;

  /// {@macro ConfigBloc}
  ConfigBloc({
    @required this.logger,
    @required this.defaultConfig,
    @required this.configFromJson,
    @required this.configToJson,
    @required this.configMerge,
    @required this.remoteConfigEnabled,
  }) : _configRepository = ConfigRepository(
          logger: logger,
          configFromJson: configFromJson,
          configToJson: configToJson,
        ) {
    add(InitConfig());
  }

  @override
  ConfigState get initialState => ConfigUninitialized();

  @override
  Stream<ConfigState> mapEventToState(
    ConfigEvent event,
  ) async* {
    if (event is InitConfig) {
      yield* _mapInitConfigToState();
    } else if (event is UpdateRemoteConfig) {
      yield* _mapUpdateRemoteConfigToState(event.remoteConfig);
    } else if (event is UpdateRemoteConfigFailed) {
      yield* _mapRemoteConfigUpdateFailedToState();
    } else if (event is ReloadRemoteConfig) {
      yield* _mapReloadRemoteConfigToState();
    } else if (event is UpdateConfig) {
      yield* _mapUpdateConfigToState(event.config);
    }
  }

  Stream<ConfigState> _mapInitConfigToState() async* {
    if (remoteConfigEnabled) {
      await _configRepository.setupRemoteConfig(
        onUpdate: _onRemoteConfigUpdate,
        onUpdateFailed: _onRemoteConfigUpdateFailed,
      );
    } else {
      yield ConfigLoaded(
        config: await _configRepository.loadConfig(defaultConfig: defaultConfig),
        remoteConfig: null,
      );
    }
  }

  Stream<ConfigState> _mapUpdateRemoteConfigToState(Map<String, String> remoteConfigMap) async* {
    await _configRepository.setRemoteConfigInitialized();

    var config;

    if (state is ConfigUninitialized) {
      config = await _configRepository.loadConfig(defaultConfig: defaultConfig);
    } else {
      config = (state as ConfigLoaded).config;
    }

    yield ConfigLoaded(
      config: config,
      remoteConfig: remoteConfigMap,
    );
  }

  Stream<ConfigState> _mapRemoteConfigUpdateFailedToState() async* {
    final hasRemoteConfigBeenInitialized = await _configRepository.hasRemoteConfigBeenInitialized();

    if (!hasRemoteConfigBeenInitialized) {
      yield RemoteConfigNotInitialized();
    }
  }

  Stream<ConfigState> _mapReloadRemoteConfigToState() async* {
    assert(remoteConfigEnabled);

    await _configRepository.fetchRemoteConfig(
      remoteConfig: await RemoteConfig.instance,
      onUpdate: _onRemoteConfigUpdate,
      onUpdateFailed: _onRemoteConfigUpdateFailed,
    );
  }

  Stream<ConfigState> _mapUpdateConfigToState(T config) async* {
    final oldState = state as ConfigLoaded;

    yield ConfigLoaded(
      config: configMerge(oldState.config, config),
      remoteConfig: oldState.remoteConfig,
    );
  }

  _onRemoteConfigUpdate(Map<String, String> remoteConfigMap) => add(UpdateRemoteConfig(remoteConfigMap));

  _onRemoteConfigUpdateFailed() => add(UpdateRemoteConfigFailed());
}
