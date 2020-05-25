import 'dart:async';
import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:template/model/settings.dart';

typedef RemoteConfigCallback = void Function(Map<String, RemoteConfigValue> config);

class SettingsRepository {
  Future<void> setupRemoteConfig(RemoteConfigCallback callback) async {
    final remoteConfig = await RemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: false));

    Timer.periodic(Duration(minutes: 60), (timer) {
      _fetch(remoteConfig, callback);
    });

    await _fetch(remoteConfig, callback);
  }

  Future<void> _fetch(RemoteConfig remoteConfig, RemoteConfigCallback callback) async {
    try {
      await remoteConfig.fetch(expiration: const Duration(minutes: 60));
      await remoteConfig.activateFetched();

      print(' - - Fetching Remote Config  - -');
      print('Last Fetch Status: ' + remoteConfig.lastFetchStatus.toString());
      print('Last Fetch Time: ' + remoteConfig.lastFetchTime.toString());
      print('Debug Mode: ' + remoteConfig.remoteConfigSettings.debugMode.toString());
      print('- - - - Fetch finished - - - - - ');

      callback(remoteConfig.getAll());
    } catch (e) {
      print(e);
      print('- - - Fetch error - - - ');
    }
  }

  Future<bool> save(Settings settings) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.setString('settings', json.encode(settings.toJson()));
  }

  Future<Settings> load() async {
    final preferences = await SharedPreferences.getInstance();

    final settingsString = preferences.getString('settings');
    if (settingsString != null) {
      return Settings.fromJson(json.decode(settingsString)).merge(Settings(initialized: true));
    } else {
      await save(Settings(remoteConfigInitialized: false, initialized: true));
    }

    return Settings(remoteConfigInitialized: false, initialized: true);
  }
}
