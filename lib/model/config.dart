import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'config.g.dart';

@JsonSerializable()
class Config extends Equatable {
  final String welcome;

  Config({
    this.welcome,
  });

  Config merge(Config config) => Config(
        welcome: config.welcome ?? welcome,
      );

  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);

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
