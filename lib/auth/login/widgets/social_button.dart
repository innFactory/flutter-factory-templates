import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/login_bloc.dart';

class SocialLoginButton extends StatelessWidget {
  final Icon icon;
  final SocialLoginType socialLoginType;

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
