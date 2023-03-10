// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

typedef void IntCallback(String id);

class NewPage extends StatefulWidget {
  late var content;

  final IntCallback onSonChanged;

  int index;

  // Son({ @required this.onSonChanged });

  // var items;

  // ignore: empty_constructor_bodies
  NewPage(var content,
      {super.key, required this.onSonChanged, required this.index}) {
    this.content = content;
    // this.index = index;
  }

  @override
  State<NewPage> createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  final user = FirebaseAuth.instance.currentUser!;

  TextEditingController _controller = new TextEditingController();
  @override
  void initState() {
    super.initState();

    _controller.text = widget.content.toString();
  }

  // @override
  // void didUpdateWidget(covariant NewPage oldWidget) {
  //   // TODO: implement didUpdateWidget
  //   super.didUpdateWidget(oldWidget);
  //   print("updated");
  // }
  Future<bool> onExit() async {
    final docUser =
        FirebaseFirestore.instance.collection("notes").doc(user.uid);
    if (_controller.text.trim().isEmpty) {
      Navigator.pop(context, true);
      final json = {'${widget.index}': FieldValue.delete()};
      docUser.update(json);
    } else {
      Navigator.pop(context);
      String data = _controller.text.trim();

      await docUser.get().then((value) async {
        final json = {'${widget.index}': data};
        if (value.exists) {
          docUser.update(json);
        } else {
          await docUser.set(json);
        }
      });
    }

    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onExit
      // () {
      //   if (_controller.text.trim().isEmpty) {
      //     // Navigator.pop(context, false);
      //     // return "empty";
      //   }
      //   // else {
      //   //   String data = _controller.text.trim();
      //   //   final docUser =
      //   //       FirebaseFirestore.instance.collection("notes").doc(user.uid);
      //   //   await docUser.get().then((value) async {
      //   //     final json = {'${widget.index}': data};
      //   //     if (value.exists) {
      //   //       docUser.update(json);
      //   //     } else {
      //   //       await docUser.set(json);
      //   //     }
      //   //   });
      //   //   print("data");
      //   // }
      //   // _controller.text.trim();
      //   print("_controller.text");
      //   // return Future.value(true);

      //   // return Future.value(true);
      // }
      ,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Note'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: onExit
                // () {
                //   Navigator.of(context).pop();
                // }
                ,
                icon: Icon(Icons.check))
          ],
          // title: Text('New Screen'),
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            // decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(10),
            //     border: Border.all(color: Colors.grey, width: 1.5)),
            child: Hero(
              tag: 'dash',
              child: Material(
                color: Colors.transparent,
                child:
                    // Text("Title",
                    //     style: TextStyle(
                    //       color: Colors.green,
                    //       fontSize: 50,
                    //     )),
                    //   Column(
                    // children: [
                    // Container(
                    // padding: EdgeInsets.all(10),
                    // decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(10),
                    //     border: Border.all(color: Colors.grey, width: 1.5)),
                    // child: TextField(
                    //   onChanged: (value) {
                    //     widget.onSonChanged(value);
                    //   },
                    //   style: TextStyle(
                    //     backgroundColor: Colors.black,
                    //     color: Colors.white,
                    //     fontSize: 20,
                    //   ),
                    //   // maxLines: null,
                    //   // keyboardType: TextInputType.multiline,
                    //   // controller: _controller,
                    //   decoration: InputDecoration(
                    //     hintText: "Title",
                    //     hintStyle: TextStyle(color: Colors.white),
                    //     border: InputBorder.none,
                    //     // filled: false,
                    //     fillColor: Colors.transparent,
                    //     focusedBorder: InputBorder.none,
                    //   ),
                    // ),
                    // ),
                    TextField(
                  autofocus: true,
                  onChanged: (value) {
                    widget.onSonChanged(value.trim());
                  },
                  onSubmitted: (value) {
                    print("sumbit");
                  },
                  style: TextStyle(
                    backgroundColor: Colors.black,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  cursorColor: Colors.white,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Note",
                    hintStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                    // filled: false,
                    fillColor: Colors.transparent,
                    focusedBorder: InputBorder.none,
                  ),
                ),
                // ],
                // ),
              ),
            ),
          ),
        ),
      ),
    );
    // Image.network("https://images.unsplash.com/photo-1638579837195-3fb3b3287506?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw0fHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=500&q=60", )),
  }

  // void onSonChanged([String value]) {}
}
