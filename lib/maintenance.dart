import 'package:flutter/material.dart';
import 'extensions/global_ext.dart';
import 'package:flutter/services.dart';

class MaintenancePage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    TextStyle h1Style = TextStyle(
      fontSize: 32.0,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );

    TextStyle h2Style = TextStyle(
      fontSize: 16.0,
      color: Colors.white,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: 'Warning'.toAppBar(
        centerTitle: true,
        textColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'There seems to be some issue with the app. \nPlease try again later.',
                textAlign: TextAlign.center,
                style: h1Style,
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
              ),
              FlatButton(
                onPressed: () {
                  SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
                },
                textTheme: ButtonTextTheme.accent,
                child: Text(
                  'Close App',
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
