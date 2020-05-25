import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pedantic/pedantic.dart';
import 'package:template/auth/user_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final bool skipAuth;
  final UserRepository _userRepository;

  AuthBloc({
    this.skipAuth = false,
  }) : _userRepository = UserRepository();

  @override
  AuthState get initialState => Uninitialized();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is InitAuth) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthState> _mapAppStartedToState() async* {
    if (skipAuth) {
      yield Authenticated(null);
      return;
    }

    final firebaseUser = await _userRepository.currentUser;

    if (firebaseUser != null) {
      yield Authenticated(firebaseUser);
    } else {
      yield Unauthenticated();
    }
  }

  Stream<AuthState> _mapLoggedInToState() async* {
    yield Authenticated(await _userRepository.currentUser);
  }

  Stream<AuthState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    unawaited(_userRepository.signOut());
  }
}
