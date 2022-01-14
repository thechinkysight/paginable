import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'utils/utils.dart';

/// It is the paginable's version of [NestedScrollView](https://api.flutter.dev/flutter/widgets/NestedScrollView-class.html) and it is used along with [PaginableSliverChildBuilderDelegate](https://pub.dev/packages/paginable#using-paginablecustomscrollview-with-paginablesliverchildbuilderdelegate) to perform pagination.
class PaginableNestedScrollView extends StatefulWidget {
  /// It takes an async function which will be executed when the scroll is almost at the end.
  final Future<void> Function() loadMore;

  // ignore: annotate_overrides, overridden_fields
  final Key? key;
  final List<Widget> Function(BuildContext, bool) headerSliverBuilder;
  final Widget body;
  final bool floatHeaderSlivers;
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController? controller;
  final ScrollPhysics? physics;
  final ScrollBehavior? scrollBehavior;

  /// The slivers to place inside the viewport.
  final DragStartBehavior dragStartBehavior;
  final String? restorationId;
  final Clip clipBehavior;

  /// Creates a [ScrollView] that creates custom scroll effects using body.
  ///
  /// See the [ScrollView] constructor for more details on these arguments.
  const PaginableNestedScrollView({
    this.key,
    required this.loadMore,
    required this.headerSliverBuilder,
    required this.body,
    this.floatHeaderSlivers = false,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.physics,
    this.scrollBehavior,
    this.dragStartBehavior = DragStartBehavior.start,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
  }) : super(key: key);

  @override
  _PaginableNestedScrollViewState createState() =>
      _PaginableNestedScrollViewState();
}

class _PaginableNestedScrollViewState extends State<PaginableNestedScrollView> {
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
              isScrollingDownwards(scrollUpdateNotification) &&
              scrollUpdateNotification.dragDetails?.delta != null) {
            if (!isLoadMoreBeingCalled) {
              performPagination();
            }
          }
          return false;
        },
        child: NestedScrollView(
            key: widget.key,
            headerSliverBuilder: widget.headerSliverBuilder,
            body: widget.body,
            floatHeaderSlivers: widget.floatHeaderSlivers,
            scrollDirection: widget.scrollDirection,
            reverse: widget.reverse,
            controller: widget.controller,
            physics: widget.physics,
            scrollBehavior: widget.scrollBehavior,
            dragStartBehavior: widget.dragStartBehavior,
            restorationId: widget.restorationId,
            clipBehavior: widget.clipBehavior),
      ),
    );
  }
}
