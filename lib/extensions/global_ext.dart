import 'package:flutter/material.dart';

extension GlobalAppExt on String {
  AppBar toAppBar({bool centerTitle = true}) {
    return AppBar(
        centerTitle: centerTitle,
        title: Text(
          this,
          style: TextStyle(
              color: Colors.black,
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      );
  }

  Text lightText({double fontSize = 16.0}) {
    return Text(
          this,
          style: TextStyle(
              color: Colors.grey,
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