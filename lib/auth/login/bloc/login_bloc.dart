import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import '../../auth_provider/auth_provider.dart';

import '../../user_repository.dart';
import '../../validators.dart';

part 'login_state.dart';
part 'login_event.dart';

/// Third party [AuthProvider] enum.
enum SocialLoginType {
  /// Google Auth button
  google,

  /// Apple Auth button
  apple,

  /// Facebook Auth button
  facebook
}

/// {@template loginbloc}
/// Handles the [LoginScreen] logic
/// {@endtemplate}
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository _userRepository;

  /// {@macro loginbloc}
  LoginBloc() : _userRepository = UserRepository();

  @override
  LoginState get initialState => LoginState.empty();

  @override
  Stream<Transition<LoginEvent, LoginState>> transformEvents(
    Stream<LoginEvent> events,
    TransitionFunction<LoginEvent, LoginState> transitionFn,
  ) {
    final nonDebounceStream = events.where((event) {
      return (event is! EmailChanged && event is! PasswordChanged);
    });

    final debounceStream = events.where((event) {
      return (event is EmailChanged || event is PasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));

    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is LoginWithSocialPressed) {
      yield* _mapLoginWithSocialPressedToState(event.socialLoginType);
    } else if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
        email: event.email,
        password: event.password,
      );
    }
  }

  Stream<LoginState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<LoginState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<LoginState> _mapLoginWithSocialPressedToState(
      SocialLoginType socialLoginType) async* {
    AuthResponse response;

    if (socialLoginType == SocialLoginType.google) {
      response = await _userRepository.signInWithGoogle();
    } else if (socialLoginType == SocialLoginType.facebook) {
      response = await _userRepository.signInWithFacebook();
    } else if (socialLoginType == SocialLoginType.apple) {
      response = await _userRepository.signInWithApple();
    }

    if (response.user != null) {
      yield LoginState.success();
    } else {
      yield LoginState.failure(response.error);
    }
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState({
    String email,
    String password,
  }) async* {
    yield LoginState.loading();

    try {
      await _userRepository.signInWithCredentials(
          email: email, password: password);
      yield LoginState.success();
    } on Exception catch (error) {
      yield LoginState.failure('Error: $error');
    }
  }
}
