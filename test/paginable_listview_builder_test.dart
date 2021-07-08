import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'widgets/test_paginable_listview_builder.dart';

void main() {
  late ScrollController scrollController;

  Widget progressIndicatorWidget = Container(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: Center(child: CircularProgressIndicator()),
  );

  Widget errorIndicatorWidget(exception, tryAgain) => Container(
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

  testWidgets(
      "Must return the errorIndicatorWidget as last item when an exception occurs in the loadMore function",
      (WidgetTester tester) async {
    Exception exception = Exception('This is a test exception');

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

    //TODO: Check whether we can find a Container widget with color property set to Colors.redAccent or not.
  });

  testWidgets(
      "Must return an empty Container widget as last item when execution of loadMore function is completed without any exceptions",
      (WidgetTester tester) async {
    await tester.pumpWidget(TestPaginableListViewBuilder(
        loadMore: () async {},
        scrollController: scrollController,
        progressIndicatorWidget: progressIndicatorWidget,
        errorIndicatorWidget: errorIndicatorWidget));

    scrollToTheEndOfScrollView(scrollController);
    await tester.pump();

    WidgetPredicate isAnEmptyContainer =
        (Widget widget) => widget is Container && widget.child == null;

    expect(find.byWidgetPredicate(isAnEmptyContainer), findsOneWidget);
  });

  testWidgets(
      "Must return the progressIndicatorWidget as last item when the loadMore function is being executed",
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

    final progressIndicatorFinder = find.byWidget(progressIndicatorWidget);

    expect(progressIndicatorFinder, findsOneWidget);
    await tester.pump(Duration(seconds: 3));
    // await tester.pumpAndSettle();
  });
}
