part of 'auth_bloc.dart';

/// {@template AuthState}
/// Base class for authentication states provided in an [AuthBloc]
/// {@endtemplate}
abstract class AuthState extends Equatable {
  /// {@macro AuthState}
  const AuthState();

  @override
  List<Object> get props => [];
}

/// [AuthBloc] State when Auth has not been initialized
class AuthUninitialized extends AuthState {}

/// {@template Authenticated}
/// [AuthBloc] State when the User has been authenticated
/// via [FirebaseAuth] or a third party [AuthProvider]
/// {@endtemplate}
class Authenticated extends AuthState {
  /// The [FirebaseUser] that has been authenticated
  final FirebaseUser firebaseUser;

  /// {@macro Authenticated}
  const Authenticated(this.firebaseUser);

  @override
  List<Object> get props => [firebaseUser];

  @override
  String toString() => 'Authenticated { firebaseUser: $firebaseUser }';
}

/// [AuthBloc] State when the User is not authenticated
class Unauthenticated extends AuthState {}
