part of 'register_bloc.dart';

/// {@template RegisterEvent}
/// Base class for register events handled in a [RegisterBloc].
/// {@endtemplate}
abstract class RegisterEvent extends Equatable {
  /// {@macro RegisterEvent}
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

/// {@template EmailChanged}
/// [RegisterBloc] event fired when the entered email address has changed.
/// {@endtemplate}
class EmailChanged extends RegisterEvent {
  /// The entered email address
  final String email;

  /// {@macro EmailChanged}
  const EmailChanged({@required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged { email :$email }';
}

/// {@template PasswordChanged}
/// [RegisterBloc] event fired when the entered password has changed.
/// {@endtemplate}
class PasswordChanged extends RegisterEvent {
  /// The entered password
  final String password;

  /// {@macro PasswordChanged}
  const PasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'PasswordChanged { password: $password }';
}

/// {@template Submitted}
/// [RegisterBloc] event fired when the user has pressed a [RegisterButton].
/// {@endtemplate}
class Submitted extends RegisterEvent {
  /// The entered email
  final String email;

  /// The entered password
  final String password;

  /// {@macro Submitted}
  const Submitted({
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [email, password];

  @override
  String toString() {
    return '''Submitted {
      email: $email,
      password: $password
    }''';
  }
}
