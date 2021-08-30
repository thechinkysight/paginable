import 'package:flutter/material.dart';

bool isAlmostAtTheEndOfTheScroll(
        ScrollUpdateNotification scrollUpdateNotification) =>
    scrollUpdateNotification.metrics.pixels >=
    scrollUpdateNotification.metrics.maxScrollExtent * 0.8;

bool isScrollingDownwards(ScrollUpdateNotification scrollUpdateNotification) =>
    scrollUpdateNotification.scrollDelta! > 0.0;
