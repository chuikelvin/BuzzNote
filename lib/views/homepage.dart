import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hive/hive.dart';

import '../utilites/newpge.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final Box box;
  // late List<int> selected_Index = [];
  Set<int> selected_Index = new Set();
  bool is_Selected = false;
  void deleted(index) {
    setState(() {
      content.removeAt(index);
    });
    box.put('notes', content);
  }

  List content = [
    // "hello world 123",
    // "welcome \n to \nflutter ",
    // "this \n is \n a \n dynamic\n grid \n view"
  ];

  @override
  void initState() {
    super.initState();
    box = Hive.box("notes");
    // content.isEmpty? content.add("content");
    // for (var i = 0; i < box.length; i++) {
    //   box.deleteAt(i);
    // }
    // box.deleteAt(0);
    box.isEmpty ? print("not") : _getInfo();
  }

  void updatetext(index, text) {
    // print(context);
    setState(() {
      content[index] = text;
    });

    box.add(content);
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  _addInfo() async {
    // Storing key-value pair
    // box.add('John');
    for (var item in box.values) {
      print(item);
    }
    box.add(content);
    // print('Info added to box!');
  }

  _getInfo() {
    for (var item in box.values) {
      print(item);
      //   setState(() {
      //   content.add(item);
      // }
      // );
    }
    setState(() {
      content.addAll(box.get('notes'));
    });
    // box.get('name');
    // var country = box.get('country');
    // print('Info retrieved from box: $name ($country)');
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
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text('Heros Flutter'),
          backgroundColor: is_Selected && selected_Index.isNotEmpty
              ? Color.fromARGB(255, 41, 41, 41)
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
              : null,
          actions: is_Selected && selected_Index.isNotEmpty
              ? [
                  IconButton(
                      onPressed: () {
                        List toBedel = [];
                        toBedel.addAll(selected_Index);
                        toBedel.sort();
                        var listtobedel = toBedel.reversed;
                        toBedel = listtobedel.toList();
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
                      icon: Icon(Icons.delete))
                ]
              : [],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            int index = content.length;
            // print(selected_Index);
            setState(() {
              content.add("");
            });
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewPage(
                          content[index],
                          onSonChanged: (String data) {
                            setState(() {
                              content[index] = data;
                            });
                            box.put('notes', content);
                          },
                          // index: index,
                        ))).then((value) {
              if (value == true) {
                setState(() {
                  content.removeLast();
                });
              }
              print(content.contains(""));
            });
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
                  itemBuilder: (BuildContext context, int index) => Container(
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
                                          content.remove(index);
                                        }),
                                        print(value),
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
                                      : Colors.grey,
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
                  staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                  // staggeredTileBuilder: StaggeredTile.extent(),
                  // staggeredTileBuilder: (int index) =>
                  //     new StaggeredTile.count(2, items[index]),
                  mainAxisSpacing: 1.2,
                  crossAxisSpacing: 1.2,
                ),
        ),
      ),
    );
  }
}

class displayBox extends StatelessWidget {
  const displayBox({super.key, required bool});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
