import 'package:BuzzNote/utilites/myButton.dart';
import 'package:BuzzNote/utilites/mytextfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future submit() async {
    if (emailController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty) {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
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
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
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
              height: 50,
            ),
            MyTextField(
              autofocus: false,
              controller: emailController,
              hintText: "Enter Email Address",
              obscureText: false,
            ),
            SizedBox(
              height: 20,
            ),
            MyTextField(
              autofocus: false,
              controller: passwordController,
              hintText: "Enter Password",
              obscureText: true,
            ),
            SizedBox(
              height: 20,
            ),
            MyButton(
              ontap: submit,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Center(
                  child: Text(
                'or sign up with',
                style: TextStyle(color: Colors.white),
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
                ))
          ],
        ),
      )),
    );
  }
}
