import 'package:flutter/material.dart';

/// {@template LoginButton}
/// Simple styled [RaisedButton] with a [VoidCallback]
/// {@endtemplate}
class LoginButton extends StatelessWidget {
  final VoidCallback _onPressed;

  /// {@macro LoginButton}
  LoginButton({Key key, VoidCallback onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      onPressed: _onPressed,
      child: Text('Login'),
    );
  }
}
