import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/auth_bloc.dart';

class AuthListener extends StatelessWidget {
  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;
  final String homeRoute;
  final String loginRoute;
  final String splashRoute;

  const AuthListener({
    Key key,
    @required this.child,
    @required this.navigatorKey,
    @required this.homeRoute,
    @required this.loginRoute,
    @required this.splashRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    if (authBloc.state is AuthUninitialized) authBloc.add(InitAuth());

    return BlocListener<AuthBloc, AuthState>(
      listener: (BuildContext context, AuthState authState) {
        if (authState is Authenticated) {
          navigatorKey.currentState.pushReplacementNamed(homeRoute);
        } else if (authState is Unauthenticated) {
          navigatorKey.currentState.pushReplacementNamed(loginRoute);
        } else {
          navigatorKey.currentState.pushReplacementNamed(splashRoute);
        }
      },
      child: child,
    );
  }
}
