import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paginable/src/paginable_listview.dart';
import 'package:paginable/src/utils/custom_keys.dart';

void main() {
  late ScrollController scrollController;

  Widget progressIndicatorWidget = Container(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: const Center(
      child: CircularProgressIndicator(),
    ),
  );

  Widget errorIndicatorWidget(Exception exception, void Function() tryAgain) =>
      Container(
        color: Colors.redAccent,
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              exception.toString(),
            ),
            ElevatedButton(
              onPressed: tryAgain,
              child: const Text(
                "Try Again",
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
              ),
            ),
          ],
        ),
      );

  void scrollToTheEndOfScrollView(ScrollController scrollController) {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  setUp(() {
    scrollController = ScrollController();
  });

  tearDown(() {
    scrollController.dispose();
  });
  group(
    'Tests for builder constructor',
    () {
      testWidgets(
        'The errorIndicatorWidget should be returned as the last item if an exception occurs in the loadMore() function',
        (WidgetTester tester) async {
          Exception exception = Exception('This is a test exception');

          await tester.pumpWidget(
            TestAppForBuilderConstructor(
              scrollController: scrollController,
              progressIndicatorWidget: progressIndicatorWidget,
              errorIndicatorWidget: errorIndicatorWidget,
              loadMore: () async => throw exception,
            ),
          );

          scrollToTheEndOfScrollView(scrollController);

          await tester.pump();

          final exceptionFinder = find.text(exception.toString());

          bool isErrorIndicatorWidget(Widget widget) =>
              widget is Container &&
              widget.color == Colors.redAccent &&
              widget.child is Row;

          expect(exceptionFinder, findsOneWidget);

          expect(
              find.byWidgetPredicate(isErrorIndicatorWidget), findsOneWidget);
        },
      );

      group(
        'Tests for empty Container widget',
        () {
          testWidgets(
            'The empty Container widget should be the default last item',
            (WidgetTester tester) async {
              await tester.pumpWidget(
                TestAppForBuilderConstructor(
                  loadMore: () async {},
                  progressIndicatorWidget: progressIndicatorWidget,
                  errorIndicatorWidget: errorIndicatorWidget,
                  itemCount: 5,
                ),
              );

              expect(find.byKey(keyForEmptyContainerWidgetOfPaginableListView),
                  findsOneWidget);
            },
          );

          testWidgets(
            'The empty Container widget should be returned as the last item if the loadMore() function executes after a delay without any exceptions',
            (WidgetTester tester) async {
              await tester.pumpWidget(
                TestAppForBuilderConstructor(
                  loadMore: () async {
                    await Future.delayed(
                      const Duration(seconds: 3),
                    );
                  },
                  progressIndicatorWidget: progressIndicatorWidget,
                  errorIndicatorWidget: errorIndicatorWidget,
                  scrollController: scrollController,
                ),
              );
              scrollToTheEndOfScrollView(scrollController);

              await tester.pump(
                const Duration(seconds: 3),
              );

              expect(find.byKey(keyForEmptyContainerWidgetOfPaginableListView),
                  findsOneWidget);
            },
          );

          testWidgets(
            'The empty Container widget should be returned as the last item if loadMore() function executes immediately without any exceptions',
            (WidgetTester tester) async {
              await tester.pumpWidget(
                TestAppForBuilderConstructor(
                  loadMore: () async {},
                  scrollController: scrollController,
                  progressIndicatorWidget: progressIndicatorWidget,
                  errorIndicatorWidget: errorIndicatorWidget,
                ),
              );
              scrollToTheEndOfScrollView(scrollController);

              await tester.pump();

              expect(find.byKey(keyForEmptyContainerWidgetOfPaginableListView),
                  findsOneWidget);
            },
          );
        },
      );

      testWidgets(
        'The progressIndicatorWidget should be returned as the last item if the loadMore() function is being executed',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            TestAppForBuilderConstructor(
              scrollController: scrollController,
              progressIndicatorWidget: progressIndicatorWidget,
              errorIndicatorWidget: errorIndicatorWidget,
              loadMore: () async {
                await Future.delayed(
                  const Duration(seconds: 3),
                );
              },
            ),
          );

          scrollToTheEndOfScrollView(scrollController);

          await tester.pump();

          expect(find.byWidget(progressIndicatorWidget), findsOneWidget);

          await tester.pump(
            const Duration(seconds: 3),
          );

          // await tester.pumpAndSettle();
        },
      );
    },
  );

  group(
    'Test for separate constructor',
    () {
      testWidgets(
        'The errorIndicatorWidget should be returned as the last item if an exception occurs in the loadMore() function',
        (WidgetTester tester) async {
          Exception exception = Exception('This is a test exception');

          await tester.pumpWidget(
            TestAppForSeparatedConstructor(
              scrollController: scrollController,
              progressIndicatorWidget: progressIndicatorWidget,
              errorIndicatorWidget: errorIndicatorWidget,
              loadMore: () async => throw exception,
            ),
          );

          scrollToTheEndOfScrollView(scrollController);

          await tester.pump();

          final exceptionFinder = find.text(exception.toString());

          bool isErrorIndicatorWidget(Widget widget) =>
              widget is Container &&
              widget.color == Colors.redAccent &&
              widget.child is Row;

          expect(exceptionFinder, findsOneWidget);

          expect(
              find.byWidgetPredicate(isErrorIndicatorWidget), findsOneWidget);
        },
      );

      testWidgets(
        'separatorBuilder should not built a separator widget above the last item',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            TestAppForSeparatedConstructor(
              itemCount: 5,
              scrollController: scrollController,
              progressIndicatorWidget: progressIndicatorWidget,
              errorIndicatorWidget: errorIndicatorWidget,
              loadMore: () async {},
            ),
          );

          expect(find.byType(Divider), findsNWidgets(4));
        },
      );

      group(
        'Tests for empty Container widget',
        () {
          testWidgets(
            'The empty Container widget should be the default last item',
            (WidgetTester tester) async {
              await tester.pumpWidget(
                TestAppForSeparatedConstructor(
                    loadMore: () async {},
                    progressIndicatorWidget: progressIndicatorWidget,
                    errorIndicatorWidget: errorIndicatorWidget,
                    itemCount: 5),
              );

              expect(find.byKey(keyForEmptyContainerWidgetOfPaginableListView),
                  findsOneWidget);
            },
          );

          testWidgets(
            'The empty Container widget should be returned as the last item if the loadMore() function executes after a delay without any exceptions',
            (WidgetTester tester) async {
              await tester.pumpWidget(
                TestAppForSeparatedConstructor(
                  loadMore: () async {
                    await Future.delayed(
                      const Duration(seconds: 3),
                    );
                  },
                  progressIndicatorWidget: progressIndicatorWidget,
                  errorIndicatorWidget: errorIndicatorWidget,
                  scrollController: scrollController,
                ),
              );
              scrollToTheEndOfScrollView(scrollController);

              await tester.pump(
                const Duration(seconds: 3),
              );

              expect(find.byKey(keyForEmptyContainerWidgetOfPaginableListView),
                  findsOneWidget);
            },
          );

          testWidgets(
            'The empty Container widget should be returned as the last item if loadMore() function executes immediately without any exceptions',
            (WidgetTester tester) async {
              await tester.pumpWidget(
                TestAppForSeparatedConstructor(
                  loadMore: () async {},
                  scrollController: scrollController,
                  progressIndicatorWidget: progressIndicatorWidget,
                  errorIndicatorWidget: errorIndicatorWidget,
                ),
              );
              scrollToTheEndOfScrollView(scrollController);

              await tester.pump();

              expect(find.byKey(keyForEmptyContainerWidgetOfPaginableListView),
                  findsOneWidget);
            },
          );
        },
      );

      testWidgets(
        'The progressIndicatorWidget should be returned as the last item if the loadMore() function is being executed',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            TestAppForSeparatedConstructor(
              scrollController: scrollController,
              progressIndicatorWidget: progressIndicatorWidget,
              errorIndicatorWidget: errorIndicatorWidget,
              loadMore: () async {
                await Future.delayed(
                  const Duration(seconds: 3),
                );
              },
            ),
          );

          scrollToTheEndOfScrollView(scrollController);

          await tester.pump();

          final progressIndicatorWidgetFinder =
              find.byWidget(progressIndicatorWidget);

          expect(progressIndicatorWidgetFinder, findsOneWidget);

          await tester.pump(
            const Duration(seconds: 3),
          );

          // await tester.pumpAndSettle();
        },
      );
    },
  );
}

