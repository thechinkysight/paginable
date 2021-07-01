import 'dart:convert';

import 'package:http/http.dart' as http;

import 'model/post.dart';

class Api {
  final String _endpoint = 'https://jsonplaceholder.typicode.com/posts/';

  int _lastPostId = 0;

  Future<List<Post>> getPosts() async {
    final List<Post> posts = [];

    if (_lastPostId < 100) {
      for (int i = _lastPostId + 1; i <= _lastPostId + 20; i++) {
        http.Response response =
            await http.get(Uri.parse(_endpoint + i.toString()));

        Map<String, dynamic> decodedResponse = json.decode(response.body);
        Post post = Post.fromJson(decodedResponse);
        posts.add(post);
      }
      _lastPostId += 20;
    }
    return posts;
  }
}
