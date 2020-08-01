import 'package:flutter/material.dart';

class DeprecationPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Warning',
          style: TextStyle(
              color: Colors.white,
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Text('This version has been removed. Please upgrade the app.'),
      ),
    );
  }
}
