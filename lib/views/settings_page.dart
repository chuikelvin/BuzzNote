import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            direction: Axis.horizontal,
            children: [
              Icon(
                CupertinoIcons.settings,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Settings",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          )
          // Container(
          //   color: Colors.blue,
          //   width: 200,
          //   child: Row(
          //     children: [
          //       Icon(
          //         CupertinoIcons.settings,
          //         color: Colors.white,
          //         size: 20,
          //       ),
          //       Text(
          //         "Settings",
          //         style: TextStyle(color: Colors.white, fontSize: 17),
          //       ),
          //     ],
          //   ),
          // ),
          ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // color: Colors.blue,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: user.photoURL != null
                          ? Colors.transparent
                          : Colors.grey[600],
                      child: user.photoURL != null
                          ? ClipOval(
                              // borderRadius: BorderRadius.circular(25),
                              child: Image.network("${user.photoURL}"))
                          : Icon(
                              CupertinoIcons.person,
                              color: Colors.white,
                            ),
                    ),
                    Positioned(
                        bottom: 1,
                        right: 7,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white70,
                        ))
                  ]),
                  Text(
                    user.displayName.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  Text(
                    user.email.toString(),
                    style: TextStyle(
                        color: user.emailVerified ? Colors.white : Colors.amber,
                        fontSize: 17),
                  ),
                ],
              ),
            ),
            Divider(
              height: 5,
              thickness: 0.5,
              // indent: 25,
              // endIndent: 25,
              color: Colors.white60,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Set up password",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            Divider(
              height: 5,
              thickness: 0.5,
              // indent: 25,
              // endIndent: 25,
              color: Colors.white60,
            ),
            Text(
              "Danger zone",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            GestureDetector(
              onTap: () async {
                final docUser = FirebaseFirestore.instance
                                .collection("notes")
                                .doc(user.uid).delete();
                await user.delete();
                Navigator.of(context).pop();
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.red),
                    borderRadius: BorderRadius.circular(6)),
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                child: Text(
                  "Delete my account",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 17,
                    // fontWeight: FontWeight.w500,
                    // fontFamily: "Kanit-Thin",
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
