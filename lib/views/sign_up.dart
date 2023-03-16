import 'dart:async';

import 'package:BuzzNote/controllers/usercontroller.dart';
import 'package:BuzzNote/utilites/errormessage.dart';
import 'package:BuzzNote/utilites/myButton.dart';
import 'package:BuzzNote/utilites/myTextfield2.dart';
import 'package:BuzzNote/utilites/skipButton.dart';
import 'package:BuzzNote/views/homepage.dart';
// import 'package:BuzzNote/views/homepagelocal.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUP extends StatefulWidget {
  final void Function()? onTap;
  bool isSkippable;

    int backPress;

  SignUP({super.key, required this.onTap, this.isSkippable = true,this.backPress=0});

  @override
  State<SignUP> createState() => _SignUPState();
}

class _SignUPState extends State<SignUP> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  // final userController = Get.find<User>();
  final userController = Get.find<UserController>();

  bool isChecked = false;

  Color enabledBorder = Colors.grey;

  Color errorColor = Colors.grey;
  late bool isSkippable;
  @override
  void initState() {
    isSkippable = widget.isSkippable;
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();

    super.dispose();
  }

  Future submit() async {
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
    if (emailController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty &&
        firstNameController.text.trim().isNotEmpty &&
        lastNameController.text.trim().isNotEmpty) {
      userController.updateDisplayName(
          "${firstNameController.text.trim()} ${lastNameController.text.trim()}");
      try {
        UserCredential result =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        User? user = result.user;
        await user?.sendEmailVerification();
        user!.updateDisplayName(
            "${firstNameController.text.trim()} ${lastNameController.text.trim()}");
        if (!isSkippable) {
          for (var i = 0; i <= widget.backPress; i++) {
          Navigator.pop(context);
            
          }
        }
      } on FirebaseAuthException catch (e) {
        showErrorMessage(e.code.replaceAll("-", " "), context);
        // print(e.code);
      }
      // newUser.user?.updateDisplayName(
      //   "${firstNameController.text.trim()} ${lastNameController.text.trim()}",
      // );
      // });
    } else {
      setState(() {
        errorColor = Colors.red;
      });

      Timer(Duration(milliseconds: 2500), () {
        setState(() {
          errorColor = enabledBorder;
        });
      });
      showErrorMessage("One or more inputs is empty", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      // appBar: AppBar(backgroundColor: Colors.transparent),
      body: SafeArea(
          child: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 35,
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
                          child: MyTextField2(
                            padding: 0,
                            // autofocus: false,
                            controller: firstNameController,
                            hintText: "first name",
                            // obscureText: false,
                            enabledBorder:
                                firstNameController.text.trim().isEmpty
                                    ? errorColor
                                    : enabledBorder,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: MyTextField2(
                            padding: 0,
                            autofocus: false,
                            controller: lastNameController,
                            hintText: "last name",
                            enabledBorder:
                                lastNameController.text.trim().isEmpty
                                    ? errorColor
                                    : enabledBorder,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  MyTextField2(
                    // autofocus: false,
                    controller: emailController,
                    hintText: "Enter Email Address",
                    // obscureText: false,
                    enabledBorder: emailController.text.trim().isEmpty
                        ? errorColor
                        : enabledBorder,
                    change: (text) {
                      // RegExp numReg = RegExp(r".*[0-9].*");
                      // RegExp letterReg = RegExp(r".*[A-Za-z].*");
                      print(EmailValidator.validate(text));
                      if (text.isNotEmpty &&
                          EmailValidator.validate(text) != true) {
                        return [false, "Not a valid email"];
                      } else {
                        return [true, ""];
                      }
                    },
                  ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  MyTextField2(
                    // autofocus: false,
                    controller: passwordController,
                    hintText: "Enter Password",
                    obscureText: true,
                    enabledBorder: passwordController.text.trim().isEmpty
                        ? errorColor
                        : enabledBorder,
                    change: (text) {
                      // RegExp numReg = RegExp(r".*[0-9].*");
                      // RegExp letterReg = RegExp(r".*[A-Za-z].*");
                      if (text.length < 6) {
                        return [
                          false,
                          "password must have at least 6 characters"
                        ];
                      } else {
                        return [true, ""];
                      }
                    },
                  ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  MyTextField2(
                    autofocus: false,
                    controller: confirmPasswordController,
                    hintText: "Confirm Password",
                    obscureText: true,
                    change: (text) {
                      if (text == passwordController.text.trim()) {
                        return [true, "password match"];
                      } else {
                        return [false, "password do not match"];
                      }
                    },
                    enabledBorder: confirmPasswordController.text.trim().isEmpty
                        ? errorColor
                        : enabledBorder,
                  ),
                  // SizedBox(
                  //   height: 7,
                  // ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 25),
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
                                        var url =
                                            Uri.parse('https://google.com');
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
                    ontap: isChecked
                        ? submit
                        : () => showErrorMessage(
                            "You must agree to the terms of service", context),
                    label: "Sign up",
                    labelColor: isChecked
                        ? Colors.white
                        : Color.fromARGB(255, 44, 44, 44),
                    buttonColor: Colors.black,
                    borderColor: isChecked
                        ? Colors.white
                        : Color.fromARGB(255, 44, 44, 44),
                    activeColor:
                        isChecked ? Colors.white70 : Colors.transparent,
                  ),
                  SizedBox(
                    height: 17,
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
                                    ..onTap = () =>
                                        // Navigator.pop(context, true);
                                        widget.onTap!()
                                  // }
                                  )
                            ])),
                      ],
                    )),
                  ),
                  // skip button
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    color: Colors.transparent,
                    child: isSkippable
                        ? SkipButton(
                            skipAction: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return MyHomePage();
                              })).then((value) {
                                print(value);
                              });
                            },
                          )
                        : null,
                  )
                ],
              ),
            ),
          ),
          Positioned(
              top: 3,
              left: 3,
              child: isSkippable
                  ? Container()
                  : IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    )),
        ],
      )),
    );
    ;
  }
}
