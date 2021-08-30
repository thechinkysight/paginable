import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'utils/last_item.dart';
import 'utils/scroll_position.dart';

class PaginableListViewBuilder extends StatefulWidget {
  final double? itemExtent;
  final Widget Function(Exception exception, void Function() tryAgain)
      errorIndicatorWidget;
  final Widget progressIndicatorWidget;
  final Widget Function(BuildContext context, int index) itemBuilder;
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
      ValueNotifier(LastItem.ProgressIndicator);

  late Exception exception;

  bool isLoadMoreBeingCalled = false;

  void tryAgain() => performPagination();

  Future<void> performPagination() async {
    valueNotifier.value = LastItem.ProgressIndicator;
    isLoadMoreBeingCalled = true;
    try {
      await widget.loadMore();
      isLoadMoreBeingCalled = false;
      valueNotifier.value = LastItem.EmptyContainer;
    } on Exception catch (exception) {
      this.exception = exception;
      valueNotifier.value = LastItem.ErrorIndicator;
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
          return true;
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
                      if (value == LastItem.EmptyContainer) {
                        return Container();
                      } else if (value == LastItem.ErrorIndicator) {
                        return widget.errorIndicatorWidget(
                            this.exception, this.tryAgain);
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
