import 'package:BuzzNote/utilites/myButton.dart';
import 'package:BuzzNote/utilites/mytextfield.dart';
import 'package:BuzzNote/utilites/skipButton.dart';
import 'package:BuzzNote/views/homepage copy.dart';
// import 'package:BuzzNote/views/homepagelocal.dart';
import 'package:BuzzNote/views/sign_up.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../utilites/errormessage.dart';

class SignIn extends StatefulWidget {
  final Function()? onTap;
  bool isSkippable;

  SignIn({super.key, required this.onTap, this.isSkippable = true});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isValid = false;
  String validatorText = "";
  bool isComplete = false;
  late bool isSkippable;
  @override
  void initState() {
    isSkippable = widget.isSkippable;
    // TODO: implement initState
    super.initState();
    // String datetime = DateTime.now().toString();
    // print(datetime);
    // setState(() {
    //   emailController.text = datetime;
    // });
    // refreshTime();
  }

  // Future<DateTime> getTime() async {
  //   return DateTime.now();
  // }

  // Future<void> refreshTime() async {
  //   await getTime().then((value) {
  //     // print(value.toString());
  //     // print("object");
  //     value.year;
  //     var time =
  //         "${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')} ${value.hour.toString().padLeft(2, '0')}:${value.minute}:${value.second}";
  //     setState(() {
  //       emailController.text = time;
  //     });
  //     return new Future.delayed(const Duration(seconds: 1), refreshTime);
  //   });
  // }

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
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailController.text.trim(),
                password: passwordController.text.trim())
            .then((value) => null);
        if (!isSkippable) {
          Navigator.pop(context);
          Navigator.pop(context);
        }
      } on FirebaseAuthException catch (e) {
        showErrorMessage(e.code.replaceAll("-", " "), context);
        // print(e.code);
      }
    } else {
      showErrorMessage("One or more inputs is empty", context);
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
      showErrorMessage(e.code, context);
      print(e.code);
    }
    Navigator.pop(context);
    if (!isSkippable) {
      Navigator.pop(context);
      Navigator.pop(context);
      // Navigator.popUntil(context, ModalRoute.withName('/screen1'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Stack(children: [
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
        Center(
          child: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 15,
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
                    onTap: () {
                      TextEditingController passwordreset =
                          TextEditingController();
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            backgroundColor: Color.fromARGB(255, 31, 31, 31),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Container(
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Reset your password",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Enter email to receive password reset",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    controller: passwordreset,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                    decoration: InputDecoration(
                                        isCollapsed: true,
                                        isDense: true,
                                        hintText: "Email address",
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 5),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(18))),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                      onTap: () async {
                                        if (passwordreset.text
                                            .trim()
                                            .isNotEmpty) {
                                          // emailController
                                          await FirebaseAuth.instance
                                              .sendPasswordResetEmail(
                                                  email: passwordreset.text
                                                      .trim());
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      child: Container(
                                          width: double.infinity,
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 6),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Text(
                                            "Reset password",
                                          )))
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    // },
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
                        // PictureButton(
                        //   image: 'assets/images/meta-logo.png',
                        //   label: 'Meta',
                        //   ontap: signUpGoogle,
                        // ),
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
                                  ..onTap = () => widget.onTap!()
                                //   print('Works');
                                //   // Navigator.push(context,
                                //   //     MaterialPageRoute(builder: (context) {
                                //   //   return SignUP();
                                //   // }));
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

                // SkipButton(
                //   skipAction: widget.skip),

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
        )
      ])),
    );
  }
}
