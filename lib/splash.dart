import 'package:flutter/material.dart';
import 'home.dart';
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

    getPosts().then((posts) {
      navigateWithPosts(context, posts);
    }).catchError((onError) {
      setState(() {
        splashState = {
          'isLoading': false,
          'isError': true,
          'posts': [],
        };
      });
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
    bool isError = splashState['isError'];

    return Scaffold(
      body: Container(
        child: Center(
          child: isError
              ? Text('Something went wrong.')
              : CircularProgressIndicator(),
        ),
      ),
    );
  }
}
