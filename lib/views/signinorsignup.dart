import 'package:BuzzNote/views/signIn.dart';
import 'package:BuzzNote/views/signUp.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SignInOrRegisterPage extends StatefulWidget {
  final Function() skip;

  SignInOrRegisterPage({super.key, required this.skip});

  @override
  State<SignInOrRegisterPage> createState() => _SignInOrRegisterPageState();
}

class _SignInOrRegisterPageState extends State<SignInOrRegisterPage> {
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
        skip: widget.skip,
      );
    } else {
      return SignUP(
        onTap: togglePages,
        skip: widget.skip,
      );
    }
  }
}
