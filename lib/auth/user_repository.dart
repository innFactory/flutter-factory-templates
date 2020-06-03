import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'auth_provider/apple_provider.dart';
import 'auth_provider/auth_provider.dart';
import 'auth_provider/facebook_provider.dart';
import 'auth_provider/google_provider.dart';

/// Repository with helper functions used in Authentication
class UserRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleAuth _googleAuth = GoogleAuth();
  final AppleAuth _appleAuth = AppleAuth();
  final FacebookAuth _facebookAuth = FacebookAuth();

  /// Check wether or not the User is currently authenticated
  Future<bool> isSignedIn() async => await currentUser != null;

  /// Get the current [FirebaseUser]
  Future<FirebaseUser> get currentUser => _firebaseAuth.currentUser();

  /// Sign in with [email] and [password]
  Future<AuthResponse> signInWithCredentials({
    @required String email,
    @required String password,
  }) async {
    try {
      final authResult = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      if (authResult.user != null) {
        return AuthResponse(user: authResult.user);
      } else {
        throw Exception();
      }
    } on PlatformException catch (error) {
      switch (error.code) {
        case 'ERROR_INVALID_EMAIL':
          return AuthResponse(error: 'Email-Adresse ungültig.');
        case 'ERROR_WRONG_PASSWORD':
          return AuthResponse(error: 'Das Passwort ist falsch.');
        case 'ERROR_USER_NOT_FOUND':
          return AuthResponse(
              error: 'Es existiert kein Account mit dieser Email-Adresse.');
        case 'ERROR_USER_DISABLED':
        case 'ERROR_TOO_MANY_REQUESTS':
        case 'ERROR_OPERATION_NOT_ALLOWED':
        default:
          return AuthResponse(error: 'Login fehlgeschlagen.');
      }
    }
  }

  /// Register an Account with [email] and [password]
  Future<AuthResponse> signUp({
    @required String email,
    @required String password,
  }) async {
    try {
      final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      return AuthResponse(user: authResult.user);
    } on PlatformException catch (error) {
      switch (error.code) {
        case 'ERROR_INVALID_EMAIL':
          return AuthResponse(error: 'Email-Adresse ungültig.');
        case 'ERROR_WEAK_PASSWORD':
          return AuthResponse(error: 'Das Passwort ist zu wach.');
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          return AuthResponse(
              error:
                  'Es existiert bereits ein Account mit dieser Email-Adresse.');
        default:
          return AuthResponse(error: 'Konto erstellung fehlgeschlagen.');
      }
    } on Exception catch (_) {
      return AuthResponse(error: 'Konto erstellung fehlgeschlagen.');
    }
  }

  /// Sign in with third party [GoogleAuth]
  Future<AuthResponse> signInWithGoogle() => _googleAuth.signIn();

  /// Sign in with third party [AppleAuth]
  Future<AuthResponse> signInWithApple() => _appleAuth.signIn();

  /// Sign in with third party [FacebookAuth]
  Future<AuthResponse> signInWithFacebook() => _facebookAuth.signIn();

  /// Sign out of [FirebaseAuth] and all third party [AuthProvider]'s
  Future<void> signOut() {
    return Future.wait([
      _firebaseAuth.signOut(),
      _appleAuth.signOut(),
      _googleAuth.signOut(),
      _facebookAuth.signOut(),
    ]);
  }
}
