import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../user_repository.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// {@template authbloc}
/// Handles authentication logic with [FirebaseAuth] as well
/// as with third party [AuthProvider]'s
///
/// Optional [skipAuth] flag for debugging purposes.
/// {@endtemplate}
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  /// Debug flag to temporarily disable authentication
  final bool skipAuth;
  final UserRepository _userRepository;

  /// {@macro authbloc}
  AuthBloc({
    this.skipAuth = false,
  }) : _userRepository = UserRepository() {
    add(InitAuth());
  }

  @override
  AuthState get initialState => AuthUninitialized();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is InitAuth) {
      yield* _mapInitAuthToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthState> _mapInitAuthToState() async* {
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
    _userRepository.signOut();
  }
}
