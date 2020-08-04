import 'package:flutter/material.dart';
import 'deprecated.dart';
import 'device_spec.dart';
import 'home.dart';
import 'maintenance.dart';
import 'rest.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  var splashState = {
    'isLoading': true,
    'posts': [],
    'isError': false,
  };

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  bool requireskMaintenance() {
    return appConfig.containsKey('outage') &&
        (appConfig['outage']['showMaintenancePage'] as bool);
  }

  bool hasDeprecation() {
    int minimumVersion = appConfig['appVersion']['minimum'];
    return minimumVersion > platformInfo.buildNumber;
  }

  void fetchPosts() {
    setState(() {
      splashState = {
        'isLoading': true,
        'isError': false,
        'posts': [],
      };
    });

    if (requireskMaintenance()) {
      Future.delayed(Duration(seconds: 1)).then((value) {
        // go to deprecated page.
        var route = MaterialPageRoute(builder: (context) {
          return MaintenancePage();
        });

        Navigator.of(context)
            .pushAndRemoveUntil(route, (Route<dynamic> route) => false);
      });

      return;
    }

    if (hasDeprecation()) {
      Future.delayed(Duration(seconds: 1)).then((value) {
        // go to deprecated page.
        var route = MaterialPageRoute(builder: (context) {
          return DeprecationPage();
        });

        Navigator.of(context)
            .pushAndRemoveUntil(route, (Route<dynamic> route) => false);
      });
      return;
    }

    getPosts(userList: [firstIgUser()]).then((posts) {
      navigateWithPosts(context, posts);
    }).catchError((onError) {
      if (this.mounted) {
        setState(() {
          splashState = {
            'isLoading': false,
            'isError': true,
            'posts': [],
          };
        });
      }
    });
  }

  void navigateWithPosts(BuildContext context, List<Post> posts) {
    var route = MaterialPageRoute(builder: (context) {
      return MyHomePage(
        posts: posts,
      );
    });

    Navigator.of(context)
        .pushAndRemoveUntil(route, (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    setDeviceSpec(context);
    bool isError = splashState['isError'];

    TextStyle errorTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 16.0,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Center(
          child: isError
              ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    'Something went wrong.',
                    style: errorTextStyle,
                  ),
                  Padding(
                      padding: EdgeInsets.all(
                    8.0,
                  )),
                  FlatButton(
                    onPressed: fetchPosts,
                    textTheme: ButtonTextTheme.accent,
                    child: Text(
                      'Retry',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  )
                ])
              : CircularProgressIndicator(),
        ),
      ),
    );
  }
}
