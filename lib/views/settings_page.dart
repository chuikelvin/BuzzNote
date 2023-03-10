import 'dart:io';

import 'package:BuzzNote/utilites/set_photo_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser!;
  late File _imageFile;

  updateImage(File imagefile) {
    print(user.photoURL);
    setState(() {
      _imageFile = imagefile;
    });
    uploadImageToFirebase();
  }

  Future uploadImageToFirebase() async {
    final path = 'profile/${user.uid}';
    final file = File(_imageFile.path);
    final _firebaseStorage = FirebaseStorage.instance;
    if (_imageFile == null) {
      print("empty");
      return;
    }
    ;
    var snapshot = await _firebaseStorage.ref().child(path).putFile(_imageFile);
    var downloadUrl = await snapshot.ref.getDownloadURL();
    await user.updatePhotoURL(downloadUrl);
    // https://lh3.googleusercontent.com/a/AGNmyxan5RR93cSC0CUv-g82blxLwbY61Q75_PuMqvC5=s96-c
//     await user?.updateDisplayName("Jane Q. User");
// await user?.updatePhotoURL("https://example.com/jane-q-user/profile.jpg");
    await _auth.currentUser?.reload();
    // print(downloadUrl);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        dispose();
        return Future.value(true);
      },
      child: Scaffold(
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
                    UserPhoto(
                      user: user,
                      onUpdate: updateImage,
                    ),
                    // GestureDetector(
                    //   onTap: () {

                    //     showModalBottomSheet(
                    //         context: context,
                    //         shape: const RoundedRectangleBorder(
                    //           // <-- SEE HERE
                    //           borderRadius: BorderRadius.vertical(
                    //             top: Radius.circular(25.0),
                    //           ),
                    //         ),
                    //         builder: (context) {
                    //           return Container(
                    //               height: 200,
                    //               child: Column(
                    //                 children: [
                    //                   Text(
                    //                     "Select image from",
                    //                     style: TextStyle(
                    //                         fontSize: 20,
                    //                         fontFamily: 'roboto',
                    //                         fontWeight: FontWeight.w500),
                    //                   ),
                    //                   SelectPhoto(
                    //                     user:user
                    //                     icon: Icons.photo,
                    //                     onTap: () {},
                    //                     textLabel: 'browse gallery',
                    //                   ),
                    //                   Container(
                    //                     padding: const EdgeInsets.all(8.0),
                    //                     decoration: BoxDecoration(
                    //                       border: Border.all(
                    //                           width: 1.5, color: Colors.black),
                    //                       borderRadius: BorderRadius.circular(8),
                    //                       // boxShadow: BoxShadow()
                    //                     ),
                    //                     child: Wrap(
                    //                         crossAxisAlignment:
                    //                             WrapCrossAlignment.center,
                    //                         spacing: 8,
                    //                         children: [
                    //                           Icon(
                    //                             Icons.camera_alt_outlined,
                    //                           ),
                    //                           Text(
                    //                             "camera",
                    //                             style: TextStyle(fontSize: 22),
                    //                           ),
                    //                         ]),
                    //                   ),
                    //                   Wrap(
                    //                     children: [
                    //                       Icon(
                    //                         Icons.image,
                    //                       ),
                    //                       Text(
                    //                         "gallery",
                    //                         style: TextStyle(
                    //                           fontSize: 20,
                    //                         ),
                    //                       )
                    //                     ],
                    //                   )
                    //                 ],
                    //               ));
                    //         });
                    //   },
                    //   child: Stack(children: [
                    //     CircleAvatar(
                    //       radius: 50,
                    //       backgroundColor: user.photoURL != null
                    //           ? Colors.transparent
                    //           : Colors.grey[600],
                    //       child: user.photoURL != null
                    //           ? ClipOval(
                    //               // borderRadius: BorderRadius.circular(25),
                    //               child: Image.network("${user.photoURL}"))
                    //           : Icon(
                    //               CupertinoIcons.person,
                    //               color: Colors.white,
                    //             ),
                    //     ),
                    //     Positioned(
                    //         bottom: 1,
                    //         right: 7,
                    //         child: Icon(
                    //           Icons.camera_alt,
                    //           color: Colors.white70,
                    //         ))
                    //   ]),
                    // ),
                    Text(
                      user.displayName.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                    Text(
                      user.email.toString(),
                      style: TextStyle(
                          color:
                              user.emailVerified ? Colors.white : Colors.amber,
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
                      .doc(user.uid)
                      .delete();
                  final storageRef = FirebaseStorage.instance.ref();
                  // Create a reference to the file to delete
                  final desertRef = storageRef.child('profile/${user.uid}');

// Delete the file
                  await desertRef.delete();
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
      ),
    );
  }
}
