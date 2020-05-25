part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class Uninitialized extends AuthState {}

class Authenticated extends AuthState {
  final FirebaseUser firebaseUser;

  const Authenticated(this.firebaseUser);

  @override
  List<Object> get props => [firebaseUser];

  @override
  String toString() => 'Authenticated { firebaseUser: $firebaseUser }';
}

class Unauthenticated extends AuthState {}
