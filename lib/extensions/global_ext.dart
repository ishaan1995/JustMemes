import 'package:flutter/material.dart';

extension GlobalAppExt on String {
  AppBar toAppBar({bool centerTitle = true, Color textColor = Colors.black}) {
    return AppBar(
        centerTitle: centerTitle,
        title: Text(
          this,
          style: TextStyle(
              color: textColor,
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      );
  }

  Text lightText({double fontSize = 16.0, Color textColor = Colors.grey}) {
    return Text(
          this,
          style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontStyle: FontStyle.italic),
        );
  }
}

extension LayoutAppExt on Widget {
  Widget center() {
    return Center(child: this);
  }
}