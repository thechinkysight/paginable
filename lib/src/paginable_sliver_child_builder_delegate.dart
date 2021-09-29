import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:paginable/src/utils/last_item.dart';
import 'package:provider/provider.dart';

/// It is the is paginable's version of [SliverChildBuilderDelegate](https://api.flutter.dev/flutter/widgets/SliverChildBuilderDelegate-class.html) and it is used along with [PaginableCustomScrollView](https://pub.dev/packages/paginable#using-paginablecustomscrollview-with-paginablesliverchildbuilderdelegate) to perform pagination.
class PaginableSliverChildBuilderDelegate {
  static int _kDefaultSemanticIndexCallback(Widget _, int localIndex) =>
      localIndex;

  final NullableIndexedWidgetBuilder builder;

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

  PaginableSliverChildBuilderDelegate(this.builder,
      {required this.errorIndicatorWidget,
      required this.progressIndicatorWidget,
      this.findChildIndexCallback,
      this.childCount,
      this.addAutomaticKeepAlives = true,
      this.addRepaintBoundaries = true,
      this.addSemanticIndexes = true,
      this.semanticIndexCallback = _kDefaultSemanticIndexCallback,
      this.semanticIndexOffset = 0});

  /// Creates a delegate that supplies children for slivers using the given
  /// builder callback.
  ///
  /// If the order in which [builder] returns children ever changes, consider
  /// providing a [findChildIndexCallback]. This allows the delegate to find the
  /// new index for a child that was previously located at a different index to
  /// attach the existing state to the [Widget] at its new location.
  SliverChildBuilderDelegate build() =>
      SliverChildBuilderDelegate((BuildContext context, int index) {
        if (index == childCount) {
          return ValueListenableBuilder<LastItem>(
              valueListenable: context.read<ValueNotifier<LastItem>>(),
              builder: (context, value, child) {
                if (value == LastItem.emptyContainer) {
                  return Container();
                } else if (value == LastItem.errorIndicator) {
                  return errorIndicatorWidget(
                      context.read<ValueNotifier<Exception>>().value,
                      context.read<void Function()>());
                }
                return progressIndicatorWidget;
              });
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
}
