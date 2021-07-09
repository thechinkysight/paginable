import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'widgets/test_paginable_listview_builder.dart';

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

  setUp(() async {
    scrollController = ScrollController();
  });

  tearDown(() async {
    scrollController.dispose();
  });

  group(
      "The errorIndicatorWidget should return as last item when an exception occurs in the loadMore() function",
      () {
    Exception exception = Exception('This is a test exception');
    testWidgets("Check whether there is a red Container widget",
        (WidgetTester tester) async {
      await tester.pumpWidget(TestPaginableListViewBuilder(
          loadMore: () async {
            throw exception;
          },
          scrollController: scrollController,
          progressIndicatorWidget: progressIndicatorWidget,
          errorIndicatorWidget: errorIndicatorWidget));

      scrollToTheEndOfScrollView(scrollController);

      await tester.pump();

      WidgetPredicate redContainer = (Widget widget) =>
          widget is Container && widget.color == Colors.redAccent;

      expect(find.byWidgetPredicate(redContainer), findsOneWidget);
    });

    testWidgets(
        "Check whether there is an Text widget containing exception log",
        (WidgetTester tester) async {
      await tester.pumpWidget(TestPaginableListViewBuilder(
          loadMore: () async {
            throw exception;
          },
          scrollController: scrollController,
          progressIndicatorWidget: progressIndicatorWidget,
          errorIndicatorWidget: errorIndicatorWidget));

      scrollToTheEndOfScrollView(scrollController);

      await tester.pump();

      final exceptionFinder = find.text(exception.toString());

      expect(exceptionFinder, findsOneWidget);
    });
  });

  group(
      "An empty Container widget should return as last item when the loadMore() function executes without any exceptions",
      () {
    testWidgets(
        "An empty Container widget should return when loadMore() function executes without any exceptions",
        (WidgetTester tester) async {
      await tester.pumpWidget(TestPaginableListViewBuilder(
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
        "An empty Container widget should return when loadMore() function executes after a delay without any exceptions",
        (WidgetTester tester) async {
      await tester.pumpWidget(TestPaginableListViewBuilder(
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
      "Must return the progressIndicatorWidget as last item when the loadMore() function is being executed",
      (WidgetTester tester) async {
    await tester.pumpWidget(TestPaginableListViewBuilder(
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
