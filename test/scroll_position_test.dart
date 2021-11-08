import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paginable/src/utils/scroll_position.dart';

void main() {
  late ScrollController scrollController;

  setUp(() {
    scrollController = ScrollController();
  });

  tearDown(() {
    scrollController.dispose();
  });

  testWidgets(
    'isScrollingDownwards() should only return true when we are scrolling downwards',
    (WidgetTester tester) async {
      late bool isScrollingDownwardsTest;

      await tester.pumpWidget(
        TestApp(
          scrollController: scrollController,
          onNotification: (scrollUpdateNotification) {
            isScrollingDownwardsTest =
                isScrollingDownwards(scrollUpdateNotification);

            return true;
          },
        ),
      );

      scrollController.jumpTo(scrollController.position.maxScrollExtent * .8);

      await tester.pump();

      expect(isScrollingDownwardsTest, true);

      scrollController.jumpTo(scrollController.position.maxScrollExtent * .1);

      await tester.pump();

      expect(isScrollingDownwardsTest, false);
    },
  );

  testWidgets(
    'isAlmostAtTheEndOfTheScroll() should only return true when we are at 80% or more of the max scroll',
    (WidgetTester tester) async {
      late bool isAlmostAtTheEndOfTheScrollTest;

      await tester.pumpWidget(
        TestApp(
          scrollController: scrollController,
          onNotification: (scrollUpdateNotification) {
            isAlmostAtTheEndOfTheScrollTest =
                isAlmostAtTheEndOfTheScroll(scrollUpdateNotification);
            return true;
          },
        ),
      );

      scrollController.jumpTo(scrollController.position.maxScrollExtent * .9);

      await tester.pump();

      expect(isAlmostAtTheEndOfTheScrollTest, true);

      scrollController.jumpTo(scrollController.position.maxScrollExtent * .7);

      await tester.pump();

      expect(isAlmostAtTheEndOfTheScrollTest, false);

      scrollController.jumpTo(scrollController.position.maxScrollExtent * .8);

      await tester.pump();

      expect(isAlmostAtTheEndOfTheScrollTest, true);
    },
  );
}

class TestApp extends StatelessWidget {
  final bool Function(ScrollUpdateNotification scrollUpdateNotification)
      onNotification;

  final ScrollController scrollController;
  const TestApp(
      {Key? key, required this.scrollController, required this.onNotification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: NotificationListener<ScrollUpdateNotification>(
            onNotification: onNotification,
            child: ListView.builder(
              controller: scrollController,
              itemCount: 20,
              itemBuilder: (context, index) => ListTile(
                title: Text(index.toString()),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
