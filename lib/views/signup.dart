import 'dart:async';

import 'package:BuzzNote/utilites/myButton.dart';
import 'package:BuzzNote/utilites/skipButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:BuzzNote/utilites/mytextfield.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUP extends StatefulWidget {
  const SignUP({super.key});

  @override
  State<SignUP> createState() => _SignUPState();
}

class _SignUPState extends State<SignUP> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  bool isChecked = false;

  Color enabledBorder = Colors.grey;

  Color errorColor = Colors.grey;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future submit() async {
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
    if (emailController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty) {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      )
          .then((newUser) {
        newUser.user?.updateDisplayName(
          firstNameController.text.trim() +
              " " +
              lastNameController.text.trim(),
        );
      });
    } else {
      setState(() {
        errorColor = Colors.red;
      });

      Timer(Duration(milliseconds: 2500), () {
        setState(() {
          errorColor = enabledBorder;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      // appBar: AppBar(backgroundColor: Colors.transparent),
      body: SafeArea(
          child: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 65,
            ),
            // Image.asset('assets/icon/feature_graphic.png'),
            Image.asset(
              'assets/icon/splash.png',
              scale: 1.6,
            ),
            // Text(
            //   'BuzzNote',
            //   textAlign: TextAlign.start,
            //   style: TextStyle(
            //     letterSpacing: 4,
            //     color: Colors.white,
            //     fontSize: 25,
            //   ),
            // ),
            SizedBox(
              height: 28,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: MyTextField(
                      padding: 0,
                      autofocus: false,
                      controller: firstNameController,
                      hintText: "first name",
                      obscureText: false,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: MyTextField(
                      padding: 0,
                      autofocus: false,
                      controller: lastNameController,
                      hintText: "last name",
                      obscureText: false,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            MyTextField(
              autofocus: false,
              controller: emailController,
              hintText: "Enter Email Address",
              obscureText: false,
              enabledBorder: emailController.text.trim().isEmpty
                  ? errorColor
                  : enabledBorder,
            ),
            SizedBox(
              height: 10,
            ),
            MyTextField(
              autofocus: false,
              controller: passwordController,
              hintText: "Enter Password",
              obscureText: true,
            ),
            SizedBox(
              height: 10,
            ),
            MyTextField(
              autofocus: false,
              controller: confirmPasswordController,
              hintText: "Confirm Password",
              obscureText: true,
            ),
            SizedBox(
              height: 7,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 25),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3)),
                    side: BorderSide(color: Colors.white, width: 1.5),
                    value: isChecked,
                    onChanged: (state) {
                      setState(() {
                        isChecked = !isChecked;
                      });
                    },
                    // checkColor: Colors.greenAccent,
                    activeColor: Colors.red,
                  ),
                  Flexible(
                    child: RichText(
                        text: TextSpan(
                            text: "By signing up you agree to the ",
                            style: TextStyle(
                              color: Colors.white,
                              // fontSize: 17,
                            ),
                            children: [
                          TextSpan(
                              text: "terms of service",
                              style: TextStyle(
                                color: Color.fromARGB(255, 135, 201, 255),
                                // fontSize: 17,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  var url = Uri.parse('https://google.com');
                                  !await launchUrl(url);
                                })
                        ])),
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.push(context,
                  //         MaterialPageRoute(builder: (context) {
                  //       return SignUP();
                  //     }));
                  //   },
                  //   child: Text(
                  //     "terms of service",
                  //     style: TextStyle(
                  //       color: Color.fromARGB(255, 135, 201, 255),
                  //       fontSize: 16,
                  //     ),
                  //   ),
                  // )
                ],
              )),
            ),
            SizedBox(
              height: 7,
            ),
            MyButton(
              ontap: isChecked ? submit : () {},
              label: "Sign up",
              labelColor:
                  isChecked ? Colors.white : Color.fromARGB(255, 44, 44, 44),
              buttonColor: Colors.black,
              borderColor:
                  isChecked ? Colors.white : Color.fromARGB(255, 44, 44, 44),
              activeColor: isChecked ? Colors.white70 : Colors.transparent,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 2),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                      text: TextSpan(
                          text: "Have an account? ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.5,
                            fontFamily: "Kanit-Light",
                          ),
                          children: [
                        TextSpan(
                            text: "Sign in",
                            style: TextStyle(
                              color: Color.fromARGB(255, 135, 201, 255),
                              fontSize: 16,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pop(context, true);
                              })
                      ])),
                ],
              )),
            ),
            // skip button
            SizedBox(
              height: 20,
            ),

            SkipButton(),
          ],
        ),
      )),
    );
    ;
  }
}
