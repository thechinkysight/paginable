import 'package:flutter/material.dart';

class CustomScrollPosition {
  final ScrollUpdateNotification scrollUpdateNotification;

  CustomScrollPosition(this.scrollUpdateNotification);

  bool isAlmostAtTheEndOfTheScroll() =>
      scrollUpdateNotification.metrics.pixels >=
      scrollUpdateNotification.metrics.maxScrollExtent * 0.8;

  bool isScrollingDownwards() => scrollUpdateNotification.scrollDelta! > 0.0;
}
