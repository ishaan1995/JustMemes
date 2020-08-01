import 'package:flutter/material.dart';
import 'package:funny_memes/rest.dart';
import 'package:url_launcher/url_launcher.dart';
import 'device_spec.dart';

class InfoPage extends StatelessWidget {
  // TODO: add support for themes later on
  bool darkTheme = true;

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget igUserWidget(String igUser) {
    TextStyle h2Style = TextStyle(
      fontSize: 16.0,
      color: Colors.white,
      decoration: TextDecoration.underline,
      decorationColor: Colors.red,
      fontStyle: FontStyle.italic,
    );

    return InkWell(
      onTap: () {
        print('on tap $igUser');
        String link = 'https://instagram.com/$igUser';
        _launchURL(link);
      },
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: Center(
          child: Text(
            '@$igUser',
            style: h2Style,
          ),
        ),
      ),
    );
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
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: Text(
          'About',
          style: TextStyle(
              color: Colors.white,
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  if (appConfig.containsKey('share') &&
                      appConfig['share']['appLink'] != null) {
                    String link = appConfig['share']['appLink'];
                    _launchURL(link);
                  }
                },
                child: Text(
                  'Best of Memes 🔥',
                  style: h1Style,
                ),
              ),
              Padding(padding: EdgeInsets.all(4.0)),
              Text(
                'v${platformInfo.version} (${platformInfo.buildNumber})',
                style: h2Style,
              ),
              Divider(
                color: Colors.white,
                height: 40,
                thickness: 1,
                indent: 48,
                endIndent: 48,
              ),
              Text(
                'Credits:',
                style: h1Style,
              ),
              Padding(padding: EdgeInsets.all(4.0)),
              Text(
                '(Instagram Creators ❤️)',
                style: h2Style,
              ),
              Padding(padding: EdgeInsets.all(8.0)),
              for (String igUser in getIGUsersList()) igUserWidget(igUser)
            ],
          ),
        ),
      ),
    );
  }
}
