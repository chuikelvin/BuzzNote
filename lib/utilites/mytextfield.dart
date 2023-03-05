import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class MyTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final bool autofocus;

  final Function(String text)? change;

  double padding;

  Color enabledBorder;
  Color focusedBorder;

  MyTextField({
    super.key,
    this.change,
    required this.hintText,
    required this.autofocus,
    required this.obscureText,
    required this.controller,
    this.padding = 25,
    this.enabledBorder = Colors.grey,
    this.focusedBorder = Colors.white,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late bool isVisible = widget.obscureText;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   // var isVisible = widget.obscureText;
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.padding),
      child: TextFormField(
        onChanged: widget.change,
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
                    icon: Icon(
                        isVisible ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        isVisible = !isVisible;
                      });
                    },
                  )
                : null),
      ),
    );
  }
}
