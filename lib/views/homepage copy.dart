import 'package:BuzzNote/controllers/usercontroller.dart';
import 'package:BuzzNote/utilites/errormessage.dart';
import 'package:BuzzNote/views/settings_page.dart';
import 'package:BuzzNote/views/sign_in_or_sign_up.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';

import 'package:get/get.dart';

import 'package:BuzzNote/utilites/encrypyt_decrypt.dart';

import 'note_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // final user = Get.find<User>();
  // final userController = Get.find<UserController>();
  bool isLoggedin = false;
  var user;
  // var user = FirebaseAuth.instance.currentUser??Get.find<UserController>();
  late String enkey;
  late final Box box;
  // late List<int> selected_Index = [];
  Set<int> selected_Index = {};
  bool is_Selected = false;

  bool isDifferent = false;

  void deleted(index) {
    setState(() {
      content.removeAt(index);
    });
    box.put('notes', content);
  }

  // StreamSubscriber _userChanges;

  List content = [];
  List fetched = [];
  Map notesMap = {};

  @override
  void initState() {
    super.initState();
    box = Hive.box("notes");
    try {
      user = FirebaseAuth.instance.currentUser!;
    } catch (e) {
      user = Get.find<UserController>();
    }
    if (user.runtimeType == User) {
      if (user != null) {
        setState(() {
          isLoggedin = true;
          enkey = "  ${user.uid}  ";
        });
        // getOnlineNotes().then((value) => null);
        // print(fetched.length);
        // data =docUser.get();
      }

      // FirebaseFirestore.instance
      //     .collection("notes")
      //     .doc(user.uid)
      //     .snapshots()
      //     .listen((event) {
      //   var data = event.data()!;
      //   // var list = [];
      //   setState(() {
      //     content.clear();
      //   });
      //   data.map(
      //     (key, value) {
      //       setState(() {
      //         // if (int.parse(key) < content.length-1) {
      //         //   content[int.parse(key)] = value;P
      //         // } else {
      //         //   content.add(value);
      //         // Encrypted encnote = value;
      //         // var note = decryptWithAES(enkey, encnote);
      //         String note = decryptWithAES(enkey, value);
      //         print(note);
      //         // }
      //         if (content.contains(note)) {
      //           return;
      //         }
      //         content.add(note);
      //         // content.insert(int.parse(key), value);
      //       });
      //       return MapEntry(key, value);
      //     },
      //   );

      // });
    } else {}

    box.isEmpty
        ? null
        : WidgetsBinding.instance.addPostFrameCallback((_) => _getInfo());
    ;
  }

