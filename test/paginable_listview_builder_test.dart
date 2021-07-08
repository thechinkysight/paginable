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

  setUp(() async {
    scrollController = ScrollController();
  });

  tearDown(() async {
    scrollController.dispose();
  });

  testWidgets(
      "Must return ErrorIndicatorWidget as last item when an exception occurs in loadMore function",
      (WidgetTester tester) async {
    Exception exception = Exception('This is a test exception');

    await tester.pumpWidget(TestPaginableListViewBuilder(
        loadMore: () async {
          throw exception;
        },
        scrollController: scrollController,
        progressIndicatorWidget: progressIndicatorWidget,
        errorIndicatorWidget: errorIndicatorWidget));

    scrollController.jumpTo(scrollController.position.maxScrollExtent);
    await tester.pump();

    final exceptionFinder = find.text(exception.toString());

    expect(exceptionFinder, findsOneWidget);
  });

  testWidgets(
      "Must return an empty Container widget as last item when execution of loadMore function is completed without any exceptions",
      (WidgetTester tester) async {
    await tester.pumpWidget(TestPaginableListViewBuilder(
        loadMore: () async {},
        scrollController: scrollController,
        progressIndicatorWidget: progressIndicatorWidget,
        errorIndicatorWidget: errorIndicatorWidget));

    scrollController.jumpTo(scrollController.position.maxScrollExtent);
    await tester.pump();

    WidgetPredicate isAnEmptyContainer =
        (Widget widget) => widget is Container && widget.child == null;

    expect(find.byWidgetPredicate(isAnEmptyContainer), findsOneWidget);
  });
}
