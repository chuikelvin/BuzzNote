import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lessons/views/homepage.dart';

class Staggering extends StatefulWidget {
  const Staggering({super.key});

  @override
  State<Staggering> createState() => _StaggeringState();
}

class _StaggeringState extends State<Staggering> {
  bool isFull = false;
  double boxHeight = 200;
  double boxWidth = 200;

  List items = [2, 3, 10, 9];
  _response() {
    print("hello");
    setState(() {
      if (isFull) {
        boxHeight = 200;
        boxWidth = 200;
        isFull = false;
      } else {
        boxHeight = MediaQuery.of(context).size.height;
        boxWidth = MediaQuery.of(context).size.width;
        isFull = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const MyHomePage();
        }));
      }),
      body: Container(
          child: StaggeredGridView.countBuilder(
        crossAxisCount: 2,
        // crossAxisCount: isFull ? 1 : 2,
        // crossAxisCount: 4,
        // crossAxisSpacing: 8,
        // mainAxisSpacing: 8,
        itemCount: 8,
        itemBuilder: (BuildContext context, int index) => Container(
            color: Colors.green,
            width: 100,
            // height: 200,
            // child:
            child: GestureDetector(
                onTap: _response,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  width: boxWidth,
                  // height: boxHeight,
                  // color: Colors.red,
                  // margin: EdgeInsets.all(5),
                  child:
                      // Text("$index")
                      TextField(
                    // expands: true,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      hintText: "Notes",
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ))

            // new Center(
            //   child: new CircleAvatar(
            //     backgroundColor: Colors.white,
            //     child: new Text('$index'),
            //   ),
            // )
            ),
        staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
        // staggeredTileBuilder: StaggeredTile.extent(),
        // staggeredTileBuilder: (int index) =>
        //     new StaggeredTile.count(2, items[index]),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
      )),
    );
  }
}
