import 'package:flutter/material.dart';

void showErrorMessage(String message, context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.warning_amber,
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
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.red, borderRadius: BorderRadius.circular(12)),
    ),
    // behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
    // showCloseIcon: true,
  ));
}
