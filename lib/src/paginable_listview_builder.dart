import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'utils/last_item.dart';
import 'utils/scroll_position.dart';

/// It is paginable's version of [ListView.builder](https://api.flutter.dev/flutter/widgets/ListView/ListView.builder.html)
class PaginableListViewBuilder extends StatefulWidget {
  final double? itemExtent;

  /// It takes a function which contains two parameters, one being of type `Exception` and other being a
  /// `Function()`, returning a widget which will be displayed at the bottom of the scrollview when an
  /// exception occurs in the async function which we passed to the `loadMore` parameter.
  ///
  /// The parameter with type `Exception` will contain the exception which occured while executing the
  /// function passed to the parameter `loadMore` if exception occured, and the parameter with type `Function()`
  /// will contain the same function which we passed to the `loadMore` parameter.
  final Widget Function(Exception exception, void Function() tryAgain)
      errorIndicatorWidget;

  /// It takes a widget which will be displayed at the bottom of the scrollview to indicate the user that
  /// the async function we passed to the `loadMore` parameter is being executed.
  final Widget progressIndicatorWidget;
  final Widget Function(BuildContext context, int index) itemBuilder;

  /// It takes an async function which will be executed when the scroll is almost at the end.
  final Future<void> Function() loadMore;
  final ScrollController? controller;
  final Axis scrollDirection;
  final bool reverse;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;
  final int itemCount;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double? cacheExtent;
  final int? semanticChildCount;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String? restorationId;
  final Clip clipBehavior;

  /// Creates a scrollable, linear array of widgets that are created on demand.
  const PaginableListViewBuilder(
      {Key? key,
      this.scrollDirection = Axis.vertical,
      this.reverse = false,
      this.primary,
      this.physics,
      this.shrinkWrap = false,
      this.padding,
      this.itemExtent,
      required this.loadMore,
      required this.errorIndicatorWidget,
      required this.progressIndicatorWidget,
      required this.itemBuilder,
      required this.itemCount,
      this.controller,
      this.addAutomaticKeepAlives = true,
      this.addRepaintBoundaries = true,
      this.addSemanticIndexes = true,
      this.cacheExtent,
      this.semanticChildCount,
      this.dragStartBehavior = DragStartBehavior.start,
      this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
      this.restorationId,
      this.clipBehavior = Clip.hardEdge})
      : super(key: key);

  @override
  _PaginableListViewBuilderState createState() =>
      _PaginableListViewBuilderState();
}

class _PaginableListViewBuilderState extends State<PaginableListViewBuilder> {
  ValueNotifier<LastItem> valueNotifier =
      ValueNotifier(LastItem.emptyContainer);

  late Exception exception;

  bool isLoadMoreBeingCalled = false;

  void tryAgain() => performPagination();

  Future<void> performPagination() async {
    valueNotifier.value = LastItem.progressIndicator;
    isLoadMoreBeingCalled = true;
    try {
      await widget.loadMore();
      isLoadMoreBeingCalled = false;
      valueNotifier.value = LastItem.emptyContainer;
    } on Exception catch (exception) {
      this.exception = exception;
      valueNotifier.value = LastItem.errorIndicator;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollUpdateNotification>(
        onNotification: (ScrollUpdateNotification scrollUpdateNotification) {
          if (isAlmostAtTheEndOfTheScroll(scrollUpdateNotification) &&
              isScrollingDownwards(scrollUpdateNotification)) {
            if (!isLoadMoreBeingCalled) {
              performPagination();
            }
          }
          return false;
        },
        child: ListView.builder(
            key: widget.key,
            scrollDirection: widget.scrollDirection,
            reverse: widget.reverse,
            controller: widget.controller,
            primary: widget.primary,
            physics: widget.physics,
            shrinkWrap: widget.shrinkWrap,
            padding: widget.padding,
            itemExtent: widget.itemExtent,
            itemCount: widget.itemCount + 1,
            itemBuilder: (context, index) {
              if (index == widget.itemCount) {
                return ValueListenableBuilder<LastItem>(
                    valueListenable: valueNotifier,
                    builder: (context, value, child) {
                      if (value == LastItem.emptyContainer) {
                        return Container();
                      } else if (value == LastItem.errorIndicator) {
                        return widget.errorIndicatorWidget(exception, tryAgain);
                      }
                      return widget.progressIndicatorWidget;
                    });
              }
              return widget.itemBuilder(context, index);
            },
            addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
            addRepaintBoundaries: widget.addRepaintBoundaries,
            addSemanticIndexes: widget.addSemanticIndexes,
            cacheExtent: widget.cacheExtent,
            semanticChildCount: widget.semanticChildCount,
            dragStartBehavior: widget.dragStartBehavior,
            keyboardDismissBehavior: widget.keyboardDismissBehavior,
            restorationId: widget.restorationId,
            clipBehavior: widget.clipBehavior));
  }
}
