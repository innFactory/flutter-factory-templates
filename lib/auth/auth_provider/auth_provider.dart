import 'package:firebase_auth/firebase_auth.dart';

/// {@template authprovider}
/// Base class for implementation of different auth providers.
/// {@endtemplate}
abstract class AuthProvider {
  /// The [FirebaseAuth] instance to use.
  final FirebaseAuth firebaseAuth;

  /// {@macro authprovider}
  AuthProvider() : firebaseAuth = FirebaseAuth.instance;

  /// SignIn Method template to be implemented by a subclass
  /// returning an [AuthResponse] from a third party [AuthProvider].
  Future<AuthResponse> signIn();

  /// SignOut method template to be implemented by a subclass
  /// to sign a user out of a third party [AuthProvider].
  Future<void> signOut();
}

/// {@template authresponse}
/// General return type of the [signIn] method by an [AuthProvider].
/// {@endtemplate}
class AuthResponse {
  /// The [FirebaseUser] authenticated by a third party [AuthProvider].
  final FirebaseUser user;

  /// Optional error message by an [AuthProvider].
  final String error;

  /// {@macro authresponse}
  AuthResponse({
    this.user,
    this.error,
  });
}
