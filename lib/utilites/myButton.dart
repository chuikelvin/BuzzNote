import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class MyButton extends StatefulWidget {
  final Function()? ontap;

  MyButton({super.key, required this.ontap});

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
      onTapUp: (details) {
        setState(() {
          istapped = false;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        margin: EdgeInsets.symmetric(horizontal: 25),
        // width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: istapped == true ? Colors.white70 : Colors.white,
            borderRadius: BorderRadius.circular(18)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_open),
            Text(
              'Sign In',
              style: TextStyle(
                  color: Colors.black,
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
      onTapUp: (details) {
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
