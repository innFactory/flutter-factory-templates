import 'package:flutter/material.dart';

import '../bloc/login_bloc.dart';

/// {@template SocialLoginButton}
/// Simple [IconButton] handling signing in
/// with a third party [AuthProvider]
/// {@endtemplate}
class SocialLoginButton extends StatelessWidget {
  /// The Icon of the [AuthProvider] to show
  final Icon icon;

  /// The Type of third party [AuthProvider]
  final SocialLoginType socialLoginType;

  /// {@macro SocialLoginButton}
  const SocialLoginButton({
    Key key,
    @required this.icon,
    @required this.socialLoginType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      visualDensity: VisualDensity.compact,
      icon: icon,
      onPressed: () {
        BlocProvider.of<LoginBloc>(context).add(
          LoginWithSocialPressed(socialLoginType: socialLoginType),
        );
      },
    );
  }
}
