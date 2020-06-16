import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'auth_provider.dart';

/// Provides apple sign in capabilities.
class AppleAuth extends AuthProvider {
  @override
  Future<AuthResponse> signIn() async {
    try {
      final credentials = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final oAuthProvider = OAuthProvider(providerId: 'apple.com');
      final credential = oAuthProvider.getCredential(
        idToken: credentials.identityToken,
        accessToken: credentials.authorizationCode,
      );
      final result = await firebaseAuth.signInWithCredential(credential);

      return AuthResponse(user: result.user);
    } on PlatformException catch (error) {
      switch (error.code) {
        default:
          return AuthResponse(error: 'Apple Login fehlgeschlagen.');
      }
    } on Exception catch (_) {
      return AuthResponse(error: 'Apple Login fehlgeschlagen.');
    }
  }

  @override
  Future signOut() async => Future(() => true);
}
