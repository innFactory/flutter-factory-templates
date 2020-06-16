import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_provider.dart';

/// Provides googleSignIn capabilities.
class GoogleAuth extends AuthProvider {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<AuthResponse> signIn() async {
    try {
      final googleSignInAccount = await _googleSignIn.signIn();
      final googleAuth = await googleSignInAccount.authentication;
      final authCredential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final authResult =
          await firebaseAuth.signInWithCredential(authCredential);

      return AuthResponse(user: authResult.user);
    } on PlatformException catch (error) {
      switch (error.code) {
        default:
          return AuthResponse(error: 'Google Login fehlgeschlagen.');
      }
    } on Exception catch (_) {
      return AuthResponse(error: 'Google Login fehlgeschlagen.');
    }
  }

  @override
  Future<void> signOut() => _googleSignIn.signOut();
}
