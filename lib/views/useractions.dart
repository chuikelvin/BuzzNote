import 'package:BuzzNote/utilites/myButton.dart';
import 'package:BuzzNote/utilites/mytextfield.dart';
import 'package:BuzzNote/utilites/skipButton.dart';
import 'package:BuzzNote/views/homepage.dart';
import 'package:BuzzNote/views/signup.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserActions extends StatefulWidget {
  UserActions({super.key});

  @override
  State<UserActions> createState() => _UserActionsState();
}

class _UserActionsState extends State<UserActions> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isValid = false;
  String validatorText = "";
  bool isComplete = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future submit() async {
    if (emailController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim());
      } on FirebaseAuthException catch (e) {
        showErrorMessage(e.code.replaceAll("-", " "));
        // print(e.code);
      }
    } else {
      showErrorMessage("one or more inputs is incomplete");
    }
  }

  Future signUpGoogle() async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    GoogleSignInAuthentication? googleAuth = await googleUser!.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    // UserCredential user =
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      showErrorMessage(e.code);
      print(e.code);
    }
    Navigator.pop(context);
  }

  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Container(
        child: Row(
          children: [
            Icon(
              Icons.warning_amber,
              color: Colors.white,
            ),
            Text(message),
          ],
        ),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.red, borderRadius: BorderRadius.circular(12)),
      ),
      // behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      // showCloseIcon: true,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
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
              MyTextField(
                change: (text) {
                  text.isNotEmpty
                      ? setState(() {
                          isValid = EmailValidator.validate(text);
                          isValid
                              ? validatorText = ""
                              : validatorText = "Not a valid email";
                        })
                      : setState(() {
                          validatorText = "";
                        });
                },
                autofocus: false,
                controller: emailController,
                hintText: "Enter Email Address",
                obscureText: false,
              ),
              SizedBox(
                height: 20,
                child: Text(
                  validatorText,
                  // isValid ? "Valid email address" : "invalid email address",
                  style: TextStyle(
                      color: isValid
                          ? Colors.green
                          : Color.fromARGB(255, 255, 17, 0)),
                ),
              ),
              MyTextField(
                autofocus: false,
                controller: passwordController,
                hintText: "Enter Password",
                obscureText: true,
              ),
              SizedBox(
                height: 7,
              ),
              GestureDetector(
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 35),
                        // padding: const EdgeInsets.only(left: 35),
                        child: Text('Forgot password?',
                            style: TextStyle(
                                color: Color.fromARGB(255, 135, 201, 255),
                                fontSize: 15)),
                      ),
                    ],
                  )),
              SizedBox(
                height: 7,
              ),
              MyButton(
                ontap: submit,
                label: "Sign In",
              ),
              SizedBox(
                height: 3,
              ),

              // MyButton(
              //   ontap: () {
              //     Navigator.push(context, MaterialPageRoute(builder: (context) {
              //       return SignUP();
              //     }));
              //   },
              //   label: "Sign Up",
              //   labelColor: Colors.white,
              //   buttonColor: Colors.black,
              // ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 13),
                child: Center(
                    child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.white60,
                        height: 5, //height spacing of divider
                        thickness: 0.7, //thickness of divier line
                        indent: 55, //spacing at the start of divider
                        endIndent: 5, //spacing at t
                      ),
                    ),
                    Text(
                      'or continue with',
                      style: TextStyle(color: Colors.white60, fontSize: 13),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.white60,
                        height: 5, //height spacing of divider
                        thickness: 0.7, //thickness of divier line
                        indent: 5, //spacing at the start of divider
                        endIndent: 55, //spacing at t
                      ),
                    )
                  ],
                )),
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 35),
                  // color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      PictureButton(
                        image: 'assets/images/google-logo.png',
                        label: 'Google',
                        ontap: signUpGoogle,
                      ),
                      PictureButton(
                        image: 'assets/images/meta-logo.png',
                        label: 'Meta',
                        ontap: signUpGoogle,
                      ),
                      // GestureDetector(
                      //   onTap: signUpGoogle,
                      //   child: Column(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/google-logo.png',
                      //         scale: 5,
                      //         color: Color(0xFF7CD2CC),
                      //       colorBlendMode: BlendMode.modulate,
                      //       ),
                      //       Text(
                      //         "Google",
                      //         style: TextStyle(
                      //           color: Colors.white,
                      //           fontSize: 18,
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // ),
                      // Column(
                      //   children: [
                      //     Image.asset(
                      //       'assets/images/meta-logo.png',
                      //       scale: 5,
                      //       color: Color(0xFF7CD2CC),
                      //       colorBlendMode: BlendMode.modulate,
                      //     ),
                      //     Text(
                      //       "Meta",
                      //       style: TextStyle(
                      //         color: Colors.white,
                      //         fontSize: 18,
                      //       ),
                      //     )
                      //   ],
                      // )
                    ],
                  )),
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
                            text: "Don't have an account? ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.5,
                              fontFamily: "Kanit-Light",
                            ),
                            children: [
                          TextSpan(
                              text: "Sign Up",
                              style: TextStyle(
                                color: Color.fromARGB(255, 135, 201, 255),
                                fontSize: 16,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return SignUP();
                                  }));
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

              // MyButton(
              //   ontap: submit,
              //   label: "Skip",
              //   borderColor: Colors.transparent,
              //   labelColor: Colors.white70,
              //   buttonColor: Colors.transparent,
              // ),
            ],
          ),
        ),
      )),
    );
  }
}
