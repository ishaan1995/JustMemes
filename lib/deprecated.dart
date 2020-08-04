import 'package:flutter/material.dart';
import 'device_spec.dart';
import 'extensions/global_ext.dart';
import 'package:url_launcher/url_launcher.dart';

class DeprecationPage extends StatelessWidget {

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

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
                'This version is not supported now. Please upgrade the app.',
                textAlign: TextAlign.center,
                style: h1Style,
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
              ),
              FlatButton(
                onPressed: () {
                  if (appConfig.containsKey('share') &&
                      appConfig['share']['appLink'] != null) {
                    String link = appConfig['share']['appLink'];
                    _launchURL(link);
                  }
                },
                textTheme: ButtonTextTheme.accent,
                child: Text(
                  'Update',
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
