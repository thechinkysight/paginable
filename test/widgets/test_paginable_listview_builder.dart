import 'package:flutter/material.dart';
import 'package:paginable/paginable.dart';

class TestPaginableListViewBuilder extends StatelessWidget {
  final List<int> numbers = List.generate(30, (index) => index);
  final ScrollController scrollController;
  final Widget progressIndicatorWidget;
  final Widget Function(Exception exception, void Function() tryAgain)
      errorIndicatorWidget;
  final Future<void> Function() loadMore;

  TestPaginableListViewBuilder(
      {Key? key,
      required this.loadMore,
      required this.scrollController,
      required this.progressIndicatorWidget,
      required this.errorIndicatorWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: PaginableListViewBuilder(
              controller: scrollController,
              errorIndicatorWidget: this.errorIndicatorWidget,
              itemBuilder: (BuildContext context, int index) => ListTile(
                    title: Text(numbers[index].toString()),
                  ),
              itemCount: numbers.length,
              loadMore: this.loadMore,
              progressIndicatorWidget: this.progressIndicatorWidget),
        ),
      ),
    );
  }
}
