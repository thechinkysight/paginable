import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'utils/utils.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

/// It is the is paginable's version of [SliverChildBuilderDelegate](https://api.flutter.dev/flutter/widgets/SliverChildBuilderDelegate-class.html) and it is used along with [PaginableCustomScrollView](https://pub.dev/packages/paginable#using-paginablecustomscrollview-with-paginablesliverchildbuilderdelegate) to perform pagination.
class PaginableSliverChildBuilderDelegate {
  static int _kDefaultSemanticIndexCallback(Widget _, int localIndex) =>
      localIndex;

  final IndexedWidgetBuilder builder;

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
  final int? Function(Key)? findChildIndexCallback;
  final int? childCount;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final int? Function(Widget, int) semanticIndexCallback;
  final int semanticIndexOffset;

  const PaginableSliverChildBuilderDelegate(this.builder,
      {required this.errorIndicatorWidget,
      required this.progressIndicatorWidget,
      this.findChildIndexCallback,
      this.childCount,
      this.addAutomaticKeepAlives = true,
      this.addRepaintBoundaries = true,
      this.addSemanticIndexes = true,
      this.semanticIndexCallback = _kDefaultSemanticIndexCallback,
      this.semanticIndexOffset = 0});

  /// It simply returns a SliverChildBuilderDelegate which is a delegate that
  /// supplies children for slivers using a builder callback.
  SliverChildBuilderDelegate build() =>
      SliverChildBuilderDelegate((BuildContext context, int index) {
        if (index == childCount) {
          return ValueListenableBuilder<LastItem>(
            valueListenable: context.read<ValueNotifier<LastItem>>(),
            builder: (context, value, child) {
              if (value == LastItem.emptyContainer) {
                return Container(
                  key:
                      keyForEmptyContainerWidgetOfPaginableSliverChildBuilderDelegate,
                );
              } else if (value == LastItem.errorIndicator) {
                return errorIndicatorWidget(
                    context.read<ValueNotifier<Exception>>().value,
                    context.read<void Function()>());
              }
              return progressIndicatorWidget;
            },
          );
        }
        return builder(context, index);
      },
          findChildIndexCallback: findChildIndexCallback,
          childCount: childCount == null ? null : childCount! + 1,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          semanticIndexCallback: semanticIndexCallback,
          semanticIndexOffset: semanticIndexOffset);


  /// It simply returns a separable SliverChildBuilderDelegate which is a delegate that
  /// supplies children for slivers separated by separators.
  SliverChildBuilderDelegate separated(IndexedWidgetBuilder separatorBuilder) =>
      SliverChildBuilderDelegate((BuildContext context, int index) {
        if (index ==
            _computeActualChildCount(childCount == null ? 0 : childCount!) -
                1) {
          return ValueListenableBuilder<LastItem>(
            valueListenable: context.read<ValueNotifier<LastItem>>(),
            builder: (context, value, child) {
              if (value == LastItem.emptyContainer) {
                return Container(
                  key:
                      keyForEmptyContainerWidgetOfPaginableSliverChildBuilderDelegate,
                );
              } else if (value == LastItem.errorIndicator) {
                return errorIndicatorWidget(
                    context.read<ValueNotifier<Exception>>().value,
                    context.read<void Function()>());
              }
              return progressIndicatorWidget;
            },
          );
        }

        final int itemIndex = index ~/ 2;
        final Widget widget;

        if (index.isEven) {
          widget = builder(context, itemIndex);
        } else {
          widget = separatorBuilder(context, itemIndex);
        }
        return widget;
      },
          findChildIndexCallback: findChildIndexCallback,
          childCount:
              _computeActualChildCount(childCount == null ? 0 : childCount!),
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          semanticIndexCallback: (Widget _, int index) =>
              index.isEven ? index ~/ 2 : null,
          semanticIndexOffset: semanticIndexOffset);

  static int _computeActualChildCount(int childCount) {
    return math.max(0, childCount * 2);
  }
}
