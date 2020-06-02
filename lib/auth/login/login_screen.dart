import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/login_bloc.dart';
import 'widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  final String registerRoute;

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
