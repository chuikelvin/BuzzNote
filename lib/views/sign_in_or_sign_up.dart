import 'package:BuzzNote/views/homepage%20copy.dart';
import 'package:BuzzNote/views/sign_in.dart';
import 'package:BuzzNote/views/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';
import 'package:BuzzNote/controllers/usercontroller.dart';

class SignInOrUpPage extends StatefulWidget {
  bool isSkippable;
  bool isLocal;

  SignInOrUpPage({super.key, this.isSkippable = true, this.isLocal = false});

  @override
  State<SignInOrUpPage> createState() => _SignInOrUpPageState();
}

class _SignInOrUpPageState extends State<SignInOrUpPage> {
  late final Box startup;
  final userController = Get.find<UserController>();
  bool showSignInPage = true;

  @override
  void initState() {
    // TODO: implement initState
    print(widget.isLocal);
    super.initState();
    startup = Hive.box("startup");
    startup.isEmpty ? null : useValues();
  }

  useValues() {
    // setState(() {
    //   existLocal = true;
    // });
    for (var item in startup.values) {
      userController.updateDisplayName(item);
    }
  }

  void togglePages() {
    setState(() {
      showSignInPage = !showSignInPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignInPage && widget.isLocal == false) {
      return SignIn(
        isSkippable: widget.isSkippable,
        onTap: togglePages,
      );
    } else if (widget.isLocal) {
      return const MyHomePage();
    } else {
      return SignUP(
        isSkippable: widget.isSkippable,
        onTap: togglePages,
      );
    }
  }
}
