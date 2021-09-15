import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paginable/paginable.dart';
import 'package:paginablelistviewbuilder_example/utils.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('PaginableListViewBuilder'),
        ),
        body: PaginableListViewBuilder(
            loadMore: () async {
              // throw Exception('This is a test exception');
              await fetchFiveMore();
              setState(() {});
            },
            errorIndicatorWidget: (exception, tryAgain) => Container(
                  color: Colors.redAccent,
                  height: 130,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        exception.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green),
                        ),
                        onPressed: tryAgain,
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
            progressIndicatorWidget: const SizedBox(
              height: 100,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            itemBuilder: (context, index) => ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      numbers.elementAt(index).toString(),
                    ),
                  ),
                ),
            itemCount: numbers.length),
      ),
    );
  }
}
