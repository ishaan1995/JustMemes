import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const BASE_URL = "https://www.instagram.com";
const SUFFIX = "?__a=1";

Map<String, dynamic> getDefaultConfig() {
  return {
    "appVersion": {
      "minimum": 5,
      "current": 5,
    },
    "outage": {
      "showMaintenancePage": false,
    },
    "share": {
      "prefix": "Look at this meme",
      "suffix": "Shared by Funny Memes 😂",
      "appPrefix": "Download the app from: ",
      "appLink":
          "https://play.google.com/store/apps/details?id=com.nextgenkiapp.funnymemes",
      "showAppLink": true
    }
  };
}

Future<Map<String, dynamic>> getAppConfig() async {
  var url = "https://funnymemes.nextgenki.workers.dev/config";
  print('fetching app config........');
  var response = await http.get(url);
  int statusCode = response.statusCode;

  if (statusCode.success()) {
    print('fetched app config........');
    Map<String, dynamic> jsonData = json.decode(response.body);
    return jsonData;
  } else {
    return null;
  }
}

// TODO: add post account image, name, link to instagram methods

String firstIgUser() {
  return 'theironicalbaba';
}

List<String> getIGUsersList() {
  List<String> igUsers = [
    'official.desimeme',
    'thememebaba',
    'thedesifeed.in',
    'memes.point',
    'indian.tweets',
    'sarcastic_us',
    'bewakoofofficial',
    'thedopeindian',
    'thedesistuff',
    'diddle.app',
  ];
  return igUsers;
}

extension on int {
  bool success() {
    return this >= 200 && this <= 300;
  }
}

Future<List<Post>> getPosts({List<String> userList}) async {
  assert(userList != null);
  assert(userList.isNotEmpty);
  List<Post> globalPosts = [];

  for (var user in userList) {
    String url = '$BASE_URL/$user/$SUFFIX';
    print('get request on url: $url');
    var response = await http.get(url);
    int statusCode = response.statusCode;

    if (statusCode.success()) {
      // decode to json
      var jsonData = json.decode(response.body);

      var user = jsonData['graphql']['user'];
      var username = user['username'];
      var userProfileImageLink = user['profile_pic_url'];
      var edgesUsers = user['edge_owner_to_timeline_media'];

      for (var data in edgesUsers['edges']) {
        // data around 1 post in instagram
        var node = data['node'];

        bool isVideo = node['is_video'];

        String shareCode = node['shortcode'];
        int timestamp = node['taken_at_timestamp'];

        if (!isVideo) {
          Post post = Post(
              imageLink: node['display_url'],
              username: username,
              shareCode: shareCode,
              timestamp: timestamp,
              userProfileImageLink: userProfileImageLink,
              likedCount: node['edge_liked_by']['count'],
              thumbnail: node['thumbnail_src']);

          // add to global list
          globalPosts.add(post);
        }
      }
    }
  }

  return globalPosts;
}

class Post {
  String imageLink;
  String thumbnail;
  String username;
  String userProfileImageLink;
  int timestamp;
  String caption;
  int likedCount;
  String shareCode;

  Post({
    @required this.imageLink,
    @required this.username,
    @required this.userProfileImageLink,
    @required this.shareCode,
    @required this.timestamp,
    this.caption,
    this.likedCount,
    this.thumbnail,
  });

  @override
  String toString() {
    return {
      'imageLink': imageLink,
      'thumbnail': thumbnail,
      'username': username,
      'shareCode': shareCode,
      'timestamp': timestamp,
      'userProfileImageLink': userProfileImageLink,
      'caption': caption,
      'likedCount': likedCount,
    }.toString();
  }
}
