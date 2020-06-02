import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/config_bloc.dart';

typedef ConfigLoadedBuilder<T> = Widget Function(BuildContext context, T config);

class ConfigBuilder<T> extends StatelessWidget {
  final ConfigLoadedBuilder<T> builder;
  final WidgetBuilder loading;

  const ConfigBuilder({
    Key key,
    @required this.builder,
    @required this.loading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfigBloc<T>, ConfigState>(
      builder: (BuildContext context, ConfigState state) {
        // Check if the config is loaded and remote config has been initialized at least once
        if (state is ConfigLoaded && state.remoteConfigInitialized) {
          return builder(context, state.config);
        } else {
          return loading(context);
        }
      },
    );
  }
}
