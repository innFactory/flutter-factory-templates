import 'package:flutter/material.dart';

import 'bloc/config_bloc.dart';

/// {@template ConfigBuilder}
/// Requires a [BlocProvider] providing a [ConfigBloc] further up in the widget tree. Listens to changes
/// in the [ConfigBloc] and updates the [NavigatorState] accordingly.
///
/// If the [ConfigState] is [ConfigLoaded] and the remoteC
/// {@endtemplate}
class ConfigListener<T> extends StatelessWidget {
  /// The widget which will be rendered as a descendant of the [ConfigListener].
  final Widget child;

  /// The [GlobalKey<NavigatorState>] to use for navigation.
  final GlobalKey<NavigatorState> navigatorKey;

  /// The route to go to when the config has been successfully loaded.
  final String configLoadedRoute;

  /// The route to go to when the [RemoteConfig] has not been intialized
  final String remoteConfigNotInitializedRoute;

  /// The route to go to while the config is being loaded.
  final String loadingRoute;

  /// {@macro ConfigBuilder}
  const ConfigListener({
    Key key,
    @required this.child,
    @required this.navigatorKey,
    @required this.configLoadedRoute,
    @required this.remoteConfigNotInitializedRoute,
    @required this.loadingRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConfigBloc<T>, ConfigState>(
      listener: (context, configState) {
        if (configState is ConfigLoaded) {
          navigatorKey.currentState.pushNamedAndRemoveUntil(configLoadedRoute, (_) => false);
        } else if (configState is RemoteConfigNotInitialized) {
          navigatorKey.currentState.pushNamedAndRemoveUntil(remoteConfigNotInitializedRoute, (_) => false);
        } else {
          navigatorKey.currentState.pushNamedAndRemoveUntil(loadingRoute, (_) => false);
        }
      },
      child: child,
    );
  }
}