// Stream<QuerySnapshot> get notes{
//   final docUser =
//         FirebaseFirestore.instance.collection("notes").doc(user.uid).snapshots().listen((event) { });
//   return;
// }
  Future getOnlineNotes(
      {bool addToLocal = false, bool preventDuplicates = false}) async {
    final docUser =
        FirebaseFirestore.instance.collection("notes").doc(user.uid);
    await docUser.get().then((value) async {
      if (value.data() != null) {
        var data = value.data()!;
        // setState(() {
        //   notesMap = data;
        // });
        // print(data);
        data.map(
          (key, value) {
            setState(() {
              // if (int.parse(key) < content.length - 1) {
              //   content[int.parse(key)] = value;
              // } else {
              //   content.add(value);
              // }
              // Encrypted encnote = value;
              var note = decryptWithAES(enkey, value);
              // print(note);
              notesMap.addAll({key: note});
              // }
              if (content.contains(note) && preventDuplicates == true) {
                return;
              }
              addToLocal ? content.add(note) : fetched.add(note);
              // content.add(value);
              // content.insert(int.parse(key), value);
            });
            return MapEntry(key, value);
          },
        );
      }
    });
  }

  // void updatetext(index, text) {
  //   // print(context);
  //   setState(() {
  //     content[index] = text;
  //   });

  //   box.add(content);
  // }

  @override
  void dispose() {
    super.dispose();
  }

  _getInfo() {
    // for (var item in box.values) {
    //   print(item);
    //   //   setState(() {
    //   //   content.add(item);
    //   // }
    //   // );
    // }
    setState(() {
      content.addAll(box.get('notes'));
    });
    // print(listEquals(content, fetched));
    if (isLoggedin) {
      getOnlineNotes().then((value) {
        var sortedContent = content;
        var sortedfetched = fetched;
        sortedContent.sort();
        sortedfetched.sort();
        print(sortedContent);
        print(sortedfetched);
        if (!listEquals(sortedContent, sortedfetched) &&
            sortedContent.isNotEmpty) {
          setState(() {
            isDifferent = true;
          });
        }
        if (isDifferent) mergeorpurge();

        FirebaseFirestore.instance
            .collection("notes")
            .doc(user.uid)
            .snapshots()
            .listen((event) {
          var data = event.data()!;
          // var list = [];
          setState(() {
            if (!isDifferent) content.clear();
          });
          data.map(
            (key, value) {
              setState(() {
                // if (int.parse(key) < content.length-1) {
                //   content[int.parse(key)] = value;P
                // } else {
                //   content.add(value);
                // Encrypted encnote = value;
                // var note = decryptWithAES(enkey, encnote);
                String note = decryptWithAES(enkey, value);
                // print(note);
                // }
                if (content.contains(note)) {
                  return;
                }
                content.add(note);
                // content.insert(int.parse(key), value);
              });
              return MapEntry(key, value);
            },
          );
        });
      });
    }

// )
  }

  merge() async {
    final docUser =
        FirebaseFirestore.instance.collection("notes").doc(user?.uid);
    // if (_controller.text.trim().isEmpty) {
    //   Navigator.pop(context, true);
    //   final json = {'${widget.index}': FieldValue.delete()};
    //   docUser.update(json);
    // } else {
    //   Navigator.pop(context);
    Map<String, String> map = {};
    for (var i = 0; i < content.length; i++) {
      if (fetched.contains(content[i])) {
        continue;
      }
      Encrypted encrypted = encryptWithAES("  ${user?.uid}  ", content[i]);
      String data = encrypted.base64;
      if (fetched.length == 0) {
        map.addAll({"${fetched.length + i}": data});
      } else {
        map.addAll({"${fetched.length + 1 + i}": data});
      }
    }

    // print(fetched.length);
    // print('seems');
    // map.forEach((key, value) {
    //   print(key + "  " + value);
    // });

    await docUser.get().then((value) async {
      // final json = {'${widget.index}': data};
      if (value.exists) {
        docUser.update(map);
      } else {
        await docUser.set(map);
      }
    }).then((value) {
      setState(() {
        isDifferent = false;
        fetched.clear();
        content.clear();
      });
      getOnlineNotes(addToLocal: true, preventDuplicates: true).then((value) {
        print(content);
        setState(() {
          // content.addAll(fetched);
        });
        box.put('notes', content);
      });
    });
    Navigator.pop(context);
  }
  // }

  purge() {
    setState(() {
      content.clear();
      box.put('notes', content);
      isDifferent = false;
    });

    getOnlineNotes(addToLocal: true);
    Navigator.pop(context);
  }

  Future<dynamic> mergeorpurge() {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Color.fromARGB(255, 31, 31, 31),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Local notes found",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Would you like to merge or purge.\n Local notes will be added at the end.",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                          onTap: merge,
                          child: Container(
                              width: 120,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 6),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Text(
                                "Merge",
                              ))),
                      GestureDetector(
                          onTap: purge,
                          child: Container(
                              width: 120,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 6),
                              decoration: BoxDecoration(
                                  color: Colors.amber[900],
                                  borderRadius: BorderRadius.circular(12)),
                              child: Text(
                                "Purge",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ))),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  logOut() async {
    Navigator.of(context).pop();
    if (isLoggedin) {
      FirebaseAuth.instance.signOut();
      GoogleSignIn().signOut();
    } else {
      Navigator.of(context).pop();
    }
  }

  noteHandler(int index) {
    print(index);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NewPage(
                  index: index,
                  content[index],
                  onSonChanged: (String data) {
                    setState(() {
                      content[index] = data;
                    });
                  },
                  // index: index,
                ))).then((value) => {
          if (value == true)
            {
              setState(() {
                content.removeAt(index);
              }),
              // print(content),
              showErrorMessage("Empty notes are not saved", context,
                  color: Colors.grey[800],
                  paddingHorizontal: 50,
                  paddingVertical: 7,
                  milliSeconds: 600),
              box.put('notes', content)
            }
          else
            {box.put('notes', content)}
        });
  }

  double x = 0;
  double y = 0;
  // double z = 10;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        setState(() {
          selected_Index.clear();
        });
        // print('nah');
        // setState(() {
        //   is_Selected = false;
        // });
        return Future.value(true);
      },
      child: StreamBuilder<Object?>(
          stream: isLoggedin ? FirebaseAuth.instance.userChanges() : null,
          builder: (context, snapshot) {
            if (isLoggedin) {
              if (snapshot.data != user) {
                // print("no change");
                // setState(() {
                user = snapshot.data as User;
                // });
              }
            }
            // print(snapshot.data);
            // print(user);
            // snapshot.data?.reload();
            return Scaffold(
              backgroundColor: Colors.black,
              drawer: Drawer(
                width: 0.8 * MediaQuery.of(context).size.width,
                // backgroundColor: Colors.blue,
                // backgroundColor: Colors.black,
                backgroundColor: Color.fromARGB(255, 31, 31, 31),
                child: DrawerContent(
                  user: user,
                  isLoggedIn: isLoggedin,
                  logout: () => logOut,
                  // localUser: userController,
                ),
              ),
              appBar: AppBar(
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  title: Text(
                    'BuzzNote',
                    style: TextStyle(
                      letterSpacing: 4,
                    ),
                  ),
                  backgroundColor: is_Selected && selected_Index.isNotEmpty
                      ? Color.fromARGB(255, 41, 41, 41)
                      // : Color.fromARGB(255, 41, 41, 41),
                      : Colors.black,
                  leading: is_Selected && selected_Index.isNotEmpty
                      ? Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    selected_Index.clear();
                                    is_Selected = false;
                                  });
                                },
                                icon: Icon(Icons.cancel)),
                            Center(
                              child: Container(
                                width: 8,
                                child: Text("${selected_Index.length}",
                                    style: TextStyle(
                                      fontSize: 19,
                                    )),
                              ),
                            ),
                          ],
                        )
                      : Builder(builder: (context) {
                          return IconButton(
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                            icon: Icon(Icons.menu),
                          );
                        }),
                  actions: is_Selected && selected_Index.isNotEmpty
                      ? [
                          IconButton(
                              onPressed: () async {
                                List toBedel = [];
                                toBedel.addAll(selected_Index);
                                toBedel.sort();
                                // var listtobedel = toBedel.reversed;

                                toBedel = toBedel.reversed.toList();
                                if (isLoggedin) {
                                  final docUser = FirebaseFirestore.instance
                                      .collection("notes")
                                      .doc(user.uid);
                                  await docUser.get().then((value) async {
                                    if (value.exists) {
                                      for (var index in toBedel) {
                                        // print(fetched.indexOf(content[index]));
                                        var key = notesMap.keys.firstWhere(
                                            (k) =>
                                                notesMap[k] ==
                                                "${content[index]}",
                                            orElse: () => "null");
                                        print(key);
                                        final json = {
                                          '${key}': FieldValue.delete()
                                        };
                                        docUser.update(json);
                                      }
                                      //   final json = {'${index}': data};
                                      //   if (value.exists) {
                                      //     docUser.update(json);
                                      //   } else {
                                      //     await docUser.set(json);
                                    }
                                  });
                                }
                                for (var index in toBedel) {
                                  // print(index);
                                  setState(() {
                                    is_Selected = false;

                                    content.removeAt(index);
                                  });
                                }

                                setState(() {
                                  selected_Index.clear();
                                });

                                print(toBedel);

                                box.put('notes', content);
                              },
                              icon: Icon(Icons.delete)),
                        ]
                      : [
                          IconButton(
                            onPressed: isDifferent ? mergeorpurge : () {},
                            icon: Icon(
                              Icons.warning_amber_rounded,
                              size: 30,
                              color: isDifferent
                                  ? Colors.amber[900]
                                  : Colors.transparent,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: GestureDetector(
                                onTap: () {
                                  openDialog();
                                  // FirebaseAuth.instance.signOut();
                                  // GoogleSignIn().signOut();
                                },
                                child: CircleAvatar(
                                    radius: 16,
                                    backgroundColor: user.photoURL != null
                                        ? Colors.transparent
                                        : Colors.grey[600],
                                    // backgroundColor: Colors.black,
                                    // backgroundImage: (user.photoURL != null)
                                    //     ?
                                    //     //  ?
                                    //     NetworkImage('${user.photoURL}')
                                    //         as ImageProvider
                                    //     // AssetImage('assets/icon/ic_round.png')
                                    //     : null,
                                    child: user.photoURL != null
                                        ? ClipOval(
                                            // borderRadius: BorderRadius.circular(25),
                                            child: Image.network(
                                                "${user.photoURL}"))
                                        // child: Image.file(_image!))
                                        : Icon(
                                            CupertinoIcons.person,
                                            color: Colors.white,
                                          )
                                    // : const AssetImage(
                                    //     'assets/icon/ic_round.png'),
                                    ),
                              ),
                            ),
                          ),
                        ]),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  int index = content.length;
                  // // print(selected_Index);
                  setState(() {
                    content.add("");
                  });
                  noteHandler(index);
                  // GetNotes();

                  // final docUser =
                  //     FirebaseFirestore.instance.collection("notes").doc(user.uid);
                  // await docUser.get().then((value) async {
                  //   if (value.data() != null) {
                  //     var data = value.data()!;
                  //     data.map(
                  //       (key, value) {
                  //         setState(() {
                  //           content.insert(int.parse(key), value);
                  //         });
                  //         return MapEntry(key, value);
                  //       },
                  //     );
                  //   }
                  // });
                },
                backgroundColor: Colors.black,
                // shape: BeveledRectangleBorder(
                //     borderRadius: BorderRadius.circular(20),
                //     side: BorderSide(
                //       color: Colors.grey,
                //       width: 1.3,
                //     )),
                child: Container(
                    // decoration: BoxDecoration(
                    //     border: Border.all(
                    //   color: Colors.grey,
                    // )),
                    child: Icon(Icons.add)),
              ),
              body: SafeArea(
                child: content.isEmpty
                    ? Center(
                        // color: Colors.red,
                        child: Text("No Content \n Add notes to display",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              letterSpacing: 3,
                            )),
                      )
                    : StaggeredGridView.countBuilder(
                        crossAxisCount: 2,
                        // crossAxisCount: isFull ? 1 : 2,
                        // crossAxisCount: 4,
                        // crossAxisSpacing: 8,
                        // mainAxisSpacing: 8,
                        itemCount: content.length,
                        // child:
                        itemBuilder: (BuildContext context, int index) =>
                            Container(
                          padding: EdgeInsets.all(5),
                          child: Transform.translate(
                            offset: Offset(x, y),
                            child: GestureDetector(
                              onPanUpdate: (details) {
                                // Swiping in right direction.
                                print(details.delta.dx);
                                if (details.delta.dx > 0) {
                                  setState(() {
                                    x = details.delta.dx;
                                  });
                                }

                                // Swiping in left direction.
                                if (details.delta.dx < 0) {}
                              },
                              onLongPress: () {
                                setState(() {
                                  is_Selected = true;
                                  selected_Index.contains(index)
                                      ? selected_Index.remove(index)
                                      : selected_Index.add(index);
                                  // content.removeAt(index);
                                });
                                // box.put('notes', content);
                                print(is_Selected);
                              },
                              onTap: () {
                                is_Selected && selected_Index.isNotEmpty
                                    ? setState(() {
                                        is_Selected = true;
                                        selected_Index.contains(index)
                                            ? selected_Index.remove(index)
                                            : selected_Index.add(index);
                                        // content.removeAt(index);
                                      })
                                    : Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => NewPage(
                                                  index: index,
                                                  content[index],
                                                  onSonChanged: (String data) {
                                                    setState(() {
                                                      content[index] = data;
                                                    });
                                                  },
                                                  // index: index,
                                                ))).then((value) => {
                                          if (value == true)
                                            {
                                              setState(() {
                                                content.removeAt(index);
                                              }),
                                              // print(content),
                                              showErrorMessage(
                                                  "Empty notes are not saved",
                                                  context,
                                                  color: Colors.white70),
                                              box.put('notes', content)
                                            }
                                        });
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    // color: is_Selected ? Colors.red : null,
                                    border: Border.all(
                                        color: content[index].trim().isEmpty
                                            ? Colors.transparent
                                            : selected_Index.contains(index)
                                                ? Colors.grey
                                                : Colors.blueGrey,
                                        width: selected_Index.contains(index)
                                            ? 3.5
                                            : 1.5)),
                                child: Hero(
                                    tag: 'dash',
                                    child: Material(
                                      color: Colors.black,
                                      child: Text(
                                        "${content[index]}",
                                        style: TextStyle(
                                          backgroundColor: Colors.black,
                                          color: Colors.white,
                                          fontSize: 20,
                                          //   // debugLabel:
                                        ),
                                      ),
                                    )),
                              ),
                            ),
                          ),
                        ),
                        staggeredTileBuilder: (int index) =>
                            StaggeredTile.fit(1),
                        // staggeredTileBuilder: StaggeredTile.extent(),
                        // staggeredTileBuilder: (int index) =>
                        //     new StaggeredTile.count(2, items[index]),
                        mainAxisSpacing: 1.2,
                        crossAxisSpacing: 1.2,
                      ),
              ),
            );
          }),
    );
  }

  Future openDialog() => showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Color.fromARGB(255, 31, 31, 31),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              height: 300,
              // alignment: Alignment.center,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'BuzzNote',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        letterSpacing: 4,
                        color: Colors.white,
                        fontSize: 19,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: user.photoURL != null
                            ? Image.network(
                                user.photoURL.toString(),
                                scale: 2,
                              )
                            : Icon(
                                Icons.account_circle_outlined,
                                color: Colors.white,
                                size: 50,
                              )
                        // Image.asset(
                        //     // 'assets/icon/splash.png',
                        //     // scale: 2.5,
                        //     'assets/icon/splash.png',
                        //     scale: 2.5,
                        //   ),
                        ),
                    SizedBox(height: 20),
                    Text(
                      user.displayName != null ? "${user.displayName}" : "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        // letterSpacing: 4,
                        wordSpacing: 4,
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(height: 20),
                    // Text(
                    //   "${user.email}",
                    //   textAlign: TextAlign.center,
                    //   style: TextStyle(
                    //     // letterSpacing: 4,
                    //     wordSpacing: 4,
                    //     color: Colors.white,
                    //     fontSize: 14,
                    //   ),
                    // ),
                    IconButton(
                        onPressed: logOut,
                        icon: Icon(
                          Icons.logout,
                          color: Colors.white,
                        ))
                  ],
                ),
              )),
        ),
      );
}

