import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'utils/custom_keys.dart';
import 'utils/last_item.dart';
import 'utils/scroll_position.dart';

/// It is the paginable's version of [ListView](https://api.flutter.dev/flutter/widgets/ListView-class.html),
/// which contains only two constructors: builder() & separated()
class PaginableListView extends StatefulWidget {
  final bool _isListViewSeparated;

  final Axis scrollDirection;
  final bool reverse;
  final ScrollController? controller;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double? cacheExtent;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String? restorationId;
  final Clip clipBehavior;

  final IndexedWidgetBuilder? separatorBuilder;

  final double? itemExtent;
  final Widget? prototypeItem;
  final int? semanticChildCount;

  /// It takes an async function which will be executed when the scroll is almost at the end.
  final Future<void> Function() loadMore;

  /// It takes a widget which will be displayed at the bottom of the scrollview to indicate the user that
  /// the async function we passed to the `loadMore` parameter is being executed.
  final Widget progressIndicatorWidget;

  /// It takes a function which contains two parameters, one being of type `Exception` and other of type
  /// `Function()`. It returns a widget which will be displayed at the bottom of the scrollview when an
  /// exception occurs in the async function which we passed to the `loadMore` parameter.
  ///
  /// The parameter with type `Exception` will contain the exception which occured while executing the
  /// function passed to the parameter `loadMore` if exception occured, and the parameter with type `Function()`
  /// will contain the same function which we passed to the `loadMore` parameter.
  final Widget Function(Exception exception, void Function() tryAgain)
      errorIndicatorWidget;

  // ignore: unused_element
  const PaginableListView._(
      this._isListViewSeparated,
      this.scrollDirection,
      this.reverse,
      this.controller,
      this.primary,
      this.physics,
      this.shrinkWrap,
      this.padding,
      this.itemBuilder,
      this.itemCount,
      this.addAutomaticKeepAlives,
      this.addRepaintBoundaries,
      this.addSemanticIndexes,
      this.cacheExtent,
      this.dragStartBehavior,
      this.keyboardDismissBehavior,
      this.restorationId,
      this.clipBehavior,
      this.separatorBuilder,
      this.itemExtent,
      this.prototypeItem,
      this.semanticChildCount,
      this.loadMore,
      this.progressIndicatorWidget,
      this.errorIndicatorWidget);

  /// It is the paginable's version of [ListView.builder()](https://api.flutter.dev/flutter/widgets/ListView/ListView.builder.html)
  const PaginableListView.builder({
    Key? key,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.itemExtent,
    this.prototypeItem,
    required this.loadMore,
    required this.progressIndicatorWidget,
    required this.errorIndicatorWidget,
    required this.itemBuilder,
    required this.itemCount,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.semanticChildCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
  })  : _isListViewSeparated = false,
        separatorBuilder = null,
        super(key: key);

  /// It is the paginable's version of [ListView.separated()](https://api.flutter.dev/flutter/widgets/ListView/ListView.separated.html)
  const PaginableListView.separated({
    Key? key,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    required this.loadMore,
    required this.progressIndicatorWidget,
    required this.errorIndicatorWidget,
    required this.itemBuilder,
    required this.separatorBuilder,
    required this.itemCount,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
  })  : _isListViewSeparated = true,
        itemExtent = null,
        prototypeItem = null,
        semanticChildCount = null,
        super(key: key);

  @override
  _PaginableListViewState createState() => _PaginableListViewState();
}

class _PaginableListViewState extends State<PaginableListView> {
  late ValueNotifier<LastItem> valueNotifier;

  late bool isValueNotifierDisposed;

  late bool isLoadMoreBeingCalled;

  late Exception exception;

  void tryAgain() => performPagination();

  Future<void> performPagination() async {
    valueNotifier.value = LastItem.progressIndicator;
    isLoadMoreBeingCalled = true;
    try {
      await widget.loadMore();
      isLoadMoreBeingCalled = false;
      if (!isValueNotifierDisposed) {
        valueNotifier.value = LastItem.emptyContainer;
      }
    } on Exception catch (exception) {
      this.exception = exception;
      if (!isValueNotifierDisposed) {
        valueNotifier.value = LastItem.errorIndicator;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    valueNotifier = ValueNotifier(LastItem.emptyContainer);
    isValueNotifierDisposed = false;
    isLoadMoreBeingCalled = false;
  }

  @override
  void dispose() {
    valueNotifier.dispose();
    isValueNotifierDisposed = true;
    super.dispose();
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
      child: widget._isListViewSeparated
          ? ListView.separated(
              scrollDirection: widget.scrollDirection,
              reverse: widget.reverse,
              controller: widget.controller,
              primary: widget.primary,
              physics: widget.physics,
              shrinkWrap: widget.shrinkWrap,
              padding: widget.padding,
              itemBuilder: (context, index) {
                if (index == widget.itemCount) {
                  return ValueListenableBuilder<LastItem>(
                    valueListenable: valueNotifier,
                    builder: (context, value, child) {
                      if (value == LastItem.emptyContainer) {
                        return Container(
                          key: keyForEmptyContainerWidgetOfPaginableListView,
                        );
                      } else if (value == LastItem.errorIndicator) {
                        return widget.errorIndicatorWidget(exception, tryAgain);
                      }
                      return widget.progressIndicatorWidget;
                    },
                  );
                }
                return widget.itemBuilder(context, index);
              },
              separatorBuilder: (context, index) {
                if (index == widget.itemCount - 1) {
                  return Container();
                }
                return widget.separatorBuilder!(context, index);
              },
              itemCount: widget.itemCount + 1,
              addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
              addRepaintBoundaries: widget.addRepaintBoundaries,
              addSemanticIndexes: widget.addSemanticIndexes,
              cacheExtent: widget.cacheExtent,
              dragStartBehavior: widget.dragStartBehavior,
              keyboardDismissBehavior: widget.keyboardDismissBehavior,
              restorationId: widget.restorationId,
              clipBehavior: widget.clipBehavior,
            )
          : ListView.builder(
              scrollDirection: widget.scrollDirection,
              reverse: widget.reverse,
              controller: widget.controller,
              primary: widget.primary,
              physics: widget.physics,
              shrinkWrap: widget.shrinkWrap,
              padding: widget.padding,
              itemExtent: widget.itemExtent,
              prototypeItem: widget.prototypeItem,
              itemBuilder: (context, index) {
                if (index == widget.itemCount) {
                  return ValueListenableBuilder<LastItem>(
                    valueListenable: valueNotifier,
                    builder: (context, value, child) {
                      if (value == LastItem.emptyContainer) {
                        return Container(
                          key: keyForEmptyContainerWidgetOfPaginableListView,
                        );
                      } else if (value == LastItem.errorIndicator) {
                        return widget.errorIndicatorWidget(exception, tryAgain);
                      }
                      return widget.progressIndicatorWidget;
                    },
                  );
                }
                return widget.itemBuilder(context, index);
              },
              itemCount: widget.itemCount + 1,
              addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
              addRepaintBoundaries: widget.addRepaintBoundaries,
              addSemanticIndexes: widget.addSemanticIndexes,
              cacheExtent: widget.cacheExtent,
              semanticChildCount: widget.semanticChildCount,
              dragStartBehavior: widget.dragStartBehavior,
              keyboardDismissBehavior: widget.keyboardDismissBehavior,
              restorationId: widget.restorationId,
              clipBehavior: widget.clipBehavior,
            ),
    );
  }
}
