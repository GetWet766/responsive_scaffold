import 'package:flutter/widgets.dart';

/// Window size classes based on Material 3 adaptive layout specifications.
enum WindowSizeClass {
  /// < 600dp
  compact,

  /// 600–839dp
  medium,

  /// 840–1199dp
  expanded,

  /// 1200–1599dp
  large,

  /// 1600+dp
  extraLarge,
}

/// Utility for determining the current [WindowSizeClass] and breakpoints.
class Breakpoints {
  static const double medium = 600;
  static const double expanded = 840;
  static const double large = 1200;
  static const double extraLarge = 1600;

  /// Returns the [WindowSizeClass] for the given [context].
  static WindowSizeClass current(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < medium) return WindowSizeClass.compact;
    if (width < expanded) return WindowSizeClass.medium;
    if (width < large) return WindowSizeClass.expanded;
    if (width < extraLarge) return WindowSizeClass.large;
    return WindowSizeClass.extraLarge;
  }
}
