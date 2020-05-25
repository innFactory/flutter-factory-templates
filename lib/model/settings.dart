import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'settings.g.dart';

@JsonSerializable()
class Settings extends Equatable {
  final String welcome;
  final bool remoteConfigInitialized;

  @JsonKey(ignore: true)
  final bool initialized;

  Settings({
    this.welcome,
    this.remoteConfigInitialized,
    this.initialized,
  });

  Settings merge(Settings updates) => Settings(
        welcome: updates.welcome ?? welcome,
        remoteConfigInitialized: updates.remoteConfigInitialized ?? remoteConfigInitialized,
        initialized: updates.initialized ?? initialized,
      );

  factory Settings.fromJson(Map<String, dynamic> json) => _$SettingsFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsToJson(this);

  @override
  List<Object> get props => [remoteConfigInitialized, initialized];

  @override
  String toString() {
    return '''Test {
      remoteConfigInitialized: $remoteConfigInitialized,
      initialized: $initialized,
    }''';
  }
}
