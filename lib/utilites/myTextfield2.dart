import 'package:flutter/material.dart';

typedef List boolCallback(String id);

class MyTextField2 extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final bool autofocus;

  // final bool Function(String text) change;
  final boolCallback? change;

  double padding;

  Color errorColor;
  Color enabledBorder;
  Color focusedBorder;

  MyTextField2({
    super.key,
    required this.hintText,
    this.change,
    required this.controller,
    this.autofocus = false,
    this.obscureText = false,
    this.padding = 25,
    this.enabledBorder = Colors.grey,
    this.errorColor = Colors.grey,
    this.focusedBorder = Colors.white,
  });

  @override
  State<MyTextField2> createState() => _MyTextField2State();
}

class _MyTextField2State extends State<MyTextField2> {
  late bool isVisible = widget.obscureText;
  String validatorText = "";
  bool isValid = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // var isVisible = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: widget.padding),
          child: TextFormField(
            onChanged: (value) {
              if (value.isNotEmpty) {
                try {
                  var state = widget.change!(value);
                  // state(value);
                  print(state);
                  if (state[0] == true) {
                    setState(() {
                      isValid = true;
                      validatorText = state[1];
                    });
                  } else {
                    setState(() {
                      isValid = false;
                      validatorText = state[1];
                    });
                  }
                } catch (e) {}
              } else {
                setState(() {
                  isValid = true;
                  validatorText = "";
                });
              }
            },
            autofocus: widget.autofocus,
            controller: widget.controller,
            style: TextStyle(color: Colors.white),
            obscureText: isVisible,
            decoration: InputDecoration(
                isDense: true,
                isCollapsed: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                hintText: widget.hintText,
                hintStyle: TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: widget.enabledBorder),
                    borderRadius: BorderRadius.circular(18)),
                // border: InputBorder.none,
                // filled: false,
                // fillColor: Colors.transparent,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: widget.focusedBorder),
                    borderRadius: BorderRadius.circular(18)),
                suffixIcon: widget.obscureText
                    ? IconButton(
                        color: Colors.white,
                        icon: Icon(isVisible
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                      )
                    : null),
          ),
        ),
        SizedBox(
          height: 18,
          child: Text(
            validatorText,
            // isValid ? "Valid email address" : "invalid email address",
            style: TextStyle(
                fontSize: 12,
                color:
                    isValid ? Colors.green : Color.fromARGB(255, 255, 17, 0)),
          ),
        ),
      ],
    );
  }
}
