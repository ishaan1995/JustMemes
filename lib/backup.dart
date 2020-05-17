import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:test_insta_memes/feed.dart';

import 'news_feed.dart';
import 'rest.dart';

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
      true);
  var edges_users = jsonData['graphql']['user']['edge_owner_to_timeline_media'];
  for (var data in edges_users['edges']) {
    var node = data['node'];
    var json = {
      'url': node['display_url'],
      'username': 'memezar',
      'text': node['edge_media_to_caption']['edges'][0]['node']['text'],
      'likes': node['edge_liked_by']['count']
    };
    twts.add(Twt(user, json['text'], json['url'], json['likes'], false, 193,
        false, 2, 1587343553550));
  }
  print('----POSTS----');
  print(posts);
  print('--------');
  return twts;
}

// void main()=>runApp(new MaterialApp(
//   home: new NewsPage(),
//   title: 'Inshorts Clone',
//   theme: new ThemeData(
//     accentColor: Colors.lightBlue,
//     primaryColor: Colors.orange,
//   ),

// ));

void main() async {
  // List<Twt> twts = await getData();
  List<Post> posts = await getPosts();
  print('got data: ${posts.length}');
  print('sample post: ${posts[0].toString()}');
  runApp(MyApp(
    posts: posts,
  ));
  // runApp(CustomTheme(child: Twittr(twts: twts)));
  //runApp(NewsPage());
}

class MyApp extends StatelessWidget {
  final List<Post> posts;
  MyApp({Key key, @required this.posts}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
        posts: posts,
      ),
      //home: NewsPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, @required this.posts}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final List<Post> posts;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String test = "anshul";
  int index = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
      test = "ishaan";
    });
  }

  void updateIndex(DismissDirection direction) {
    if (direction == DismissDirection.up) {
      index++;
    } else {
      index--;
    }

    if (index > widget.posts.length - 1) {
      // rotate back to 0
      index = 0;
    }
    print('set index to $index');
  }

  Widget getBody1() {
    return Center(
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
    );
  }

  Widget getBody() {
    Post post = widget.posts[index];

    return Dismissible(
      key: Key(index.toString()),
      direction: DismissDirection.vertical,
      confirmDismiss: (DismissDirection direction) async {
        if (index == 0 && direction == DismissDirection.down) {
          return false;
        }
        return true;
      },
      onDismissed: (DismissDirection direction) {
        print('direction: $direction');
        setState(() {
          updateIndex(direction);
        });
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  CircleAvatar(
                    radius: 24.0,
                    backgroundImage:
                        NetworkImage("${post.userProfileImageLink}"),
                    backgroundColor: Colors.transparent,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  Text(
                    post.username,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
              ),
              Image.network(
                post.imageLink,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Best of Memes 🔥',
          style: TextStyle(
              color: Colors.black,
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: getBody(),
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 32.0),
              child: FloatingActionButton(
                heroTag: null,
                backgroundColor: Colors.green,
                onPressed: () {
                  print('reset');
                },
                tooltip: 'Reset',
                child: Icon(Icons.refresh),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              heroTag: null,
              backgroundColor: Colors.green,
              onPressed: () {
                print('share to be implemented');
              },
              tooltip: 'Share',
              child: Icon(Icons.share),
            ),
          ),
        ],
      ),
    );
  }
}
