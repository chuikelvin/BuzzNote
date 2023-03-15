import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class MyButton extends StatefulWidget {
  final Function()? ontap;
  final String label;
  Color buttonColor;
  Color borderColor;
  Color labelColor;
  Color activeColor;
  bool hasIcon;
  IconData icon;
  double borderRadius;
  double borderWidth;
  double margin;
  double verticalPadding;
  double horizontalPadding;

  MyButton({
    super.key,
    required this.ontap,
    required this.label,
    this.labelColor = Colors.black,
    this.buttonColor = Colors.white,
    this.borderColor = Colors.white,
    this.activeColor = Colors.white70,
    this.borderRadius = 18,
    this.borderWidth = 1.5,
    this.margin = 25,
    this.verticalPadding = 12,
    this.horizontalPadding = 25,
    this.hasIcon = false,
    this.icon = Icons.lock_open,
  });

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  bool istapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.ontap,
      onTapDown: (details) {
        setState(() {
          istapped = true;
        });
      },
      onTapCancel: () {
        setState(() {
          istapped = false;
        });
      },
      onTapUp: (details) {
        setState(() {
          istapped = false;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: widget.horizontalPadding,
            vertical: widget.verticalPadding),
        margin: EdgeInsets.symmetric(horizontal: widget.margin),
        // width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: istapped == true ? widget.activeColor : widget.buttonColor,
            border: Border.all(
                width: widget.borderWidth, color: widget.borderColor),
            borderRadius: BorderRadius.circular(widget.borderRadius)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.hasIcon ? Icon(widget.icon) : Container(),
            Text(
              widget.label,
              style: TextStyle(
                  color: widget.labelColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 17),
            ),
          ],
        ),
      ),
    );
  }
}

// picture button
class PictureButton extends StatefulWidget {
  final Function()? ontap;
  final String image;
  final String label;
  const PictureButton(
      {super.key,
      required this.ontap,
      required this.image,
      required this.label});

  @override
  State<PictureButton> createState() => _PictureButtonState();
}

class _PictureButtonState extends State<PictureButton> {
  bool istapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.ontap,
      onTapDown: (details) {
        setState(() {
          istapped = true;
        });
      },
      onTapCancel: () {
        setState(() {
          istapped = false;
        });
      },
      child: Column(
        children: [
          Image.asset(
            widget.image,
            scale: 5,
            color: istapped == true ? Color(0xFF7CD2CC) : Colors.white,
            colorBlendMode: BlendMode.modulate,
          ),
          Text(
            widget.label,
            style: TextStyle(
              color: istapped == true ? Color(0xFF7CD2CC) : Colors.white,
              fontSize: 18,
            ),
          )
        ],
      ),
    );
  }
}
