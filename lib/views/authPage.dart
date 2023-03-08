import 'package:BuzzNote/views/homepagelocal.dart';
import 'package:flutter/material.dart';
import 'package:BuzzNote/views/signinorsignup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:BuzzNote/views/homepage.dart';

import 'page3.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool toSkip = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.toSkip = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: toSkip
          ? MyHomePageLocal()
          : StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return const MyHomePage();
                } else {
                  // if (skip) {
                  //   return MyHomePage();
                  // } else {
                  return SignInOrRegisterPage(
                    skip: () {
                      // print(toSkip);
                      setState(() {
                        toSkip = !toSkip;
                      });
                    },
                  );
                  // }
                }
              }),
    );
  }
}
