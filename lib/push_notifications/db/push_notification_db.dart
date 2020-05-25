import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';
import 'package:http/http.dart' as http;

part 'push_notification_db.g.dart';

const tableNotifications = SqfEntityTable(
  tableName: 'push_notification',
  modelName: 'PushNotification',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: true,
  fields: [
    SqfEntityField('title', DbType.text),
    SqfEntityField('body', DbType.text),
    SqfEntityField('data', DbType.text),
    SqfEntityField('seen', DbType.bool, defaultValue: false),
    SqfEntityField('seenAt', DbType.datetime),
    SqfEntityField('receivedAt', DbType.datetime),
  ],
);

@SqfEntityBuilder(pushNotificationDb)
const pushNotificationDb = SqfEntityModel(
  modelName: 'PushNotificationDb',
  databaseName: 'notifications.db',
  databaseTables: [tableNotifications],
);
