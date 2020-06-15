import 'dart:async';
import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/config_bloc.dart';

typedef RemoteConfigDataCallback = Function(Map<String, String>);

/// {@template ConfigRepository}
/// Repository with helper functions used in Configuration
/// {@endtemplate}
class ConfigRepository<T> {
  /// [SharedPreferences] key for the Config as a json string
  static const String preferencesConfigKey = 'config';

  /// [SharedPreferences] key for the RemoteConfig as a json string
  static const String preferencesRemoteConfigKey = 'remoteConfig';

  /// [SharedPreferences] key storing wether or not the [RemoteConfig] has been initialized before
  static const String preferencesRemoteConfigInitializedKey = 'remoteConfigInitialized';

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

  Future<void> setupRemoteConfig({
    @required RemoteConfigDataCallback onUpdate,
    @required VoidCallback onUpdateFailed,
  }) async {
    final remoteConfig = await RemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: false));

    /// Refresh RemoteConfig every 60 minutes
    Timer.periodic(Duration(minutes: 60), (timer) {
      fetchRemoteConfig(
        remoteConfig: remoteConfig,
        onUpdate: onUpdate,
        onUpdateFailed: onUpdateFailed,
      );
    });

    await fetchRemoteConfig(
      remoteConfig: remoteConfig,
      onUpdate: onUpdate,
      onUpdateFailed: onUpdateFailed,
    );
  }

  Future<void> fetchRemoteConfig({
    @required RemoteConfig remoteConfig,
    @required RemoteConfigDataCallback onUpdate,
    @required VoidCallback onUpdateFailed,
  }) async {
    try {
      await remoteConfig.fetch(expiration: const Duration(minutes: 60));
      await remoteConfig.activateFetched();

      logger.d('--- Fetching RemoteConfig ---\n'
          'Last Fetch Status: ${remoteConfig.lastFetchStatus.toString()}\n'
          'Last Fetch Time: ${remoteConfig.lastFetchTime.toString()}\n'
          'Debug Mode: ${remoteConfig.remoteConfigSettings.debugMode.toString()}');

      onUpdate(_remoteConfigMapAsStringMap(remoteConfig.getAll()));
    } on Exception catch (e, stacktrace) {
      onUpdateFailed();
      logger.e('Error Fetching RemoteConfig', e, stacktrace);
    }
  }

  /// Wether or not the [RemoteConfig] has been initialized at least once
  Future<bool> hasRemoteConfigBeenInitialized() async {
    final preferences = await SharedPreferences.getInstance();
    try {
      return preferences.getBool(preferencesRemoteConfigInitializedKey) ?? false;
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
  Future<bool> saveRemoteConfig(Map<String, RemoteConfigValue> remoteConfigMap) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.setString(
      preferencesRemoteConfigKey,
      json.encode(_remoteConfigMapAsStringMap(remoteConfigMap)),
    );
  }

  /// Save the current configuration to disk
  Future<Map<String, String>> loadRemoteConfig() async {
    final preferences = await SharedPreferences.getInstance();
    return json.decode(preferences.getString(preferencesRemoteConfigKey));
  }

  /// Save the current configuration to disk
  Future<bool> saveConfig(T config) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.setString(preferencesConfigKey, json.encode(configToJson(config)));
  }

  /// Load the current configuration from disk
  Future<T> loadConfig({@required T defaultConfig}) async {
    final preferences = await SharedPreferences.getInstance();
    final configString = preferences.getString(preferencesConfigKey);

    if (configString != null) {
      return configFromJson(json.decode(configString));
    } else {
      await preferences.setString(preferencesConfigKey, json.encode(configToJson(defaultConfig)));
      return defaultConfig;
    }
  }

  Map<String, String> _remoteConfigMapAsStringMap(Map<String, RemoteConfigValue> remoteConfigMap) {
    return remoteConfigMap.map((key, value) => MapEntry(key, value.toString()));
  }
}
