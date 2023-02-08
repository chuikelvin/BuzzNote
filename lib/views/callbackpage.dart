///
/// Inside the Child Widget
///
import 'package:flutter/material.dart';

// Step 1: Define a Callback.
typedef void IntCallback(int id);

class Son extends StatelessWidget {
  // Step 2: Configre the child to expect a callback in the constructor(next 2 lines):
  final IntCallback onSonChanged;
  Son({ required this.onSonChanged });
  
  int elementId = 3;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Step 3: On specific action(e.g onPressed/
        // onTap/onLoad.. onWhatEver) trigger the callback 
        // with the data you want to pass to the parent.
        // Data will be passed as parameter(see elementId):
        onSonChanged(elementId);
        // Done in the child.
      },
      child: Text('Click me to call the callback!'),
    );
  }
}
///
///////////////


