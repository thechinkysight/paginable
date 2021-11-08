import 'package:flutter/material.dart';
import 'package:paginable/paginable.dart';

import 'utils.dart';

class PaginableListViewSeparated extends StatefulWidget {
  const PaginableListViewSeparated({Key? key}) : super(key: key);

  @override
  _PaginableListViewSeparatedState createState() =>
      _PaginableListViewSeparatedState();
}

class _PaginableListViewSeparatedState
    extends State<PaginableListViewSeparated> {
  @override
  Widget build(BuildContext context) {
    return PaginableListView.separated(
      loadMore: () async {
        // throw Exception('This is a test exception');
        await fetchFiveMore();
        if (mounted) {
          setState(() {});
        }
      },
      progressIndicatorWidget: const SizedBox(
        height: 100,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
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
                backgroundColor: MaterialStateProperty.all(
                  Colors.green,
                ),
              ),
              onPressed: tryAgain,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
      itemBuilder: (context, index) => ListTile(
        leading: CircleAvatar(
          child: Text(
            numbers.elementAt(index).toString(),
          ),
        ),
      ),
      separatorBuilder: (context, index) => const Divider(
        thickness: 1.2,
      ),
      itemCount: numbers.length,
    );
  }
}
