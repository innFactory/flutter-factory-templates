import 'package:flutter_bloc/flutter_bloc.dart';

import 'main.dart';

/// Simple Bloc Delegate with logging
class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    App.logger.v('${bloc.runtimeType}: $event');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    App.logger.d('''
--- ${bloc.runtimeType} Transition ---
currentState: ${transition.currentState}
event: ${transition.event}
nextState: ${transition.nextState}''');
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    App.logger.e('Error in ${bloc.runtimeType}', error, stacktrace);
  }
}
