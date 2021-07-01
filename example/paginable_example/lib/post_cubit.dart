import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paginable_example/api.dart';

import 'model/post.dart';

class PostCubit extends Cubit<List<Post>> {
  int _lastFetchedPostId = 0;
  PostCubit() : super([]);
  void add(List<Post> posts) => emit(state + posts);

  Future<List<Post>> fetchPostsInChunks() async {
    final List<Post> posts = [];

    if (_lastFetchedPostId < 100) {
      for (int i = _lastFetchedPostId + 1; i <= _lastFetchedPostId + 20; i++) {
        posts.add(await Api.fetchPostById(i));
      }
      _lastFetchedPostId += 20;
    }
    return posts;
  }
}
