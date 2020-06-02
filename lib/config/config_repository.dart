import 'dart:async';
import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:template/logger.dart';

import 'bloc/config_bloc.dart';

typedef RemoteConfigData = Function(Map<String, RemoteConfigValue>);

class ConfigRepository<T> {
  static String PREFERENCES_CONFIG_KEY = 'config';
  static String PREFERENCES_REMOTE_CONFIG_INITIALIZED_KEY = 'remoteConfigInitialized';

  StreamController<Map<String, RemoteConfigValue>> _remoteConfigStream;

  final ConfigFromJson<T> configFromJson;
  final ConfigToJson<T> configToJson;

  ConfigRepository({
    @required this.configFromJson,
    @required this.configToJson,
  });

  StreamSubscription listenToRemoteConfig(RemoteConfigData onData) {
    _setupRemoteConfig();
    _remoteConfigStream = StreamController<Map<String, RemoteConfigValue>>();
    return _remoteConfigStream.stream.listen(onData);
  }

  Future<void> _setupRemoteConfig() async {
    final remoteConfig = await RemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: false));

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
Last Fetch Status: ' + remoteConfig.lastFetchStatus.toString()
Last Fetch Time: ' + remoteConfig.lastFetchTime.toString()
Debug Mode: ' + remoteConfig.remoteConfigSettings.debugMode.toString()''');

      _remoteConfigStream.add(remoteConfig.getAll());
    } catch (e, stacktrace) {
      logger.e('Error Fetching RemoteConfig', e, stacktrace);
    }
  }

  Future<bool> hasRemoteConfigBeenInitialized() async {
    final preferences = await SharedPreferences.getInstance();
    try {
      return preferences.getBool(PREFERENCES_REMOTE_CONFIG_INITIALIZED_KEY) ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> setRemoteConfigInitialized() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.setBool(PREFERENCES_REMOTE_CONFIG_INITIALIZED_KEY, true);
  }

  Future<bool> saveConfig(T config) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.setString(PREFERENCES_CONFIG_KEY, json.encode(configToJson(config)));
  }

  Future<T> loadConfig({@required T defaultConfig}) async {
    final preferences = await SharedPreferences.getInstance();
    final configString = preferences.getString(PREFERENCES_CONFIG_KEY);

    if (configString != null) {
      return configFromJson(json.decode(configString));
    } else {
      await preferences.setString(PREFERENCES_CONFIG_KEY, json.encode(configToJson(defaultConfig)));
      return defaultConfig;
    }
  }
}
