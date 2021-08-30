import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:paginable/src/utils/last_item.dart';
import 'package:provider/provider.dart';

class PaginableSliverChildBuilderDelegate {
  static int _kDefaultSemanticIndexCallback(Widget _, int localIndex) =>
      localIndex;

  final NullableIndexedWidgetBuilder builder;
  final Widget Function(Exception exception, void Function() tryAgain)
      errorIndicatorWidget;
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

  SliverChildBuilderDelegate build() =>
      SliverChildBuilderDelegate((BuildContext context, int index) {
        if (index == childCount) {
          return ValueListenableBuilder<LastItem>(
              valueListenable: context.read<ValueNotifier<LastItem>>(),
              builder: (context, value, child) {
                if (value == LastItem.EmptyContainer) {
                  return Container();
                } else if (value == LastItem.ErrorIndicator) {
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
          childCount: this.childCount == null ? null : this.childCount! + 1,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          semanticIndexCallback: semanticIndexCallback,
          semanticIndexOffset: semanticIndexOffset);
}
