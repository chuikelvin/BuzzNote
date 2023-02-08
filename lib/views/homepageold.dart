import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lessons/utilites/dynamic%20list.dart';
import 'package:lessons/views/anotherpage.dart';
import 'package:lessons/views/grid.dart';

List items = ['one', 12, 12, 34, 6521234];

ScrollController _controller = ScrollController();

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        drawer: Drawer(
          backgroundColor: Color.fromARGB(0, 0, 0, 0),
          child: SafeArea(
              child: Container(
            color: Colors.red,
            child: FittedBox(
              fit: BoxFit.cover,
              clipBehavior: Clip.hardEdge,
              child: Image.asset(
                'assets/images/peter.jpg',
                height: MediaQuery.of(context).size.height,
                // scale: 0.5,
              ),
            ),
          )),
          elevation: 0,
        ),
        appBar: AppBar(
            title: Text("GOOGLE", style: TextStyle(fontFamily: "Kanit-Light")),
            centerTitle: true,
            shadowColor: Colors.blue,
            // flexibleSpace: ,
            leading: Builder(builder: (context) {
              return IconButton(
                onPressed: () {
                  print("pressed");
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(Icons.menu),
              );
            }),
            actions: []),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     print("pressed");
        //     items.add(items.length);
        //     print(items.length);
        //   },
        //   child: Icon(CupertinoIcons.add),
        // ),
        body: SafeArea(
          child: Stack(children: [
            Container(
                color: Color.fromARGB(255, 66, 66, 66),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: ListView(
                  controller: _controller,
                  physics: ScrollPhysics(),
                  children: [
                    Container(
                      // width: 200,
                      height: 200,
                      child: PageView.builder(
                        // shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return Container(
                              width: 200,
                              height: 200,
                              // clipBehavior: C,
                              color: Color.fromARGB(255, 255, index * 50, 7),
                              margin: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: TextField(
                                decoration: InputDecoration(
                                    fillColor: Colors.amber,
                                    hintText: "Notes",
                                    hintStyle: TextStyle(
                                        color:
                                            Color.fromARGB(99, 255, 255, 255))),
                                cursorColor: Colors.white,
                                autofocus: true,
                                maxLines: null,
                                // minLines: 1,
                                // expands: true,
                                // obscureText: true,
                                keyboardType: TextInputType.multiline,
                                style: TextStyle(color: Colors.white),
                                // focusNode: FocusNode.FocusScope.of(context).requestFocus(myFocusNode);,
                              ));
                        },
                      ),
                    ),
                    Container(
                      height: 200,
                      color: Colors.red,
                      margin: EdgeInsets.only(bottom: 20),
                    ),
                    Container(
                      height: 200,
                      color: Color.fromARGB(255, 79, 54, 244),
                      margin: EdgeInsets.only(bottom: 20),
                    ),
                    Container(
                      height: 200,
                      color: Color.fromARGB(255, 193, 244, 54),
                      margin: EdgeInsets.only(bottom: 20),
                    )
                  ],
                )
                // child: Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Div(),
                //     Div(),
                //   ],
                // ),
                ),
            Container(
              alignment: Alignment(0, 0.92),
              // color: Colors.green,
              // height: MediaQuery.of(context).size.height * 0.1,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 45, 45, 45),
                        offset: Offset(2.0, 2.0),
                        blurRadius: 3.0,
                        spreadRadius: 3.0,
                        // offset: Offset.
                      )
                    ]),
                width: MediaQuery.of(context).size.width * 0.8,
                child: GestureDetector(
                  onTap: () {
                    print("object");
                    // Scaffold.of(context).openDrawer();
                  },
                  child: IconButton(
                    splashColor: Colors.red,
                    highlightColor: Colors.red,
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // print("object");
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const AnotherPage();
                      }));
                      // Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
              ),
            )
          ]),
        ));
  }
}

class Div extends StatelessWidget {
  const Div({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 200,
        // height: 200,
        color: Colors.blue,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Stack(
          children: [
            FittedBox(
                fit: BoxFit.fill,
                child: Image.asset('assets/images/peter.jpg')),
            Text('hello world'),
          ],
        ));
  }
}
