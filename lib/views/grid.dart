import 'package:flutter/material.dart';

class GridTest extends StatelessWidget {
  const GridTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: GridView(
        scrollDirection: Axis.vertical,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 2, mainAxisSpacing: 2),
        children: [
          Container(
            width: 200,
            height: 200,
            color: Colors.red,
            margin: EdgeInsets.all(10),
          ),
          Container(
            width: 200,
            height: 500,
            color: Colors.red,
            margin: EdgeInsets.all(10),
          ),
          Container(
            width: 600,
            height: 200,
            color: Colors.red,
            margin: EdgeInsets.all(10),
          ),
          Container(
            width: 200,
            height: 200,
            color: Colors.red,
            margin: EdgeInsets.all(10),
          ),
          Container(
            width: 200,
            height: 200,
            color: Colors.red,
            margin: EdgeInsets.all(10),
          ),
        ],
      )),
    );
  }
}
