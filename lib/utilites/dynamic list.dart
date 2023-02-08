import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Dynalist extends StatefulWidget {
  List items;

  Dynalist({super.key, required this.items});

  @override
  State<Dynalist> createState() => _DynalistState();
}

class _DynalistState extends State<Dynalist> {
  // List items = ['one', 12, 12, 34, 6521234];
  ScrollController _scrolcontrol = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Container(
      // height: 200,
      child: GridView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          reverse: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8),
          // ListView.builder(
          //     scrollDirection: Axis.horizontal,
          controller: _scrolcontrol,
          itemCount: widget.items.length,
          itemBuilder: (context, index) {
            return Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 88, 88, 88),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey,
                    width: 2,
                  )),
              // margin: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Text("$index"),
                  TextField(
                    // expands: true,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      hintText: "Notes",
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  )
                ],
              ),
            );
          }),
      //     ),
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceAround,
      //       children: [
      //         FloatingActionButton(
      //             child: Icon(
      //               Icons.add,
      //               color: Colors.white,
      //             ),
      //             onPressed: () => {
      //                   setState(
      //                     () {
      //                       double last = widget.items.length - 1;
      //                       print(_scrolcontrol.position.maxScrollExtent);
      //                       // _scrolcontrol.
      //                       _scrolcontrol.animateTo(
      //                           _scrolcontrol.position.maxScrollExtent,
      //                           duration: Duration(seconds: 1),
      //                           curve: Curves.easeOut);
      //                       widget.items.add("index");
      //                     },
      //                   )
      //                 }),
      //         FloatingActionButton(
      //             child: Icon(
      //               Icons.remove,
      //               color: Colors.white,
      //             ),
      //             onPressed: () => {
      //                   setState(
      //                     () {
      //                       // double last = widget.items.length - 1;
      //                       // print(_scrolcontrol.position.maxScrollExtent);
      //                       // // _scrolcontrol.
      //                       // _scrolcontrol.animateTo(
      //                       //     _scrolcontrol.position.maxScrollExtent,
      //                       //     duration: Duration(seconds: 1),
      //                       //     curve: Curves.easeOut);
      //                       // print(Widget.items)
      //                       widget.items.removeLast();
      //                     },
      //                   )
      //                 }),
      //       ],
      //     )
      //   ],
      // ),
    ));
  }
}
