import 'package:flutter/material.dart';
import 'package:template/push_notifications/db/push_notification_db.dart';

class NotificationList extends StatefulWidget {
  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PushNotification().select().toList(),
      builder: (BuildContext context, AsyncSnapshot<List<PushNotification>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(snapshot.data[index].title),
                subtitle: Text(snapshot.data[index].body),
              );
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
