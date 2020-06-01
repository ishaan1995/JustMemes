import 'rest.dart';
import 'package:flutter/foundation.dart';
import 'extensions/global_ext.dart';

extension Sort on List<Post> {
  void orderBy(String field, {bool desc = false}) {
    if (field != 'timestamp') {
      throw Exception('Not supported orderby on field: $field');
    }
    if (desc) {
      this.sort((User p1, User p2) => p2.timestamp.compareTo(p1.timestamp));
    } else {
      this.sort((User p1, User p2) => p1.timestamp.compareTo(p2.timestamp));
    }
  }
}

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
  temp.orderBy('timestamp', desc: true);
  output += temp;

  return output;
}
