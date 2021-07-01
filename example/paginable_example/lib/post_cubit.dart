import 'package:flutter_bloc/flutter_bloc.dart';

import 'model/post.dart';

class PostCubit extends Cubit<List<Post>> {
  PostCubit() : super([]);

  void add(List<Post> posts) => emit(state + posts);
}
