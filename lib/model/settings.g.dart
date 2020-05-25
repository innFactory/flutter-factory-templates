// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) {
  return Settings(
    welcome: json['welcome'] as String,
    remoteConfigInitialized: json['remoteConfigInitialized'] as bool,
  );
}

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
      'welcome': instance.welcome,
      'remoteConfigInitialized': instance.remoteConfigInitialized,
    };
