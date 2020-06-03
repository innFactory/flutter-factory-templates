import 'package:flutter/material.dart';

/// {@template CreateAccountButton}
/// Simple button handling navigation to a
/// provided Route to the [RegisterScreen]
/// {@endtemplate}
class CreateAccountButton extends StatelessWidget {
  /// The route to the [RegisterScreen]
  final String registerRoute;

  /// {@macro CreateAccountButton}
  const CreateAccountButton({Key key, @required this.registerRoute})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text('Create an Account'),
      onPressed: () => Navigator.of(context).pushNamed(registerRoute),
    );
  }
}
