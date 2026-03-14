import 'breakpoint_controller.dart';

class PanePolicy {
  const PanePolicy._();

  static int resolvePaneCount(WindowSizeClass sizeClass, int available) {
    switch (sizeClass) {
      case WindowSizeClass.compact:
        return 1;

      case WindowSizeClass.medium:
        return available >= 2 ? 2 : 1;

      case WindowSizeClass.expanded:
        return available >= 2 ? 2 : 1;

      case WindowSizeClass.large:
        return available >= 2 ? 2 : 1;

      case WindowSizeClass.extraLarge:
        if (available >= 3) return 3;
        if (available >= 2) return 2;
        return 1;
    }
  }
}
