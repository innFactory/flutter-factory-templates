import 'package:flutter/material.dart';

class CreateAccountButton extends StatelessWidget {
  final String registerRoute;

  const CreateAccountButton({Key key, @required this.registerRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text('Create an Account'),
      onPressed: () => Navigator.of(context).pushNamed(registerRoute),
    );
  }
}
