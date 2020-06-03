// ignore_for_file: avoid_classes_with_only_static_members
// ignore_for_file: public_member_api_docs
import 'package:flutter/widgets.dart';

import 'auth/auth.dart';
import 'views/home.dart';
import 'views/splash.dart';

class Routes {
  static _Route splash = _Route(
    route: '/',
    page: (context) => SplashScreen(),
  );
  static _Route home = _Route(
    route: '/home',
    page: (context) => HomeScreen(),
  );

  // Auth
  static _Route register = _Route(
    route: '/register',
    page: (context) => RegisterScreen(),
  );
  static _Route login = _Route(
    route: '/auth',
    page: (context) => LoginScreen(registerRoute: register.route),
  );

  static Map<String, Widget Function(BuildContext)> routes = {
    splash.route: splash.page,
    home.route: home.page,
    login.route: login.page,
    register.route: register.page,
  };
}

class _Route {
  final String route;
  final WidgetBuilder page;

  const _Route({
    @required this.route,
    @required this.page,
  });
}
