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
import 'package:template/auth/auth.dart';
import 'package:template/config/config.dart';
import 'package:template/model/config.dart';
import 'package:template/push_notifications/push_notifications.dart';
import 'package:template/routes.dart';
import 'package:template/simple_bloc_delegate.dart';
import 'package:template/views/splash.dart';

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
          create: (BuildContext context) => AuthBloc(skipAuth: true)..add(InitAuth()),
          lazy: true,
        ),
        BlocProvider(
          create: (BuildContext context) => PushNotificationsBloc(
            channels: _pushNotificationChannels,
          )..add(InitPushNotifications()),
        ),
        BlocProvider(
          create: (BuildContext context) => ConfigBloc<Config>(
            defaultConfig: _defaultConfig,
            configFromJson: (json) => Config.fromJson(json),
            configToJson: (config) => config.toJson(),
            configMerge: (configA, configB) => configA.merge(configB),
            remoteConfigEnabled: true,
            remoteConfigToConfig: (remoteConfigMap) => Config(
              welcome: json.decode(remoteConfigMap['welcome'].asString())['value'],
            ),
          )..add(InitConfig()),
        ),
      ],
      child: ConfigBuilder<Config>(
        builder: (BuildContext context, Config config) {
          return AuthListener(
            navigatorKey: App.navigatorKey,
            homeRoute: Routes.HOME.route,
            loginRoute: Routes.LOGIN.route,
            splashRoute: Routes.SPLASH.route,
            child: MaterialApp(
              title: 'App',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              navigatorKey: App.navigatorKey,
              initialRoute: Routes.SPLASH.route,
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
