import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lessons/utilites/dynamic%20list.dart';
import 'package:lessons/views/page3.dart';

class AnotherPage extends StatefulWidget {
  const AnotherPage({super.key, required});

  @override
  State<AnotherPage> createState() => _AnotherPageState();
}

class _AnotherPageState extends State<AnotherPage> {
  List items = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(169, 45, 45, 45),
      appBar: AppBar(actions: [
        IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const Staggering();
              }));
            },
            icon: Icon(Icons.skip_next))
      ]),
      body: SafeArea(
          child: Container(
              child: Dynalist(
        items: items,
      ))),
      floatingActionButton: FloatingActionButton(
        child: Text("${items.length}"),
        onPressed: () {
          setState(() {
            items.add("index");
          });
        },
      ),
    );
  }
}
