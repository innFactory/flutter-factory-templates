import 'package:flutter/widgets.dart';
import 'package:template/auth/login/login_screen.dart';
import 'package:template/auth/register/register_screen.dart';
import 'package:template/views/home.dart';
import 'package:template/views/splash.dart';

class Routes {
  static _Route SPLASH = _Route(
    route: '/',
    page: (context) => SplashScreen(),
  );
  static _Route HOME = _Route(
    route: '/home',
    page: (context) => HomeScreen(),
  );

  // Auth
  static _Route LOGIN = _Route(
    route: '/login',
    page: (context) => LoginScreen(),
  );
  static _Route REGISTER = _Route(
    route: '/register',
    page: (context) => RegisterScreen(),
  );

  static Map<String, Widget Function(BuildContext)> routes = <String, WidgetBuilder>{
    SPLASH.route: SPLASH.page,
    HOME.route: HOME.page,
    LOGIN.route: LOGIN.page,
    REGISTER.route: REGISTER.page,
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
