import 'dart:convert';

import 'package:http/http.dart' as http;

import 'model/post.dart';

class Api {
  static final String _endpoint = 'https://jsonplaceholder.typicode.com/posts/';

  static Future<Post> fetchPostById(int id) async {
    http.Response response =
        await http.get(Uri.parse(_endpoint + id.toString()));
    Map<String, dynamic> decodedResponse = json.decode(response.body);
    return Post.fromJson(decodedResponse);
  }
}
