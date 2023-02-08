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
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        print('nah');
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Heros Flutter'),
          backgroundColor: Colors.black,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            int index = content.length;
            print(index);
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
                            content.removeAt(index);
                          });
                          box.put('notes', content);
                          // print("hello");
                        },
                        onTap: () {
                          Navigator.push(
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
                                      ))).then((value) => print("back"));
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: content[index].trim().isEmpty
                                      ? Colors.transparent
                                      : Colors.grey,
                                  width: 1.5)),
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
