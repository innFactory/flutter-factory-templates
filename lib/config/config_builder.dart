import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/config_bloc.dart';

typedef ConfigLoadedBuilder<T> = Widget Function(
    BuildContext context, T config);

/// {@template ConfigBuilder}
/// Helper class to easily implement a loading state while
/// the [ConfigBloc] is initializing.
/// {@endtemplate}
class ConfigBuilder<T> extends StatelessWidget {
  /// The builder method that gets rendered when the Config has been loaded
  /// and [RemoteConfig] has been initialized at least once.
  final ConfigLoadedBuilder<T> builder;

  /// The builder method that gets rendered when Config is still loading.
  final WidgetBuilder loading;

  /// {@macro ConfigBuilder}
  const ConfigBuilder({
    Key key,
    @required this.builder,
    @required this.loading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfigBloc<T>, ConfigState>(
      builder: (context, state) {
        if (state is ConfigLoaded && state.remoteConfigInitialized) {
          return builder(context, state.config);
        } else {
          return loading(context);
        }
      },
    );
  }
}
