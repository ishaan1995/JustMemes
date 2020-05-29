import 'rest.dart';
import 'package:flutter/foundation.dart';
import 'extensions/global_ext.dart';

Future<List<Post>> mergePostsByTime({
  @required List<Post> currentPosts,
  @required List<Post> newPosts,
  @required int currentIndex,
}) async {
  List<Post> output = [];

  int indexOverflow = currentIndex + 2;
  output += currentPosts.sublist(0, indexOverflow);

  List<Post> temp =
      currentPosts.sublist(indexOverflow + 1, currentPosts.length);

  temp += newPosts;
  temp.sort((Post p1, Post p2) => p1.timestamp.compareTo(p2.timestamp));
  output += temp;

  return output;
}
