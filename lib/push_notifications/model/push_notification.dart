import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'push_notification.g.dart';

@JsonSerializable()
class PushNotification extends Equatable {
  final String title;
  final String body;
  final Map<dynamic, dynamic> data;
  final bool seen;
  final DateTime seenAt;
  final DateTime receivedAt;

  PushNotification({
    @required this.title,
    @required this.body,
    @required this.data,
    @required this.seen,
    @required this.seenAt,
    @required this.receivedAt,
  });

  PushNotification copyWith({
    String title,
    String body,
    Map<dynamic, dynamic> data,
    bool seen,
    DateTime seenAt,
    DateTime receivedAt,
  }) =>
      PushNotification(
        title: title ?? this.title,
        body: body ?? this.body,
        data: data ?? this.data,
        seen: seen ?? this.seen,
        seenAt: seenAt ?? this.seenAt,
        receivedAt: receivedAt ?? this.receivedAt,
      );

  factory PushNotification.fromJson(Map<String, dynamic> json) => _$PushNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$PushNotificationToJson(this);

  @override
  List<Object> get props => [
        title,
        body,
        data,
        seen,
        seenAt,
        receivedAt,
      ];

  @override
  String toString() {
    return '''PushNotification {
      title: $title,
      body: $body,
      data: $data,
      seen: $seen,
      seenAt: $seenAt,
      receivedAt: $receivedAt,
    }''';
  }
}
