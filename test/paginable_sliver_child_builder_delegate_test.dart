import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:paginable/paginable.dart';

void main() {
  late ScrollController scrollController;

  Widget progressIndicatorWidget = Container(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: Center(child: CircularProgressIndicator()),
  );

  Widget errorIndicatorWidget(Exception exception, void Function() tryAgain) =>
      Container(
          color: Colors.redAccent,
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(exception.toString()),
              ElevatedButton(
                onPressed: tryAgain,
                child: Text("Try Again"),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green)),
              )
            ],
          ));

  void scrollToTheEndOfScrollView(ScrollController scrollController) {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  setUp(() {
    scrollController = ScrollController();
  });

  tearDown(() {
    scrollController.dispose();
  });

  testWidgets(
      'The errorIndicatorWidget should return as last item when an exception occurs in the loadMore() function of the CustomScrollView',
      (WidgetTester tester) async {
    Exception exception = Exception('This is a test exception');
    await tester.pumpWidget(TestApp(
        scrollController: scrollController,
        progressIndicatorWidget: progressIndicatorWidget,
        errorIndicatorWidget: errorIndicatorWidget,
        loadMore: () async {
          throw exception;
        }));

    scrollToTheEndOfScrollView(scrollController);

    await tester.pump();

    final exceptionFinder = find.text(exception.toString());
    WidgetPredicate redContainer = (Widget widget) =>
        widget is Container && widget.color == Colors.redAccent;

    expect(exceptionFinder, findsOneWidget);
    expect(find.byWidgetPredicate(redContainer), findsOneWidget);
  });

  group(
      'An empty Container widget should return as last item when the loadMore() function of the CustomScrollView executes without any exceptions',
      () {
    testWidgets(
        'An empty Container widget should return when loadMore() function of the CustomScrollView executes immediately without any exceptions',
        (WidgetTester tester) async {
      await tester.pumpWidget(TestApp(
          loadMore: () async {},
          scrollController: scrollController,
          progressIndicatorWidget: progressIndicatorWidget,
          errorIndicatorWidget: errorIndicatorWidget));

      scrollToTheEndOfScrollView(scrollController);
      await tester.pump();

      WidgetPredicate emptyContainer =
          (Widget widget) => widget is Container && widget.child == null;

      expect(find.byWidgetPredicate(emptyContainer), findsOneWidget);
    });

    testWidgets(
        "An empty Container widget should return when loadMore() function of the CustomScrollView executes after a delay without any exceptions",
        (WidgetTester tester) async {
      await tester.pumpWidget(TestApp(
          loadMore: () async {
            await Future.delayed(Duration(seconds: 3));
          },
          scrollController: scrollController,
          progressIndicatorWidget: progressIndicatorWidget,
          errorIndicatorWidget: errorIndicatorWidget));

      scrollToTheEndOfScrollView(scrollController);
      await tester.pump(Duration(seconds: 3));

      WidgetPredicate emptyContainer =
          (Widget widget) => widget is Container && widget.child == null;

      expect(find.byWidgetPredicate(emptyContainer), findsOneWidget);
    });
  });

  testWidgets(
      "The progressIndicatorWidget should return as last item when the loadMore() function of the CustomScrollView is being executed",
      (WidgetTester tester) async {
    await tester.pumpWidget(TestApp(
        loadMore: () async {
          await Future.delayed(Duration(seconds: 3));
        },
        scrollController: scrollController,
        progressIndicatorWidget: progressIndicatorWidget,
        errorIndicatorWidget: errorIndicatorWidget));

    scrollToTheEndOfScrollView(scrollController);
    await tester.pump();

    final progressIndicatorWidgetFinder =
        find.byWidget(progressIndicatorWidget);

    expect(progressIndicatorWidgetFinder, findsOneWidget);
    await tester.pump(Duration(seconds: 3));
    // await tester.pumpAndSettle();
  });
}

class TestApp extends StatelessWidget {
  final List<int> numbers = List.generate(30, (index) => index);
  final ScrollController scrollController;
  final Widget progressIndicatorWidget;
  final Widget Function(Exception exception, void Function() tryAgain)
      errorIndicatorWidget;
  final Future<void> Function() loadMore;

  TestApp(
      {Key? key,
      required this.scrollController,
      required this.progressIndicatorWidget,
      required this.errorIndicatorWidget,
      required this.loadMore})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
          child: Scaffold(
        body: PaginableCustomScrollView(
          controller: scrollController,
          loadMore: loadMore,
          slivers: [
            SliverList(
                delegate: PaginableSliverChildBuilderDelegate(
                        (context, index) => ListTile(
                              leading: CircleAvatar(
                                  child: Text(numbers[index].toString())),
                            ),
                        childCount: numbers.length,
                        progressIndicatorWidget: progressIndicatorWidget,
                        errorIndicatorWidget: errorIndicatorWidget)
                    .build())
          ],
        ),
      )),
    );
  }
}
