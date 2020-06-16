part of 'auth_bloc.dart';

/// {@template AuthEvent}
/// Base class for authentication events handled in an [AuthBloc]
/// {@endtemplate}
abstract class AuthEvent extends Equatable {
  /// {@macro AuthEvent}
  const AuthEvent();

  @override
  List<Object> get props => [];
}

/// Event fired when the App starts to initialize Authentication
class InitAuth extends AuthEvent {}

/// Event fired when the user logged in
class LoggedIn extends AuthEvent {}

/// Event fired when user logged out
class LoggedOut extends AuthEvent {}
