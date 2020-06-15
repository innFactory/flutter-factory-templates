import 'package:flutter/material.dart';

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
  final String authenticatedRoute;

  /// The route to the login screen.
  final String loginRoute;

  /// The route to while checking authentication.
  final String loadingRoute;

  /// {@macro authlistener}
  const AuthListener({
    Key key,
    @required this.child,
    @required this.navigatorKey,
    @required this.authenticatedRoute,
    @required this.loginRoute,
    @required this.loadingRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, authState) {
        if (authState is Authenticated) {
          navigatorKey.currentState.pushNamedAndRemoveUntil(authenticatedRoute, (_) => false);
        } else if (authState is Unauthenticated) {
          navigatorKey.currentState.pushNamedAndRemoveUntil(loginRoute, (_) => false);
        } else {
          navigatorKey.currentState.pushNamedAndRemoveUntil(loadingRoute, (_) => false);
        }
      },
      child: child,
    );
  }
}
