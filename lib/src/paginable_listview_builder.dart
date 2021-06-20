import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class PaginableListViewBuilder extends StatefulWidget {
  final double? itemExtent;
  final Widget Function(String errorLog, void Function() tryAgain)
  errorIndicatorWidget;
  final Widget Function() progressIndicatorWidget;
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
  bool isAlmostAtTheEndOfTheScroll(ScrollNotification scrollNotification) =>
      scrollNotification.metrics.pixels >=
          scrollNotification.metrics.maxScrollExtent * 0.8;

  void performPagination() {
    valueNotifier.value = CustomWidgetEnum.ProgressIndicator;
    isLoadMoreBeingCalled = true;
    widget.loadMore().then((value) {
      isLoadMoreBeingCalled = false;
      valueNotifier.value = CustomWidgetEnum.EmptyContainer;
    }).catchError((e) {
      this.errorLog = e.toString();
      valueNotifier.value = CustomWidgetEnum.ErrorWidget;
    });
  }

  void tryAgain() => performPagination();

  ValueNotifier<CustomWidgetEnum> valueNotifier =
  ValueNotifier(CustomWidgetEnum.ProgressIndicator);

  late String errorLog;

  bool isLoadMoreBeingCalled = false;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollNotification) {
          if (isAlmostAtTheEndOfTheScroll(scrollNotification)) {
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
                return ValueListenableBuilder<CustomWidgetEnum>(
                    valueListenable: valueNotifier,
                    builder: (context, value, child) {
                      if (value == CustomWidgetEnum.EmptyContainer) {
                        return Container();
                      } else if (value == CustomWidgetEnum.ErrorWidget) {
                        return widget.errorIndicatorWidget(
                            this.errorLog, this.tryAgain);
                      }
                      return widget.progressIndicatorWidget();
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

enum CustomWidgetEnum { ProgressIndicator, ErrorWidget, EmptyContainer }
