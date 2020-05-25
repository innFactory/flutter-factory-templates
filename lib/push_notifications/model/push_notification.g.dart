// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PushNotification _$PushNotificationFromJson(Map<String, dynamic> json) {
  return PushNotification(
    title: json['title'] as String,
    body: json['body'] as String,
    data: json['data'] as Map<String, dynamic>,
    seen: json['seen'] as bool,
    seenAt: json['seenAt'] == null
        ? null
        : DateTime.parse(json['seenAt'] as String),
    receivedAt: json['receivedAt'] == null
        ? null
        : DateTime.parse(json['receivedAt'] as String),
  );
}

Map<String, dynamic> _$PushNotificationToJson(PushNotification instance) =>
    <String, dynamic>{
      'title': instance.title,
      'body': instance.body,
      'data': instance.data,
      'seen': instance.seen,
      'seenAt': instance.seenAt?.toIso8601String(),
      'receivedAt': instance.receivedAt?.toIso8601String(),
    };
