import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const BASE_URL = "https://www.instagram.com";
const SUFFIX = "?__a=1";

// TODO: add post account image, name, link to instagram methods

List<String> getIGUsersList() {
  return ['sarcastic_us', 'diddle.app'];
}

extension on int {
  bool success() {
    return this >= 200 && this <= 300;
  }
}

Future<List<Post>> getPosts() async {
  List<String> userList = getIGUsersList();
  //List<String> userList = ['sarcastic_us'];
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

        if (!isVideo) {
          Post post = Post(
              imageLink: node['display_url'],
              username: username,
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
  String caption;
  int likedCount;

  Post({
    @required this.imageLink,
    @required this.username,
    @required this.userProfileImageLink,
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
      'userProfileImageLink': userProfileImageLink,
      'caption': caption,
      'likedCount': likedCount,
    }.toString();
  }
}
