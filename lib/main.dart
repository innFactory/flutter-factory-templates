import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import 'auth/auth.dart';
import 'bloc/todos/todos_bloc.dart';
import 'config/config.dart';
import 'data/model/config.dart';
import 'push_notifications/push_notifications.dart';
import 'routes.dart';
import 'simple_bloc_delegate.dart';

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
          lazy: false,
          create: (context) => ConfigBloc<Config>(
            logger: logger,
            defaultConfig: _defaultConfig,
            configFromJson: (json) => Config.fromJson(json),
            configToJson: (config) => config.toJson(),
            configMerge: (configA, configB) => configA.merge(configB),
            remoteConfigEnabled: true,
          ),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => PushNotificationsBloc(
            logger: logger,
            channels: _pushNotificationChannels,
            navigatorKey: App.navigatorKey,
          )..add(InitPushNotifications()),
        ),
      ],
      child: ConfigListener<Config>(
        navigatorKey: navigatorKey,
        configLoadedRoute: Routes.home,
        remoteConfigNotInitializedRoute: Routes.remoteConfigNotInitialized,
        loadingRoute: Routes.splash,
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => AuthBloc(skipAuth: true)),
            BlocProvider(create: (context) => TodosBloc()),
          ],
          child: AuthListener(
            navigatorKey: navigatorKey,
            authenticatedRoute: Routes.home,
            loginRoute: Routes.login,
            loadingRoute: Routes.splash,
            child: MaterialApp(
              title: 'App',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              navigatorKey: navigatorKey,
              initialRoute: Routes.splash,
              onGenerateRoute: Routes.onGenerateRoute,
              navigatorObservers: [
                FirebaseAnalyticsObserver(analytics: _analytics),
                BotToastNavigatorObserver(),
              ],
              builder: BotToastInit(),
            ),
          ),
        ),
      ),
    );
  }
}
