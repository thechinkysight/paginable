import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:paginable/paginable.dart';
import 'package:paginable/src/utils/utils.dart';

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
              child: const Text("Try Again"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
              ),
            )
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
    'Test for build() method',
    () {
      testWidgets(
        'The errorIndicatorWidget should be returned as the last item if an exception occurs in the loadMore() function of the PaginableCustomScrollView',
        (WidgetTester tester) async {
          Exception exception = Exception('This is a test exception');

          await tester.pumpWidget(
            TestAppForBuildMethod(
              scrollController: scrollController,
              progressIndicatorWidget: progressIndicatorWidget,
              errorIndicatorWidget: errorIndicatorWidget,
              loadMore: () async {
                throw exception;
              },
            ),
          );

          scrollToTheEndOfScrollView(scrollController);

          await tester.pump();

          final exceptionFinder = find.text(
            exception.toString(),
          );

          bool isRedContainer(Widget widget) =>
              widget is Container && widget.color == Colors.redAccent;

          expect(exceptionFinder, findsOneWidget);

          expect(find.byWidgetPredicate(isRedContainer), findsOneWidget);
        },
      );

      group(
        'Tests for empty Container widget',
        () {
          testWidgets(
            'The empty Container widget should be the default last item',
            (WidgetTester tester) async {
              await tester.pumpWidget(
                TestAppForBuildMethod(
                  loadMore: () async {},
                  progressIndicatorWidget: progressIndicatorWidget,
                  errorIndicatorWidget: errorIndicatorWidget,
                  scrollController: scrollController,
                  childCount: 5,
                ),
              );

              expect(
                  find.byKey(
                      keyForEmptyContainerWidgetOfPaginableSliverChildBuilderDelegate),
                  findsOneWidget);
            },
          );

          testWidgets(
            'The empty Container widget should be returned as the last item if the loadMore() function of the CustomScrollView executes immediately without any exceptions',
            (WidgetTester tester) async {
              await tester.pumpWidget(
                TestAppForBuildMethod(
                  loadMore: () async {},
                  scrollController: scrollController,
                  progressIndicatorWidget: progressIndicatorWidget,
                  errorIndicatorWidget: errorIndicatorWidget,
                ),
              );

              scrollToTheEndOfScrollView(scrollController);

              await tester.pump();

              expect(
                  find.byKey(
                      keyForEmptyContainerWidgetOfPaginableSliverChildBuilderDelegate),
                  findsOneWidget);
            },
          );

          testWidgets(
            "The empty Container widget should be returned as the last item if the loadMore() function of the CustomScrollView executes after a delay without any exceptions",
            (WidgetTester tester) async {
              await tester.pumpWidget(
                TestAppForBuildMethod(
                  loadMore: () async {
                    await Future.delayed(
                      const Duration(seconds: 3),
                    );
                  },
                  scrollController: scrollController,
                  progressIndicatorWidget: progressIndicatorWidget,
                  errorIndicatorWidget: errorIndicatorWidget,
                ),
              );

              scrollToTheEndOfScrollView(scrollController);

              await tester.pump(
                const Duration(seconds: 3),
              );

              expect(
                  find.byKey(
                      keyForEmptyContainerWidgetOfPaginableSliverChildBuilderDelegate),
                  findsOneWidget);
            },
          );
        },
      );

      testWidgets(
        "The progressIndicatorWidget should be returned as the last item if the loadMore() function of the CustomScrollView is being executed",
        (WidgetTester tester) async {
          await tester.pumpWidget(
            TestAppForBuildMethod(
              loadMore: () async {
                await Future.delayed(
                  const Duration(seconds: 3),
                );
              },
              scrollController: scrollController,
              progressIndicatorWidget: progressIndicatorWidget,
              errorIndicatorWidget: errorIndicatorWidget,
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

  group(
    'Test for separated() method',
    () {
      testWidgets(
        'The errorIndicatorWidget should be returned as the last item if an exception occurs in the loadMore() function of the CustomScrollView',
        (WidgetTester tester) async {
          Exception exception = Exception('This is a test exception');

          await tester.pumpWidget(
            TestAppForSeparatedMethod(
              scrollController: scrollController,
              progressIndicatorWidget: progressIndicatorWidget,
              errorIndicatorWidget: errorIndicatorWidget,
              loadMore: () async {
                throw exception;
              },
            ),
          );

          scrollToTheEndOfScrollView(scrollController);

          await tester.pump();

          final exceptionFinder = find.text(
            exception.toString(),
          );

          bool isRedContainer(Widget widget) =>
              widget is Container && widget.color == Colors.redAccent;

          expect(exceptionFinder, findsOneWidget);

          expect(find.byWidgetPredicate(isRedContainer), findsOneWidget);
        },
      );

      group(
        'Tests for empty Container widget',
        () {
          testWidgets(
            'The empty Container widget should be the default last item',
            (WidgetTester tester) async {
              await tester.pumpWidget(
                TestAppForSeparatedMethod(
                  loadMore: () async {},
                  progressIndicatorWidget: progressIndicatorWidget,
                  errorIndicatorWidget: errorIndicatorWidget,
                  scrollController: scrollController,
                  childCount: 5,
                ),
              );

              expect(
                  find.byKey(
                      keyForEmptyContainerWidgetOfPaginableSliverChildBuilderDelegate),
                  findsOneWidget);
            },
          );

          testWidgets(
            'The empty Container widget should be returned as the last item if the loadMore() function of the CustomScrollView executes immediately without any exceptions',
            (WidgetTester tester) async {
              await tester.pumpWidget(
                TestAppForSeparatedMethod(
                  loadMore: () async {},
                  scrollController: scrollController,
                  progressIndicatorWidget: progressIndicatorWidget,
                  errorIndicatorWidget: errorIndicatorWidget,
                ),
              );

              scrollToTheEndOfScrollView(scrollController);

              await tester.pump();

              expect(
                  find.byKey(
                      keyForEmptyContainerWidgetOfPaginableSliverChildBuilderDelegate),
                  findsOneWidget);
            },
          );

          testWidgets(
            "The empty Container widget should be returned as the last item if the loadMore() function of the CustomScrollView executes after a delay without any exceptions",
            (WidgetTester tester) async {
              await tester.pumpWidget(
                TestAppForSeparatedMethod(
                  loadMore: () async {
                    await Future.delayed(
                      const Duration(seconds: 3),
                    );
                  },
                  scrollController: scrollController,
                  progressIndicatorWidget: progressIndicatorWidget,
                  errorIndicatorWidget: errorIndicatorWidget,
                ),
              );

              scrollToTheEndOfScrollView(scrollController);

              await tester.pump(
                const Duration(seconds: 3),
              );

              expect(
                  find.byKey(
                      keyForEmptyContainerWidgetOfPaginableSliverChildBuilderDelegate),
                  findsOneWidget);
            },
          );
        },
      );

      testWidgets(
        'There should be childCount - 1 separators',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            TestAppForSeparatedMethod(
              scrollController: scrollController,
              progressIndicatorWidget: progressIndicatorWidget,
              errorIndicatorWidget: errorIndicatorWidget,
              loadMore: () async {},
              childCount: 5,
            ),
          );

          expect(find.byType(Divider), findsNWidgets(4));
        },
      );

      testWidgets(
        "The progressIndicatorWidget should be returned as the last item if the loadMore() function of the CustomScrollView is being executed",
        (WidgetTester tester) async {
          await tester.pumpWidget(
            TestAppForSeparatedMethod(
              loadMore: () async {
                await Future.delayed(
                  const Duration(seconds: 3),
                );
              },
              scrollController: scrollController,
              progressIndicatorWidget: progressIndicatorWidget,
              errorIndicatorWidget: errorIndicatorWidget,
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

class TestAppForBuildMethod extends StatelessWidget {
  final int? childCount;
  final ScrollController scrollController;
  final Widget progressIndicatorWidget;
  final Widget Function(Exception exception, void Function() tryAgain)
      errorIndicatorWidget;
  final Future<void> Function() loadMore;

  const TestAppForBuildMethod({
    Key? key,
    required this.scrollController,
    required this.progressIndicatorWidget,
    required this.errorIndicatorWidget,
    required this.loadMore,
    this.childCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: PaginableCustomScrollView(
            controller: scrollController,
            loadMore: loadMore,
            slivers: [
              const SliverAppBar(
                title: Text('Build Method'),
              ),
              SliverList(
                delegate: PaginableSliverChildBuilderDelegate(
                        (context, index) => ListTile(
                              leading:
                                  CircleAvatar(child: Text(index.toString())),
                            ),
                        childCount: childCount == null ? 30 : childCount!,
                        progressIndicatorWidget: progressIndicatorWidget,
                        errorIndicatorWidget: errorIndicatorWidget)
                    .build(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TestAppForSeparatedMethod extends StatelessWidget {
  final int? childCount;
  final ScrollController scrollController;
  final Widget progressIndicatorWidget;
  final Widget Function(Exception exception, void Function() tryAgain)
      errorIndicatorWidget;
  final Future<void> Function() loadMore;

  const TestAppForSeparatedMethod({
    Key? key,
    required this.scrollController,
    required this.progressIndicatorWidget,
    required this.errorIndicatorWidget,
    required this.loadMore,
    this.childCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: PaginableCustomScrollView(
            controller: scrollController,
            loadMore: loadMore,
            slivers: [
              const SliverAppBar(
                title: Text('Separated Method'),
              ),
              SliverList(
                delegate: PaginableSliverChildBuilderDelegate(
                        (context, index) => ListTile(
                              leading: CircleAvatar(
                                child: Text(
                                  index.toString(),
                                ),
                              ),
                            ),
                        childCount: childCount == null ? 30 : childCount!,
                        progressIndicatorWidget: progressIndicatorWidget,
                        errorIndicatorWidget: errorIndicatorWidget)
                    .separated(
                  (context, index) => const Divider(
                    thickness: 2.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
