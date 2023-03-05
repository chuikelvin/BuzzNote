import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SkipButton extends StatelessWidget {
  const SkipButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: Text("Are you sure?"),
                  content: Column(
                    children: [
                      Text("You risk losing your notes"),
                      Text("You can always sign in /up later"),
                    ],
                  ),
                  actions: [
                    CupertinoDialogAction(
                      child: Text("SKIP"),
                      onPressed: () async {
                        await FirebaseAuth.instance.signInAnonymously();
                        CircularProgressIndicator();
                        Navigator.of(context).pop();
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) {
                        //   return MyHomePage();
                        // }));
                      },
                    ),
                    CupertinoDialogAction(
                      child: Text("CANCEL"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('skip', style: TextStyle(color: Colors.white70, fontSize: 19)),
            // Icon(
            //   Icons.navigate_next,
            //   color: Colors.white70,
            //   size: 19,
            // )
          ],
        ));
  }
}
