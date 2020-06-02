import 'package:flutter/widgets.dart';
import 'package:template/auth/auth.dart';
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
  static _Route REGISTER = _Route(
    route: '/register',
    page: (context) => RegisterScreen(),
  );
  static _Route LOGIN = _Route(
    route: '/auth',
    page: (context) => LoginScreen(registerRoute: REGISTER.route),
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
