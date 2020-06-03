import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/auth_bloc.dart';

/// {@template authlistener}
/// Requires a [BlocProvider] providing an [AuthBloc]
/// further up in the widget tree. Listens to changes
/// in the [AuthBloc] and updates the [NavigatorState]
/// accordingly.
/// {@endtemplate}
class AuthListener extends StatelessWidget {
  /// The widget which will be rendered as a descendant of the [AuthListener].
  final Widget child;

  /// The [GlobalKey<NavigatorState>] to use for navigation.
  final GlobalKey<NavigatorState> navigatorKey;

  /// The route to go to when authentication has been successfull.
  final String homeRoute;

  /// The route to the login screen.
  final String loginRoute;

  /// The route to the splash screen while checking authentication.
  final String splashRoute;

  /// {@macro authlistener}
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
      listener: (context, authState) {
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
