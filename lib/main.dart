import 'package:flutter/material.dart';
import 'rest.dart';

void main() async {
  List<Post> posts = await getPosts();
  print('got data: ${posts.length}');
  print('sample post: ${posts[0].toString()}');
  runApp(MyApp(
    posts: posts,
  ));
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

  final String title;
  final List<Post> posts;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 0;

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
