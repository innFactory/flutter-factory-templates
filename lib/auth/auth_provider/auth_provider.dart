import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthProvider {
  final FirebaseAuth firebaseAuth;

  AuthProvider() : firebaseAuth = FirebaseAuth.instance;

  Future<AuthResponse> signIn();
  Future<void> signOut();
}

class AuthResponse {
  final FirebaseUser user;
  final String error;

  AuthResponse({
    this.user,
    this.error,
  });
}
