
///
/// Inside the Parent Widget
///
import 'package:flutter/material.dart';
import 'package:BuzzNote/views/callbackpage.dart';

class Father extends StatefulWidget {
  @override
  _FatherState createState() => _FatherState();
}

class _FatherState extends State<Father> {
  // Step 1 (optional): Define a Global variable 
  // to store the data comming back from the child.
  late int id;
  
  // Step 2: Define a function with the same signature
  // as the callback, so the callback will point to it, 
  // this new function will get the data from the child, 
  // set it to the global variable (from step 1) 
  // in the parent, and then update the UI by setState((){});
  void updateId(int newId) {
    setState(() {
      id = newId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Step 3: Construct a child widget and pass the
      child: Son(
        // Many options to make onSonChanged points to
        // an executable code(function) within memory 
        // called 'updateId':
        //
        // 1st option:
        onSonChanged: (int newId) {
          updateId(newId);
        },
        // 2nd option: onSonChanged: updateId,
        // 3rd option: onSonChanged: (int newId) => updateId(newId)
        
        // So each time the 'onSonChanged' called by the action
        // we defined inside the child, a new data will be
        // passed to this parent.
      )
    );
  }
}