import 'package:flutter/material.dart';

import '../../config/config.dart';
import '../../push_notifications/push_notifications.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        children: <Widget>[
          BlocBuilder<PushNotificationsBloc, PushNotificationsState>(builder: (context, state) {
            if (state is PushNotificationsLoaded) {
              return ListTile(
                leading: Icon(state.channels[0].isSubscribed ? Icons.notifications_active : Icons.notifications),
                title: Text('PushNotificationChannel "${state.channels[0].identifier}"'),
                subtitle: Text('isSubscribed: ${state.channels[0].isSubscribed}'),
                onTap: () => BlocProvider.of<PushNotificationsBloc>(context)
                    .add(TogglePushNotificationChannel(state.channels[0])),
              );
            } else {
              return ListTile(
                title: Text('PushNotificationChannel "loading..."'),
                subtitle: Text('isSubscribed: loading...'),
              );
            }
          }),
        ],
      ),
    );
  }
}
