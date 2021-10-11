import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'utils/last_item.dart';

/// It is the paginable's version of [CustomScrollView](https://api.flutter.dev/flutter/widgets/CustomScrollView-class.html) and it is used along with [PaginableSliverChildBuilderDelegate](https://pub.dev/packages/paginable#using-paginablecustomscrollview-with-paginablesliverchildbuilderdelegate) to perform pagination.
class PaginableCustomScrollView extends StatefulWidget {
  /// It takes an async function which will be executed when the scroll is almost at the end.
  final Future<void> Function() loadMore;

  // ignore: annotate_overrides, overridden_fields
  final Key? key;
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController? controller;
  final bool? primary;
  final ScrollPhysics? physics;
  final ScrollBehavior? scrollBehavior;
  final bool shrinkWrap;
  final Key? center;
  final double anchor;
  final double? cacheExtent;

  /// The slivers to place inside the viewport.
  final List<Widget> slivers;
  final int? semanticChildCount;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String? restorationId;
  final Clip clipBehavior;

  /// Creates a [ScrollView] that creates custom scroll effects using slivers.
  ///
  /// See the [ScrollView] constructor for more details on these arguments.
  const PaginableCustomScrollView(
      {this.key,
      this.scrollDirection = Axis.vertical,
      this.reverse = false,
      this.controller,
      this.primary,
      this.physics,
      this.scrollBehavior,
      this.shrinkWrap = false,
      this.center,
      this.anchor = 0.0,
      this.cacheExtent,
      this.slivers = const <Widget>[],
      this.semanticChildCount,
      this.dragStartBehavior = DragStartBehavior.start,
      this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
      this.restorationId,
      this.clipBehavior = Clip.hardEdge,
      required this.loadMore})
      : super(key: key);

  @override
  _PaginableCustomScrollViewState createState() =>
      _PaginableCustomScrollViewState();
}

class _PaginableCustomScrollViewState extends State<PaginableCustomScrollView> {
  ValueNotifier<LastItem> valueNotifier =
      ValueNotifier(LastItem.emptyContainer);

  bool isLoadMoreBeingCalled = false;

  ValueNotifier<Exception> exceptionNotifier = ValueNotifier(Exception());

  void tryAgain() => performPagination();

  bool isAlmostAtTheEndOfTheScroll(
          ScrollUpdateNotification scrollUpdateNotification) =>
      scrollUpdateNotification.metrics.pixels >=
      scrollUpdateNotification.metrics.maxScrollExtent * 0.8;

  bool isScrollingDownwards(
          ScrollUpdateNotification scrollUpdateNotification) =>
      scrollUpdateNotification.scrollDelta! > 0.0;

  Future<void> performPagination() async {
    valueNotifier.value = LastItem.progressIndicator;
    isLoadMoreBeingCalled = true;
    try {
      await widget.loadMore();
      isLoadMoreBeingCalled = false;
      valueNotifier.value = LastItem.emptyContainer;
    } on Exception catch (exception) {
      exceptionNotifier.value = exception;
      valueNotifier.value = LastItem.errorIndicator;
    }
  }

  @override
  void initState() {
    super.initState();
    Provider.debugCheckInvalidValueType = null;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ValueNotifier<LastItem>>.value(value: valueNotifier),
        Provider<ValueNotifier<Exception>>.value(value: exceptionNotifier),
        Provider<void Function()>.value(value: tryAgain)
      ],
      child: NotificationListener<ScrollUpdateNotification>(
        onNotification: (ScrollUpdateNotification scrollUpdateNotification) {
          if (isAlmostAtTheEndOfTheScroll(scrollUpdateNotification) &&
              isScrollingDownwards(scrollUpdateNotification)) {
            if (!isLoadMoreBeingCalled) {
              performPagination();
            }
          }
          return false;
        },
        child: CustomScrollView(
            key: widget.key,
            scrollDirection: widget.scrollDirection,
            reverse: widget.reverse,
            controller: widget.controller,
            primary: widget.primary,
            physics: widget.physics,
            scrollBehavior: widget.scrollBehavior,
            shrinkWrap: widget.shrinkWrap,
            center: widget.center,
            anchor: widget.anchor,
            cacheExtent: widget.cacheExtent,
            slivers: widget.slivers,
            semanticChildCount: widget.semanticChildCount,
            dragStartBehavior: widget.dragStartBehavior,
            keyboardDismissBehavior: widget.keyboardDismissBehavior,
            restorationId: widget.restorationId,
            clipBehavior: widget.clipBehavior),
      ),
    );
  }
}
