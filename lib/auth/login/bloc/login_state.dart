part of 'login_bloc.dart';

/// {@template LoginState}
/// [LoginState] provided in a [LoginBloc]
/// {@endtemplate}
@immutable
class LoginState {
  /// Wether or not the entered email is valid
  final bool isEmailValid;

  /// Wether or not the entered password is valid
  final bool isPasswordValid;

  /// Wether or not the there is an async
  /// authentication operation is in progress
  final bool isSubmitting;

  /// Wether or not the Login was a success
  final bool isSuccess;

  /// Wether or not the Login was a failure
  final bool isFailure;

  /// Optional error message when the login was a failure
  final String error;

  /// Valid if both email and password are valid
  bool get isFormValid => isEmailValid && isPasswordValid;

  /// {@macro LoginState}
  LoginState({
    @required this.isEmailValid,
    @required this.isPasswordValid,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
    @required this.error,
  });

  /// Factory constructor for an empty [LoginState]
  factory LoginState.empty() {
    return LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      error: null,
    );
  }

  /// Factory constructor for a loading [LoginState]
  factory LoginState.loading() {
    return LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
      error: null,
    );
  }

  /// Factory constructor for a failed [LoginState] with an error
  factory LoginState.failure(String error) {
    return LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
      error: error,
    );
  }

  /// Factory constructor for a successfull [LoginState]
  factory LoginState.success() {
    return LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
      error: null,
    );
  }

  /// Update the [LoginState] with an optional replacement for
  /// [isEmailValid] and or [isPasswordValid]
  LoginState update({
    bool isEmailValid,
    bool isPasswordValid,
  }) {
    return copyWith(
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      error: error,
    );
  }

  /// Update the [LoginState] with optional overrides for every variable.
  LoginState copyWith({
    bool isEmailValid,
    bool isPasswordValid,
    bool isSubmitEnabled,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
    String error,
  }) {
    return LoginState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      error: error ?? this.error,
    );
  }

  @override
  String toString() {
    return '''LoginState {
      isEmailValid: $isEmailValid,
      isPasswordValid: $isPasswordValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
      error: $error,
    }''';
  }
}
