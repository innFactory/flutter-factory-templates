import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'config.g.dart';

/// {@template Config}
/// Config class for storing app wide configuration values
/// {@endtemplate}
@JsonSerializable()
class Config extends Equatable {
  /// Welcome string displayed on the [HomeScreen]
  final String welcome;

  /// {@macro Config}
  Config({
    this.welcome,
  });

  /// Return new [Config] instance with new [config] payload applied
  Config merge(Config config) => Config(
        welcome: config.welcome ?? welcome,
      );

  /// Instantiate [Config] from [json]
  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);

  /// Convert [Config] to [json] Map
  Map<String, dynamic> toJson() => _$ConfigToJson(this);

  @override
  List<Object> get props => [welcome];

  @override
  String toString() {
    return '''Config {
      welcome: $welcome,
    }''';
  }
}
