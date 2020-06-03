import 'dart:async';
import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/config_bloc.dart';

typedef RemoteConfigData = Function(Map<String, RemoteConfigValue>);

/// {@template ConfigRepository}
/// Repository with helper functions used in Configuration
/// {@endtemplate}
class ConfigRepository<T> {
  /// [SharedPreferences] key for the Config as a json string
  static const String preferencesConfigKey = 'config';

  /// [SharedPreferences] key storing wether or not the
  /// [RemoteConfig] has been initialized before
  static const String preferencesRemoteConfigInitializedKey =
      'remoteConfigInitialized';

  StreamController<Map<String, RemoteConfigValue>> _remoteConfigStream;

  /// [Logger] instance to use for debugging
  final Logger logger;

  /// Helper method for converting the generic Config class to a json map
  final ConfigFromJson<T> configFromJson;

  /// Helper method for converting a json map to the generic Config class
  final ConfigToJson<T> configToJson;

  /// {@macro ConfigRepository}
  ConfigRepository({
    @required this.logger,
    @required this.configFromJson,
    @required this.configToJson,
  });

  /// Get a [StreamSubscription] to listen to updated on the [RemoteConfig]
  StreamSubscription listenToRemoteConfig(RemoteConfigData onData) {
    _setupRemoteConfig();
    _remoteConfigStream = StreamController<Map<String, RemoteConfigValue>>();
    return _remoteConfigStream.stream.listen(onData);
  }

  Future<void> _setupRemoteConfig() async {
    final remoteConfig = await RemoteConfig.instance;
    await remoteConfig
        .setConfigSettings(RemoteConfigSettings(debugMode: false));

    /// Refresh RemoteConfig every 60 minutes
    Timer.periodic(Duration(minutes: 60), (timer) {
      _fetch(remoteConfig);
    });

    await _fetch(remoteConfig);
  }

  Future<void> _fetch(RemoteConfig remoteConfig) async {
    try {
      await remoteConfig.fetch(expiration: const Duration(minutes: 60));
      await remoteConfig.activateFetched();

      logger.d('''
--- Fetching RemoteConfig ---
Last Fetch Status: ${remoteConfig.lastFetchStatus.toString()}
Last Fetch Time: ${remoteConfig.lastFetchTime.toString()}
Debug Mode: ${remoteConfig.remoteConfigSettings.debugMode.toString()}''');

      _remoteConfigStream.add(remoteConfig.getAll());
    } on Exception catch (e, stacktrace) {
      logger.e('Error Fetching RemoteConfig', e, stacktrace);
    }
  }

  /// Wether or not the [RemoteConfig] has been initialized at least once
  Future<bool> hasRemoteConfigBeenInitialized() async {
    final preferences = await SharedPreferences.getInstance();
    try {
      return preferences.getBool(preferencesRemoteConfigInitializedKey) ??
          false;
    } on Exception catch (_) {
      return false;
    }
  }

  /// Mark the [RemoteConfig] as initialized
  Future<bool> setRemoteConfigInitialized() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.setBool(preferencesRemoteConfigInitializedKey, true);
  }

  /// Save the current configuration to disk
  Future<bool> saveConfig(T config) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.setString(
        preferencesConfigKey, json.encode(configToJson(config)));
  }

  /// Load the current configuration from disk
  Future<T> loadConfig({@required T defaultConfig}) async {
    final preferences = await SharedPreferences.getInstance();
    final configString = preferences.getString(preferencesConfigKey);

    if (configString != null) {
      return configFromJson(json.decode(configString));
    } else {
      await preferences.setString(
          preferencesConfigKey, json.encode(configToJson(defaultConfig)));
      return defaultConfig;
    }
  }
}