class DrawerContent extends StatelessWidget {
  // User user;
  var user;

  Function logout;

  bool isLoggedIn;
  // Function logout()
  // UserController localUser;

  DrawerContent(
      {super.key,
      required this.user,
      required this.logout,
      required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(children: [
      Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Text(
              'BuzzNote',
              textAlign: TextAlign.start,
              style: TextStyle(
                letterSpacing: 4,
                color: Colors.white,
                fontSize: 19,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SettingsPage();
              }));
            },
            leading: Container(
              clipBehavior: Clip.hardEdge,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.white24),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: user.photoURL != null
                    ? Colors.transparent
                    : Colors.grey[600],
                child: user.photoURL != null
                    ? ClipOval(
                        // borderRadius: BorderRadius.circular(25),
                        child: Image.network("${user.photoURL}"))
                    // child: Image.file(_image!))
                    : Icon(
                        CupertinoIcons.person,
                        color: Colors.white,
                      ),
              ),
              // user.photoURL != null
              //     ? Image.network(
              //         user.photoURL.toString(),
              //         scale: 2.2,
              //       )
              //     : Icon(
              //         CupertinoIcons.person,
              //         color: Colors.white,
              //         size: 30,
              //       )
            ),
            title: Text(
              user.displayName ?? "",
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
            subtitle: Text(
              user.email == null
                  ? user.email
                  : user.email.toString().trim().isNotEmpty
                      ? user.email
                      : "local account",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          Divider(
            height: 10,
            thickness: 0.77,
            indent: 25,
            endIndent: 25,
            color: Colors.white60,
          ),
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SettingsPage();
              }));
            },
            leading: Icon(
              CupertinoIcons.person,
              color: Colors.white,
              size: 20,
            ),
            title: Text(
              "Account and settings",
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
          ),
          // ListTile(
          //   // onTap: () {
          //   //   Navigator.push(context, MaterialPageRoute(builder: (context) {
          //   //     return SettingsPage();
          //   //   }));
          //   // },
          //   enableFeedback: true,
          //   leading: Icon(
          //     Icons.fingerprint,
          //     color: Colors.white,
          //     size: 20,
          //   ),
          //   title: Text(
          //     "Password and security",
          //     style: TextStyle(color: Colors.white, fontSize: 17),
          //   ),
          // ),
          // ListTile(
          //   onTap: () {
          //     Navigator.push(context, MaterialPageRoute(builder: (context) {
          //       return DeletedPage();
          //     }));
          //   },
          //   leading: Icon(
          //     CupertinoIcons.delete,
          //     color: Colors.white,
          //     size: 20,
          //   ),
          //   title: Text(
          //     "Deleted",
          //     style: TextStyle(color: Colors.white, fontSize: 17),
          //   ),
          // ),
          // logout
          GestureDetector(
            onTap: isLoggedIn
                ? logout()
                : () {
                    Navigator.of(context).pop();
                    // Navigator.of(context).pop();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return SignInOrUpPage(
                        isSkippable: false,
                      );
                    }));
                  },
            child: ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.white,
                size: 20,
              ),
              title: Text(
                isLoggedIn ? "log out" : "log in / create account",
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
          ),
        ],
      ),
      Positioned(
          bottom: 0,
          width: 0.8 * MediaQuery.of(context).size.width,
          child: Container(
            // color: Colors.blue,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "powered by",
                  style: TextStyle(color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Image.asset(
                    "assets/images/traffsbychui.png",
                    scale: 5.2,
                  ),
                )
              ],
            ),
          ))
    ]));
  }
}
