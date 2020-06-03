import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import 'auth/auth.dart';
import 'config/config.dart';
import 'model/config.dart';
import 'push_notifications/push_notifications.dart';
import 'routes.dart';
import 'simple_bloc_delegate.dart';
import 'views/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure bloc delegate for logging
  BlocSupervisor.delegate = SimpleBlocDelegate();

  // Set logging level
  Logger.level = Level.debug;

  // Pass all uncaught errors to Crashlytics
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  // Initialize Locale
  Intl.defaultLocale = 'de_DE';
  await initializeDateFormatting('de_DE', null);

  // Run App in a zoned Crashlytics environment to catch errors
  runZoned(() {
    runApp(App());
  }, onError: Crashlytics.instance.recordError);
}

/// Entry widget for the Application
class App extends StatelessWidget {
  /// The NavigatorKey of the [MaterialApp]
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// App wide [Logger] instance to use for debugging
  static final Logger logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: false,
      printTime: true,
    ),
  );

  final FirebaseAnalytics _analytics = FirebaseAnalytics();
  final Config _defaultConfig = Config(
    welcome: 'Welcome',
  );
  final List<PushNotificationChannel> _pushNotificationChannels = [
    PushNotificationChannel('General', initiallySubscribedTo: true),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          // Will get initialized in the AuthListener since it has to wait
          // for the ConfigBloc to be done initializing.
          create: (context) => AuthBloc(skipAuth: true),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => ConfigBloc<Config>(
            logger: logger,
            defaultConfig: _defaultConfig,
            configFromJson: (json) => Config.fromJson(json),
            configToJson: (config) => config.toJson(),
            configMerge: (configA, configB) => configA.merge(configB),
            remoteConfigEnabled: true,
            remoteConfigToConfig: (remoteConfigMap) => Config(
              welcome:
                  json.decode(remoteConfigMap['welcome'].asString())['value'],
            ),
          )..add(InitConfig()),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => PushNotificationsBloc(
            logger: logger,
            channels: _pushNotificationChannels,
          )..add(InitPushNotifications()),
        ),
      ],
      child: ConfigBuilder<Config>(
        builder: (context, config) {
          return AuthListener(
            navigatorKey: navigatorKey,
            homeRoute: Routes.home.route,
            loginRoute: Routes.login.route,
            splashRoute: Routes.splash.route,
            child: MaterialApp(
              title: 'App',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              navigatorKey: navigatorKey,
              initialRoute: Routes.splash.route,
              routes: Routes.routes,
              navigatorObservers: [
                FirebaseAnalyticsObserver(analytics: _analytics),
                BotToastNavigatorObserver(),
              ],
              builder: BotToastInit(),
            ),
          );
        },
        loading: (context) => SplashScreen(),
      ),
    );
  }
}
