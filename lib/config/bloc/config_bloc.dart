import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../config_repository.dart';

part 'config_event.dart';
part 'config_state.dart';

typedef ConfigFromJson<T> = T Function(Map<String, dynamic> json);
typedef ConfigToJson<T> = Map<String, dynamic> Function(T config);
typedef ConfigMerge<T> = T Function(T configA, T configB);

typedef RemoteConfigToConfig<T> = T Function(
    Map<String, RemoteConfigValue> remoteConfigMap);

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

  /// Helper method to map the [RemoteConfig] to the generic Config class
  final RemoteConfigToConfig<T> remoteConfigToConfig;

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
    this.remoteConfigToConfig,
  })  : _configRepository = ConfigRepository(
          logger: logger,
          configFromJson: configFromJson,
          configToJson: configToJson,
        ),
        assert((remoteConfigEnabled && remoteConfigToConfig != null) ||
            (!remoteConfigEnabled && remoteConfigToConfig == null));

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
    } else if (event is UpdateConfig) {
      yield* _mapUpdateConfigToState(event.config);
    }
  }

  Stream<ConfigState> _mapInitConfigToState() async* {
    yield ConfigLoaded(
      config: await _configRepository.loadConfig(defaultConfig: defaultConfig),
      remoteConfigInitialized: remoteConfigEnabled
          ? await _configRepository.hasRemoteConfigBeenInitialized()
          : true,
    );

    if (remoteConfigEnabled) {
      _configRepository.listenToRemoteConfig(
          (remoteConfig) => add(UpdateRemoteConfig(remoteConfig)));
    }
  }

  Stream<ConfigState> _mapUpdateRemoteConfigToState(
      Map<String, RemoteConfigValue> remoteConfigMap) async* {
    final remoteConfig = remoteConfigToConfig(remoteConfigMap);
    await _configRepository.setRemoteConfigInitialized();

    yield ConfigLoaded(
      config: configMerge((state as ConfigLoaded).config, remoteConfig),
      remoteConfigInitialized: true,
    );
  }

  Stream<ConfigState> _mapUpdateConfigToState(T config) async* {
    final oldState = state as ConfigLoaded;

    yield ConfigLoaded(
      config: configMerge(oldState.config, config),
      remoteConfigInitialized: oldState.config,
    );
  }
}
