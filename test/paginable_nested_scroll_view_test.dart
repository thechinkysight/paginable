import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paginable/paginable.dart';

void main() {
  late ScrollController scrollController;

  setUp(() {
    scrollController = ScrollController();
  });

  tearDown(() {
    scrollController.dispose();
  });

  testWidgets(
      'loadMore() should be called only when we are almost at the end of the scroll while scrolling downwards',
      (WidgetTester tester) async {
    bool hasLoadMoreBeenCalled = false;

    await tester.pumpWidget(TestApp(
        scrollController: scrollController,
        loadMore: () async {
          hasLoadMoreBeenCalled = !hasLoadMoreBeenCalled;
        }));

    scrollController.jumpTo(scrollController.position.maxScrollExtent);

    await tester.pump();

    expect(hasLoadMoreBeenCalled, true);

    scrollController.jumpTo(scrollController.position.maxScrollExtent * .5);

    await tester.pump();

    expect(hasLoadMoreBeenCalled, true);

    scrollController.jumpTo(scrollController.position.maxScrollExtent);

    await tester.pump();

    expect(hasLoadMoreBeenCalled, false);
  });
}

class TestApp extends StatelessWidget {
  final ScrollController scrollController;
  final Future<void> Function() loadMore;
  const TestApp(
      {Key? key, required this.scrollController, required this.loadMore})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
          child: Scaffold(
        body: PaginableNestedScrollView(
          controller: scrollController,
          loadMore: loadMore,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[];
          },
          body: ListView.builder(
            itemCount: 20,
            itemBuilder: (context, index) => ListTile(
              leading: CircleAvatar(child: Text(index.toString())),
            ),
          ),
        ),
      )),
    );
  }
}
