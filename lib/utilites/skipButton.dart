import 'dart:async';

import 'package:BuzzNote/utilites/myTextfield2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../controllers/usercontroller.dart';

class SkipButton extends StatefulWidget {
  Function() skipAction;

  SkipButton({super.key, required this.skipAction});

  @override
  State<SkipButton> createState() => _SkipButtonState();
}

class _SkipButtonState extends State<SkipButton> {
  Color borderColor = Colors.black;
  TextEditingController nameController = TextEditingController();
  late final Box startup;

  void initState() {
    // TODO: implement initState
    super.initState();
    startup = Hive.box("startup");
    startup.isEmpty ? null : useValues();
  }

  useValues() {
    for (var item in startup.values) {
      // print(item);
      nameController.text = item;
      //   setState(() {
      //   content.add(item);
      // }
      // );
    }
  }

  void colorIndicator() {
    if (nameController.text.trim().isEmpty) {
      setState(() {
        borderColor = Colors.red;
      });
      print("123");
    } else {
      setState(() {
        borderColor = Colors.black;
      });
    }
    Timer(Duration(milliseconds: 2500), () {
      setState(() {
        borderColor = Colors.black;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    return Container(
      child: GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(builder: (context, setState) {
                    return CupertinoAlertDialog(
                      title: Text("Are you sure?"),
                      content: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("You risk losing your notes"),
                          Text("You can always sign in /up later"),
                          Text("Enter username to proceed"),
                          SizedBox(
                            // height: 20,
                            child: Material(
                                color: Colors.transparent,
                                child: TextField(
                                  onChanged: (value) {
                                    if (nameController.text.trim().isEmpty) {
                                      setState(() {
                                        borderColor = Colors.red;
                                      });
                                    } else {
                                      setState(() {
                                        borderColor = Colors.black;
                                      });
                                    }
                                  },
                                  onSubmitted: (value) {
                                    // print(value);
                                  },
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    isCollapsed: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    hintText: "Enter username",
                                    // hintStyle: TextStyle(color: Colors.white70),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: borderColor),
                                        borderRadius:
                                            BorderRadius.circular(18)),
                                    // border: InputBorder.none,
                                    // filled: false,
                                    // fillColor: Colors.transparent,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: borderColor),
                                        borderRadius:
                                            BorderRadius.circular(18)),
                                  ),
                                )),
                          ),
                        ],
                      ),
                      actions: [
                        CupertinoDialogAction(
                          child: Text(
                            "SKIP",
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {
                            if (nameController.text.trim().isEmpty) {
                              // colorIndicator();
                              if (nameController.text.trim().isEmpty) {
                                setState(() {
                                  borderColor = Colors.red;
                                });
                                Timer(Duration(milliseconds: 2500), () {
                                  setState(() {
                                    borderColor = Colors.black;
                                  });
                                });
                                print("123");
                              } else {
                                setState(() {
                                  borderColor = Colors.black;
                                });
                              }
                            } else {
                              userController.updateDisplayName(
                                  "${nameController.text.trim()}");
                              CircularProgressIndicator();
                              Navigator.of(context).pop();
                              startup.put(
                                  "username", nameController.text.trim());
                              widget.skipAction();
                            }

                            // setState(() {
                            //   isConfirmed = true;
                            // });
                            //   () async {
                            // await FirebaseAuth.instance.signInAnonymously();
                            // CircularProgressIndicator();
                            // Navigator.of(context).pop();
                            //   // Navigator.push(context,
                            //   //     MaterialPageRoute(builder: (context) {
                            //   //   return MyHomePage();
                            //   // }));
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
                }).then((value) => nameController.text = "");
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('skip',
                  style: TextStyle(color: Colors.white70, fontSize: 19)),
              // Icon(
              //   Icons.navigate_next,
              //   color: Colors.white70,
              //   size: 19,
              // )
            ],
          )),
    );
  }
}
