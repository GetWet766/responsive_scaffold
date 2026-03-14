import 'package:flutter/material.dart';

class ResponsiveScaffoldConst {
  const ResponsiveScaffoldConst._();

  static const Duration animationDuration = Duration(milliseconds: 250);

  static const double collapsedRailWidth = 96;
  static const double expandedRailWidth = 240;

  static const EdgeInsets railHeaderPadding = EdgeInsets.symmetric(
    horizontal: 20,
  );

  static const EdgeInsets fabPadding = EdgeInsets.symmetric(vertical: 12);

  static const double baseItemWidth = 56;
  static const double gap = 12;

  static const double railItemSpacing = 8;
  static const double railHorizontalPadding = 16;

  static const double indicatorHeightCollapsed = 32;
  static const double indicatorHeightExpanded = 56;

  static const double indicatorPaddingCollapsed = 4;
  static const double indicatorPaddingExpanded = 16;

  static const double iconSize = 24;

  static const double collapsedLabelSpacing = 4;

  static const double paneGap = 24;

  static const EdgeInsets panePadding = EdgeInsets.all(24);
}
