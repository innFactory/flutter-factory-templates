import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_provider.dart';

class GoogleAuth extends AuthProvider {
  final GoogleSignIn _googleSignIn;

  GoogleAuth()
      : _googleSignIn = GoogleSignIn(),
        super();

  @override
  Future<AuthResponse> signIn() async {
    try {
      final googleSignInAccount = await _googleSignIn.signIn();
      final googleAuth = await googleSignInAccount.authentication;
      final authCredential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final authResult = await firebaseAuth.signInWithCredential(authCredential);

      return AuthResponse(user: authResult.user);
    } on PlatformException catch (error) {
      // ERROR_INVALID_CREDENTIAL - If the credential data is malformed or has expired.
      // ERROR_USER_DISABLED - If the user has been disabled (for example, in the Firebase console)
      // ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL - If there already exists an account with the email address asserted by Google. Resolve this case by calling [fetchSignInMethodsForEmail] and then asking the user to sign in using one of them. This error will only be thrown if the 'One account per email address' setting is enabled in the Firebase console (recommended).
      // ERROR_OPERATION_NOT_ALLOWED - Indicates that Google accounts are not enabled.
      // ERROR_INVALID_ACTION_CODE - If the action code in the link is malformed, expired, or has already been used. This can only occur when using [EmailAuthProvider.getCredentialWithLink] to obtain the credential.

      switch (error.code) {
        default:
          return AuthResponse(error: 'Google Login fehlgeschlagen.');
      }
    } catch (error) {
      return AuthResponse(error: 'Google Login fehlgeschlagen.');
    }
  }

  @override
  Future<void> signOut() => _googleSignIn.signOut();
}
