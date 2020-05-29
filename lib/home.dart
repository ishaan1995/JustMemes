import 'package:flutter/material.dart';
import 'splash.dart';
import 'rest.dart';
import 'posts_helper.dart';
import 'extensions/global_ext.dart';
import 'package:share/share.dart';
import 'device_spec.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, @required this.posts}) : super(key: key);

  final List<Post> posts;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic> homePageState;
  double height;
  double width;
  AnimationController controller;
  Animation<double> animation;

  Color getBackgroundColor() {
    if (homePageState['theme'] == 'dark') {
      return Colors.black;
    } else {
      return Colors.white;
    }
  }

  Color getTextColor() {
    if (homePageState['theme'] == 'dark') {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }

  Color getLightTextColor() {
    if (homePageState['theme'] == 'dark') {
      return Colors.grey;
    } else {
      return Colors.grey;
    }
  }

  @override
  void initState() {
    super.initState();

    height = deviceSpec.height;
    width = deviceSpec.width;

    controller =
        new AnimationController(duration: Duration(seconds: 2), vsync: this)
          ..addListener(() {
            setState(() {});
          });
    animation = Tween(begin: 256.0, end: -256.0).animate(
      new CurvedAnimation(
        parent: controller,
        curve: Curves.fastOutSlowIn,
      ),
    );

    showTutorial().then((showTutorial) {

      print('should show tutorial $showTutorial');

      Future.delayed(Duration(seconds: 2), () {

        setState(() {
          homePageState['showTutorial'] = showTutorial;
        });

        if (showTutorial == true) {
          controller.repeat(period: Duration(seconds: 2));

          Future.delayed(Duration(seconds: 8), () {
            controller.forward(from: 0);
            controller.stop(canceled: true);

            setState(() {
              homePageState['showTutorial'] = false;
              setShowTutorial(false);
            });
          });
        }
      });
    });

    homePageState = {
      'index': 0,
      'posts': widget.posts,
      'theme': 'dark',
      'showTutorial': false,
    };

    _lazyLoadPosts();
  }

  Future<void> _lazyLoadPosts() async {
    List<String> userList = getIGUsersList();

    for (var igUser in userList) {
      List<Post> igUserPosts = await getPosts(userList: [igUser]);
      List<Post> output = await mergePostsByTime(
        currentIndex: homePageState['index'],
        currentPosts: homePageState['posts'],
        newPosts: igUserPosts,
      );

      if (this.mounted) {
        setState(() {
          homePageState['posts'] = output;
        });
      }
    }
  }

  void updateIndex(DismissDirection direction) {
    int index = homePageState['index'];
    if (direction == DismissDirection.up) {
      index++;
    } else {
      index--;
    }

    if (index > homePageState['posts'].length - 1) {
      // rotate back to 0
      index = 0;
    }

    homePageState['index'] = index;

    print('set index to $index');
  }

  Widget _getActions() {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: FloatingActionButton(
              heroTag: null,
              backgroundColor: Colors.green,
              onPressed: () {
                var route = MaterialPageRoute(builder: (context) {
                  return SplashPage();
                });

                Navigator.of(context)
                    .pushAndRemoveUntil(route, (Route<dynamic> route) => false);
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
              int index = homePageState['index'];
              Post post = homePageState['posts'][index];
              String link = 'https://instagram.com/p/${post.shareCode}/';
              String shareMessage =
                  "Look at this meme at $link.\n\n Shared By FunnyMemes.";
              Share.share(shareMessage);
            },
            tooltip: 'Share',
            child: Icon(Icons.share),
          ),
        ),
      ],
    );
  }

  Widget _tutorialOverlay() {
    print('height: $height');
    print('width $width');
    return Container(
      color: const Color(0x33ffffff),
      child: Transform.translate(
        offset: Offset(0.0, animation.value),
        child: Icon(
          Icons.arrow_upward,
          size: 128.0,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _getBody() {
    int index = homePageState['index'];
    int length = homePageState['posts'].length;
    Post post = homePageState['posts'][index];

    print('total posts: $length');

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
                    style: TextStyle(fontSize: 16.0, color: getTextColor()),
                  ),
                ],
              ),

              Padding(
                padding: EdgeInsets.all(8.0),
              ),

              /// meme image
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
    return Stack(
      fit: StackFit.expand,
      children: [
        Scaffold(
          backgroundColor: getBackgroundColor(),
          appBar: 'Best of Memes 🔥'
              .toAppBar(centerTitle: true, textColor: getTextColor()),
          body: Stack(
            fit: StackFit.expand,
            children: [
              Visibility(
                visible: true,
                child: InkWell(
                  onDoubleTap: () {
                    setState(() {
                      String currentTheme = homePageState['theme'];
                      if (currentTheme == 'dark') {
                        homePageState['theme'] = 'light';
                      } else {
                        homePageState['theme'] = 'dark';
                      }
                    });
                  },
                  child: _getBody(),
                ),
              ),
              Visibility(
                visible: true,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      'Powered by'.lightText(
                          fontSize: 20.0, textColor: getLightTextColor()),
                      Padding(padding: EdgeInsets.all(4.0)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage('images/instagram.png'),
                            width: 16.0,
                            height: 16.0,
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                          ),
                          'Instagram'.lightText(
                              fontSize: 12.0, textColor: getLightTextColor()),
                        ],
                      ),
                      Padding(padding: EdgeInsets.all(16.0))
                    ],
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: _getActions(),
        ),
        if (homePageState['showTutorial']) _tutorialOverlay(),
      ],
    );
  }
}
