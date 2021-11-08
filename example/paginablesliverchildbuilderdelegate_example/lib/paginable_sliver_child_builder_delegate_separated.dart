import 'package:flutter/material.dart';
import 'package:paginable/paginable.dart';

import 'utils.dart';

class PaginabelSliverChildBuilderDelegatedSeparated extends StatefulWidget {
  const PaginabelSliverChildBuilderDelegatedSeparated({Key? key})
      : super(key: key);

  @override
  State<PaginabelSliverChildBuilderDelegatedSeparated> createState() =>
      _PaginabelSliverChildBuilderDelegatedSeparatedState();
}

class _PaginabelSliverChildBuilderDelegatedSeparatedState
    extends State<PaginabelSliverChildBuilderDelegatedSeparated> {
  @override
  Widget build(BuildContext context) {
    return PaginableCustomScrollView(
      loadMore: () async {
        // throw Exception('This is test exception');
        await fetchFiveMore();
        if (mounted) {
          setState(() {});
        }
      },
      slivers: [
        const SliverAppBar(
          floating: true,
          title: Text('Example App'),
        ),
        SliverList(
          delegate: PaginableSliverChildBuilderDelegate(
            (context, index) => ListTile(
              leading: CircleAvatar(
                child: Text(
                  numbers.elementAt(index).toString(),
                ),
              ),
            ),
            childCount: numbers.length,
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
                      backgroundColor: MaterialStateProperty.all(Colors.green),
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
          ).separated(
            (context, index) => const Divider(
              thickness: 1.2,
            ),
          ),
        ),
      ],
    );
  }
}
