import 'package:flutter/material.dart';

import 'package:template/routes.dart';

class CreateAccountButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        'Create an Account',
      ),
      onPressed: () {
        Navigator.of(context).pushNamed(Routes.REGISTER.route);
      },
    );
  }
}
