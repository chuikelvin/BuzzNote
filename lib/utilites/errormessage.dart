import 'package:flutter/material.dart';

void showErrorMessage(String message, context,
    {color = Colors.red,
    icon = Icons.warning_amber,
    double paddingHorizontal = 8,
    double paddingVertical = 10,
    int milliSeconds = 1200}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          Text(message),
          GestureDetector(
              // padding: EdgeInsets.all(0),
              onTap: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
              child: Icon(
                Icons.close,
                color: Colors.white,
              ))
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: paddingVertical),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
    ),
    // behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    padding: EdgeInsets.symmetric(vertical: 0, horizontal: paddingHorizontal),
    duration: Duration(milliseconds: milliSeconds),
  ));
}
