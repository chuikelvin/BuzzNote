import 'package:BuzzNote/views/sign_in.dart';
import 'package:BuzzNote/views/sign_up.dart';
import 'package:flutter/material.dart';

class SignInOrUpPage extends StatefulWidget {
  const SignInOrUpPage({super.key});

  @override
  State<SignInOrUpPage> createState() => _SignInOrUpPageState();
}

class _SignInOrUpPageState extends State<SignInOrUpPage> {
  bool showSignInPage = true;

  void togglePages() {
    setState(() {
      showSignInPage = !showSignInPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignInPage) {
      return SignIn(
        onTap: togglePages,
      );
    } else {
      return SignUP(
        onTap: togglePages,
      );
    }
  }
}
