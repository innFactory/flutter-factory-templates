import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

import 'auth_provider.dart';

class FacebookAuth extends AuthProvider {
  final FacebookLogin _facebookLogin;

  FacebookAuth()
      : _facebookLogin = FacebookLogin(),
        super();

  @override
  Future<AuthResponse> signIn() async {
    try {
      final facebookLoginResult = await _facebookLogin.logIn(['email']);

      if (facebookLoginResult.status == FacebookLoginStatus.loggedIn) {
        final authCredential = FacebookAuthProvider.getCredential(accessToken: facebookLoginResult.accessToken.token);
        final authResult = await firebaseAuth.signInWithCredential(authCredential);

        return AuthResponse(user: authResult.user);
      } else if (facebookLoginResult.status == FacebookLoginStatus.cancelledByUser) {
        return AuthResponse(error: 'Facebook Login abgebrochen.');
      } else {
        return AuthResponse(error: 'Facebook Login fehlgeschlagen.');
      }
    } catch (error) {
      return AuthResponse(error: 'Login fehlgeschlagen.');
    }
  }

  @override
  Future<void> signOut() => _facebookLogin.logOut();
}
