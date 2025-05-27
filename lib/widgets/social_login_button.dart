import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: Colors.white,
      child: Image.asset(
        'assets/images/google_logo.png',
        width: 30,
        height: 30,
      ),
    );
  }
}