class TestAppForBuilderConstructor extends StatelessWidget {
  final ScrollController? scrollController;
  final Widget progressIndicatorWidget;
  final Widget Function(Exception, void Function()) errorIndicatorWidget;
  final Future<void> Function() loadMore;
  final int itemCount;

  const TestAppForBuilderConstructor({
    Key? key,
    this.scrollController,
    required this.progressIndicatorWidget,
    required this.errorIndicatorWidget,
    required this.loadMore,
    this.itemCount = 30,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: PaginableListView.builder(
            controller: scrollController,
            progressIndicatorWidget: progressIndicatorWidget,
            errorIndicatorWidget: errorIndicatorWidget,
            loadMore: loadMore,
            itemBuilder: (context, index) => ListTile(
              title: Text(
                index.toString(),
              ),
            ),
            itemCount: itemCount,
          ),
        ),
      ),
    );
  }
}

class TestAppForSeparatedConstructor extends StatelessWidget {
  final ScrollController? scrollController;
  final Widget progressIndicatorWidget;
  final Widget Function(Exception, void Function()) errorIndicatorWidget;
  final Future<void> Function() loadMore;
  final int itemCount;

  const TestAppForSeparatedConstructor(
      {Key? key,
      required this.loadMore,
      required this.progressIndicatorWidget,
      required this.errorIndicatorWidget,
      this.itemCount = 30,
      this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: PaginableListView.separated(
            controller: scrollController,
            loadMore: loadMore,
            progressIndicatorWidget: progressIndicatorWidget,
            errorIndicatorWidget: errorIndicatorWidget,
            itemBuilder: (context, index) => ListTile(
              title: Text(index.toString()),
            ),
            separatorBuilder: (context, index) => const Divider(
              thickness: 1.5,
              color: Colors.black,
            ),
            itemCount: itemCount,
          ),
        ),
      ),
    );
  }
}
