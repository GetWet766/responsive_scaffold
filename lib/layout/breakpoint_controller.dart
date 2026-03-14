import 'package:flutter/widgets.dart';

enum WindowSizeClass { compact, medium, expanded, large, extraLarge }

class BreakpointController {
  const BreakpointController._();

  static WindowSizeClass of(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width < 600) return WindowSizeClass.compact;
    if (width < 840) return WindowSizeClass.medium;
    if (width < 1200) return WindowSizeClass.expanded;
    if (width < 1600) return WindowSizeClass.large;

    return WindowSizeClass.extraLarge;
  }
}
