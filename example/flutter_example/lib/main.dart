import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_example/paginable_list_view_builder.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<int> numbers = List.generate(30, (index) => index);

  Future<int> getFutureInteger() async {
    // Uncomment the throw statement to see how I handled the exception
    await Future.delayed(Duration(seconds: 5));
   // throw Exception("This is test Exception");
    int lastNumber = numbers.last;
    return lastNumber + 1;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: PaginableListViewBuilder(
                errorIndicatorWidget: getErrorIndicator,
                itemCount: numbers.length,
                itemBuilder: (BuildContext context, int index) =>
                    ListTile(title: Text(numbers[index].toString())),
                loadMore: () async {
                  int number = await getFutureInteger();
                  setState(() {
                    numbers.add(number);
                  });
                },
                progressIndicatorWidget: getProgressIndicator)));
  }

  Widget getErrorIndicator(String errorLog, void Function() tryAgain) {
    return Container(
        height: 50,
        color: Colors.red,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(errorLog),
              ElevatedButton(onPressed: tryAgain, child: Text("Try Again"))
            ],
          ),
        ));
  }

  Widget getProgressIndicator() =>
      Container(height: 50, child: Center(child: CircularProgressIndicator()));
}
