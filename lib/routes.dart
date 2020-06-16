import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'auth/auth.dart';
import 'config/remote_config_not_initialized.dart';
import 'views/home.dart';
import 'views/pages/todos/add_edit_todo.dart';
import 'views/splash.dart';

class Routes {
  // General
  static const String splash = '/';
  static const String home = '/home';

  // Todos
  static const String todos = '/todos';
  static const String addEditTodo = 'addEditTodo';

  // Config
  static const String remoteConfigNotInitialized = '/remoteConfigNotInitialized';

  // Auth
  static const String register = '/register';
  static const String login = '/login';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // General
      case home:
        return MaterialPageRoute(builder: (context) => HomeScreen(initialPage: settings.arguments));
      case splash:
        return MaterialPageRoute(builder: (context) => SplashScreen());

      // Todos
      case todos:
        return MaterialPageRoute(builder: (context) => HomeScreen(initialPage: 1));
      case addEditTodo:
        return MaterialPageRoute(builder: (context) => AddEditTodoScreen(todo: settings.arguments));

      // Config
      case remoteConfigNotInitialized:
        return MaterialPageRoute(builder: (context) => RemoteConfigNotInitialized());

      // Authentication
      case login:
        return MaterialPageRoute(builder: (context) => LoginScreen(registerRoute: register));
      case register:
        return MaterialPageRoute(builder: (context) => RegisterScreen());

      // Fallback / RouteNotFound
      default:
        return MaterialPageRoute(builder: (context) => Container());
    }
  }
}
