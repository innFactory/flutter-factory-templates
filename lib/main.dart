import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:template/auth/bloc/auth_bloc.dart';
import 'package:template/blocs/settings/settings_bloc.dart';
import 'package:template/model/settings.dart';
import 'package:template/push_notifications/model/push_notification_channel.dart';
import 'package:template/push_notifications/push_notification_handler.dart';
import 'package:template/routes.dart';
import 'package:template/views/splash.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  BlocSupervisor.delegate = SimpleBlocDelegate();
  // Pass all uncaught errors to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  // Initialize Locale
  Intl.defaultLocale = 'de_DE';
  await initializeDateFormatting('de_DE', null);

  runZoned(() {
    runApp(App());
  }, onError: Crashlytics.instance.recordError);
}

class App extends StatefulWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final FirebaseAnalytics analytics = FirebaseAnalytics();
  final PushNotificationHandler _pushNotificationRepository = PushNotificationHandler();

  @override
  void initState() {
    super.initState();
    _pushNotificationRepository.initialize([
      PushNotificationChannel('General', initiallySubscribedTo: true),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => AuthBloc(skipAuth: true)..add(InitAuth())),
        BlocProvider(create: (BuildContext context) => SettingsBloc()..add(InitSettings())),
      ],
      child: BlocBuilder<SettingsBloc, Settings>(
        builder: (BuildContext context, Settings settings) {
          // Check if the config is loaded and remote config has been initialized at least once
          if ((settings?.initialized ?? false) && (settings?.remoteConfigInitialized ?? false)) {
            return BlocListener<AuthBloc, AuthState>(
              listener: (BuildContext context, AuthState authState) {
                if (authState is Authenticated) {
                  App.navigatorKey.currentState.pushReplacementNamed(Routes.HOME.route);
                } else if (authState is Unauthenticated) {
                  App.navigatorKey.currentState.pushReplacementNamed(Routes.LOGIN.route);
                } else {
                  App.navigatorKey.currentState.pushReplacementNamed(Routes.SPLASH.route);
                }
              },
              child: MaterialApp(
                title: 'App',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                navigatorKey: App.navigatorKey,
                initialRoute: Routes.SPLASH.route,
                routes: Routes.routes,
                navigatorObservers: [
                  FirebaseAnalyticsObserver(analytics: analytics),
                  BotToastNavigatorObserver(),
                ],
                builder: BotToastInit(),
              ),
            );
          } else {
            return SplashScreen();
          }
        },
      ),
    );
  }
}
