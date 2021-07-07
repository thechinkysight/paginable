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
      "Must return ErrorIndicatorWidget when an exception occurs in loadMore function",
      (WidgetTester tester) async {
    Exception exception = Exception('This is a test exception');

    await tester.pumpWidget(TestPaginableListViewBuilder(
        scrollController: scrollController,
        progressIndicatorWidget: progressIndicatorWidget,
        loadMore: () async {
          throw exception;
        },
        errorIndicatorWidget: errorIndicatorWidget));

    scrollController.jumpTo(scrollController.position.maxScrollExtent);
    await tester.pump();

    final exceptionFinder = find.text(exception.toString());

    expect(exceptionFinder, findsOneWidget);
  });
}
