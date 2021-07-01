import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:paginable/paginable.dart';

import 'api.dart';
import 'model/post.dart';
import 'post_cubit.dart';

void main() {
  runApp(BlocProvider(
      create: (context) => PostCubit(),
      child: MaterialApp(
        home: Home(),
        debugShowCheckedModeBanner: false,
      )));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Api api;

  @override
  void initState() {
    super.initState();
    api = Api();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: FutureBuilder<List<Post>>(
                future: api.getPosts(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Container(
                      color: Colors.redAccent,
                      child: Center(
                          child: Text(snapshot.error.toString(),
                              style: TextStyle(color: Colors.white))),
                    );
                  }
                  if (snapshot.hasData) {
                    context.read<PostCubit>().add(snapshot.data!);
                    return BlocBuilder<PostCubit, List<Post>>(
                        builder: (context, state) {
                      return PaginableListViewBuilder(
                        errorIndicatorWidget: (exception, tryAgain) =>
                            Container(
                                color: Colors.redAccent,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(exception.toString()),
                                    ElevatedButton(
                                      onPressed: tryAgain,
                                      child: Text("Try Again"),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.green)),
                                    )
                                  ],
                                )),
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 16.0),
                            leading: CircleAvatar(
                                backgroundColor: Colors.greenAccent,
                                child: Text(state[index].id.toString(),
                                    style: TextStyle(color: Colors.white))),
                            title: Text(state[index].title),
                          );
                        },
                        itemCount: state.length,
                        loadMore: () async {
                          List<Post> posts = await api.getPosts();

                          context.read<PostCubit>().add(posts);
                        },
                        progressIndicatorWidget: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      );
                    });
                  }
                  return Center(child: CircularProgressIndicator());
                })));
  }
}
