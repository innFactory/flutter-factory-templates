part of 'login_bloc.dart';

/// {@template LoginEvent}
/// Base class for login events handled in a [LoginBloc].
/// {@endtemplate}
abstract class LoginEvent extends Equatable {
  /// {@macro LoginEvent}
  const LoginEvent();

  @override
  List<Object> get props => [];
}

/// {@template EmailChanged}
/// [LoginBloc] event fired when the entered email address has changed.
/// {@endtemplate}
class EmailChanged extends LoginEvent {
  /// The entered email address
  final String email;

  /// {@macro EmailChanged}
  const EmailChanged({@required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged { email: $email }';
}

/// {@template PasswordChanged}
/// [LoginBloc] event fired when the entered password has changed.
/// {@endtemplate}
class PasswordChanged extends LoginEvent {
  /// The entered password
  final String password;

  /// {@macro PasswordChanged}
  const PasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() =>
      'PasswordChanged { password: ${Validators.obscurePassword(password)} }';
}

/// {@template LoginWithSocialPressed}
/// [LoginBloc] event fired when the user has pressed a [SocialButton].
/// {@endtemplate}
class LoginWithSocialPressed extends LoginEvent {
  /// The type of the [SocialButton] corresponding
  /// to a third party [AuthProvider]
  final SocialLoginType socialLoginType;

  /// {@macro LoginWithSocialPressed}
  const LoginWithSocialPressed({@required this.socialLoginType});
  @override
  List<Object> get props => [socialLoginType];

  @override
  String toString() =>
      'LoginWithSocialPressed { socialLoginType: $socialLoginType }';
}

/// {@template LoginWithCredentialsPressed}
/// [LoginBloc] event fired when the user has pressed the [LoginButton].
/// {@endtemplate}
class LoginWithCredentialsPressed extends LoginEvent {
  /// The entered email address
  final String email;

  /// The entered password
  final String password;

  /// {@macro LoginWithCredentialsPressed}
  const LoginWithCredentialsPressed({
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [email, password];

  @override
  String toString() => '''LoginWithCredentialsPressed {
    email: $email,
    password: ${Validators.obscurePassword(password)}
  }''';
}
