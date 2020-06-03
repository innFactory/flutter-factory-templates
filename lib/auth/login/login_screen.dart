import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/login_bloc.dart';
import 'widgets/login_form.dart';

/// {@template LoginState}
/// Shows a [LoginForm] with options to login via Email & Password as well as
/// available third party [AuthProvider]'s
/// {@endtemplate}
class LoginScreen extends StatelessWidget {
  /// The route to the [RegisterScreen]
  final String registerRoute;

  /// {@macro LoginScreen}
  const LoginScreen({
    Key key,
    @required this.registerRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(),
        child: LoginForm(
          registerRoute: registerRoute,
        ),
      ),
    );
  }
}
