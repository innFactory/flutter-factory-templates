import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'auth_provider/apple_provider.dart';
import 'auth_provider/auth_provider.dart';
import 'auth_provider/facebook_provider.dart';
import 'auth_provider/google_provider.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleAuth _googleAuth;
  final AppleAuth _appleAuth;
  final FacebookAuth _facebookAuth;

  UserRepository()
      : _firebaseAuth = FirebaseAuth.instance,
        _googleAuth = GoogleAuth(),
        _appleAuth = AppleAuth(),
        _facebookAuth = FacebookAuth();

  Future<bool> isSignedIn() async => await currentUser != null;

  Future<FirebaseUser> get currentUser => _firebaseAuth.currentUser();

  Future<AuthResponse> signInWithCredentials({
    @required String email,
    @required String password,
  }) async {
    try {
      final authResult = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      if (authResult.user != null) {
        return AuthResponse(user: authResult.user);
      } else {
        throw Exception();
      }
    } on PlatformException catch (error) {
      // ERROR_INVALID_EMAIL - If the [email] address is malformed.
      // ERROR_WRONG_PASSWORD - If the [password] is wrong.
      // ERROR_USER_NOT_FOUND - If there is no user corresponding to the given [email] address, or if the user has been deleted.
      // ERROR_USER_DISABLED - If the user has been disabled (for example, in the Firebase console)
      // ERROR_TOO_MANY_REQUESTS - If there was too many attempts to sign in as this user.
      // ERROR_OPERATION_NOT_ALLOWED - Indicates that Email & Password accounts are not enabled.

      switch (error.code) {
        case 'ERROR_INVALID_EMAIL':
          return AuthResponse(error: 'Email-Adresse ungültig.');
        case 'ERROR_WRONG_PASSWORD':
          return AuthResponse(error: 'Das Passwort ist falsch.');
        case 'ERROR_USER_NOT_FOUND':
          return AuthResponse(error: 'Es existiert kein Account mit dieser Email-Adresse.');
        case 'ERROR_USER_DISABLED':
        case 'ERROR_TOO_MANY_REQUESTS':
        case 'ERROR_OPERATION_NOT_ALLOWED':
        default:
          return AuthResponse(error: 'Login fehlgeschlagen.');
      }
    }
  }

  Future<AuthResponse> signUp({
    @required String email,
    @required String password,
  }) async {
    try {
      final authResult = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

      return AuthResponse(user: authResult.user);
    } on PlatformException catch (error) {
      // ERROR_WEAK_PASSWORD - If the password is not strong enough.
      // ERROR_INVALID_EMAIL - If the email address is malformed.
      // ERROR_EMAIL_ALREADY_IN_USE - If the email is already in use by a different account.

      switch (error.code) {
        case 'ERROR_INVALID_EMAIL':
          return AuthResponse(error: 'Email-Adresse ungültig.');
        case 'ERROR_WEAK_PASSWORD':
          return AuthResponse(error: 'Das Passwort ist zu wach.');
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          return AuthResponse(error: 'Es existiert bereits ein Account mit dieser Email-Adresse.');
        default:
          return AuthResponse(error: 'Konto erstellung fehlgeschlagen.');
      }
    } catch (error) {
      return AuthResponse(error: 'Konto erstellung fehlgeschlagen.');
    }
  }

  Future<AuthResponse> signInWithGoogle() => _googleAuth.signIn();
  Future<AuthResponse> signInWithApple() => _appleAuth.signIn();
  Future<AuthResponse> signInWithFacebook() => _facebookAuth.signIn();

  Future<void> signOut() {
    return Future.wait([
      _firebaseAuth.signOut(),
      _appleAuth.signOut(),
      _googleAuth.signOut(),
      _facebookAuth.signOut(),
    ]);
  }
}
