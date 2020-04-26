import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:test_insta_memes/feed.dart';

Future<List<Twt>> getData() async {
  var url = "https://api.jsonbin.io/b/5ea5cdbe98b3d5375234f12a";
  var response = await http.get(url);
  print(response.statusCode);
  var jsonData = json.decode(response.body);
  List<Map<String, dynamic>> posts = [];
  List<Twt> twts = [];
  User user = User(
    'Flutter',
    'FlutterDev',
    'https://pbs.twimg.com/profile_images/1187814172307800064/MhnwJbxw_400x400.jpg',
    'https://pbs.twimg.com/profile_banners/420730316/1578350457/1500x500',
    'Google’s UI toolkit to build apps for mobile, web, & desktop from a single codebase //',
    35,
    88675,
    true
  );
  var edges_users = jsonData['graphql']['user']['edge_owner_to_timeline_media'];
  for (var data in edges_users['edges']) {
    var node = data['node'];
    var json = {
      'url': node['display_url'],
      'username': 'memezar',
      'text': node['edge_media_to_caption']['edges'][0]['node']['text'],
      'likes': node['edge_liked_by']['count']
    };
    twts.add(
      Twt(user, 
      json['text'], 
      json['url'], 
      json['likes'], 
      false,
      193,
      false,
      2,
      1587343553550)
    );
  }
  print('----POSTS----');
  print(posts);
  print('--------');
  return twts;
}

void main() async {
  List<Twt> twts = await getData();
  print('got data');
  // runApp(MyApp());
  runApp(CustomTheme(child: Twittr(twts: twts)));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String test = "anshul";

  void _incrementCounter() {
    setState(() {
      _counter++;
      test = "ishaan";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times by $test:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
