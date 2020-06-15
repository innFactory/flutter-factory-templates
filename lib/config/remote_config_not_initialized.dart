import 'package:flutter/material.dart';

import 'config.dart';

class RemoteConfigNotInitialized extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
          child: Text(
            'Zur ersten Initialisierung der App wird eine Internetverbindung benötigt. Bitte aktiviere deine '
            'Datenverbindung oder verbinde dich mit einem WLAN.',
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
        IconButton(
          icon: Icon(Icons.refresh),
          color: Colors.red,
          onPressed: () => BlocProvider.of<ConfigBloc>(context).add(ReloadRemoteConfig()),
        )
      ],
    );
  }
}
