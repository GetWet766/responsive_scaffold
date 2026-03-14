import 'dart:ui';
import 'package:flutter/material.dart';
import 'breakpoints.dart';

/// =======================
/// Layout constants
/// =======================
class _ResponsiveScaffoldConst {
  static const Duration animationDuration = Duration(milliseconds: 300);

  static const double collapsedRailWidth = 96;
  static const double expandedRailWidth = 220;

  static const double baseItemWidth = 56;
  static const double gap = 8;

  static const double iconSize = 24;
  static const double collapsedLabelSpacing = 4;

  static const double indicatorHeightCollapsed = 32;
  static const double indicatorHeightExpanded = 56;

  static const double verticalPaddingCollapsed = 4;
  static const double verticalPaddingExpanded = 16;
  static const double horizontalPadding = 16;

  static const EdgeInsets railHeaderPadding = EdgeInsets.symmetric(
    horizontal: 20,
  );
  static const EdgeInsets fabPadding = EdgeInsets.symmetric(vertical: 8);
}

/// Destination for [ResponsiveScaffold].
class ResponsiveScaffoldDestination {
  final Widget icon;
  final Widget? selectedIcon;
  final String label;

  const ResponsiveScaffoldDestination({
    required this.icon,
    this.selectedIcon,
    required this.label,
  });
}

class ResponsiveScaffold extends StatefulWidget {
  final List<ResponsiveScaffoldDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;
  final List<Widget> bodyPanes;

  final Widget? title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  final bool showAppBarOnDesktop;

  const ResponsiveScaffold({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.bodyPanes,
    this.onDestinationSelected,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.showAppBarOnDesktop = false,
  });

  @override
  State<ResponsiveScaffold> createState() => _ResponsiveScaffoldState();
}

class _ResponsiveScaffoldState extends State<ResponsiveScaffold> {
  bool? _isCollapsedOverride;
  WindowSizeClass? _lastSizeClass;

  bool _isCompact(WindowSizeClass c) => c == WindowSizeClass.compact;

  int _calculatePaneCount(WindowSizeClass sizeClass) {
    final panes = widget.bodyPanes.length;

    switch (sizeClass) {
      case WindowSizeClass.compact:
        return 1;

      case WindowSizeClass.medium:
      case WindowSizeClass.expanded:
      case WindowSizeClass.large:
        return panes >= 2 ? 2 : 1;

      case WindowSizeClass.extraLarge:
        if (panes >= 3) return 3;
        if (panes >= 2) return 2;
        return 1;
    }
  }

  void _updateCollapseState(WindowSizeClass sizeClass) {
    if (_lastSizeClass == sizeClass) return;

    _lastSizeClass = sizeClass;

    if (sizeClass == WindowSizeClass.large) {
      _isCollapsedOverride = true;
    } else if (sizeClass == WindowSizeClass.extraLarge) {
      _isCollapsedOverride = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sizeClass = Breakpoints.current(context);

    _updateCollapseState(sizeClass);

    final isCollapsed =
        _isCollapsedOverride ??
        (sizeClass == WindowSizeClass.compact ||
            sizeClass == WindowSizeClass.medium ||
            sizeClass == WindowSizeClass.large);

    final paneCount = _calculatePaneCount(sizeClass);
    final visiblePanes = widget.bodyPanes.take(paneCount).toList();

    final isCompact = _isCompact(sizeClass);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainer,
      appBar:
          (isCompact || widget.showAppBarOnDesktop)
              ? AppBar(title: widget.title, actions: widget.actions)
              : null,

      bottomNavigationBar:
          isCompact
              ? NavigationBar(
                selectedIndex: widget.selectedIndex,
                onDestinationSelected: widget.onDestinationSelected,
                destinations:
                    widget.destinations
                        .map(
                          (d) => NavigationDestination(
                            icon: d.icon,
                            selectedIcon: d.selectedIcon ?? d.icon,
                            label: d.label,
                          ),
                        )
                        .toList(),
              )
              : null,

      floatingActionButton: isCompact ? widget.floatingActionButton : null,

      body: Row(
        children: [
          if (!isCompact) _buildNavigationRail(theme, isCollapsed),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20, right: 20),
              child: Row(
                children: [
                  for (final pane in visiblePanes) Expanded(child: pane),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationRail(ThemeData theme, bool isCollapsed) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: !isCollapsed ? 1 : 0),
      duration: _ResponsiveScaffoldConst.animationDuration,
      curve: Curves.easeInOutCubic,
      builder: (context, t, _) {
        final width =
            lerpDouble(
              _ResponsiveScaffoldConst.collapsedRailWidth,
              _ResponsiveScaffoldConst.expandedRailWidth,
              t,
            )!;

        return Container(
          constraints: BoxConstraints(minWidth: width),
          color: theme.colorScheme.surfaceContainer,
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: _ResponsiveScaffoldConst.railHeaderPadding,
                child: Column(
                  children: [
                    IconButton(
                      icon:
                          isCollapsed
                              ? const Icon(Icons.menu)
                              : const Icon(Icons.menu_open),
                      onPressed:
                          () => setState(
                            () => _isCollapsedOverride = !isCollapsed,
                          ),
                    ),
                    if (widget.floatingActionButton != null)
                      Padding(
                        padding: _ResponsiveScaffoldConst.fabPadding,
                        child: widget.floatingActionButton!,
                      ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: lerpDouble(0, 20, t)!,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < widget.destinations.length; i++)
                      _navItem(widget.destinations[i], i, t),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _navItem(
    ResponsiveScaffoldDestination destination,
    int index,
    double t,
  ) {
    final theme = Theme.of(context);

    final selected = index == widget.selectedIndex;

    final expandedTextPainter = TextPainter(
      text: TextSpan(
        text: destination.label,
        style: theme.textTheme.labelLarge,
      ),
      maxLines: 1,
      textDirection: Directionality.of(context),
    )..layout();
    final expandedTextWidth = expandedTextPainter.width;

    final collapsedTextPainter = TextPainter(
      text: TextSpan(
        text: destination.label,
        style: theme.textTheme.labelMedium,
      ),
      maxLines: 1,
      textDirection: Directionality.of(context),
    )..layout();
    final collapsedTextHeight = collapsedTextPainter.height;

    final expandedWidth =
        _ResponsiveScaffoldConst.baseItemWidth +
        _ResponsiveScaffoldConst.gap +
        expandedTextWidth;

    final width =
        lerpDouble(_ResponsiveScaffoldConst.baseItemWidth, expandedWidth, t)!;

    return Container(
      constraints: BoxConstraints(
        minWidth: _ResponsiveScaffoldConst.collapsedRailWidth,
      ),
      padding: EdgeInsets.only(bottom: lerpDouble(4, 0, t)!),
      child: Material(
        color: Colors.transparent,
        child: CustomIndicatorInkWell(
          onTap: () => widget.onDestinationSelected?.call(index),

          indicatorOffset: Offset(0, lerpDouble(6, 0, t)!),
          applyXOffset: false,
          textDirection: Directionality.of(context),

          indicatorWidth: width,
          indicatorHeight:
              lerpDouble(
                _ResponsiveScaffoldConst.indicatorHeightCollapsed,
                _ResponsiveScaffoldConst.indicatorHeightExpanded,
                t,
              )!,
          customBorder: const StadiumBorder(),

          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: lerpDouble(6, 0, t)!,
              horizontal: lerpDouble(20, 0, t)!,
            ),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    bottom:
                        lerpDouble(
                          _ResponsiveScaffoldConst.collapsedLabelSpacing +
                              collapsedTextHeight,
                          0,
                          t,
                        )!,
                  ),
                  child: Center(
                    child: Ink(
                      width: width,
                      decoration: ShapeDecoration(
                        shape: StadiumBorder(),
                        color:
                            selected
                                ? theme.colorScheme.secondaryContainer
                                : null,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: _ResponsiveScaffoldConst.horizontalPadding,
                        vertical:
                            lerpDouble(
                              _ResponsiveScaffoldConst.verticalPaddingCollapsed,
                              _ResponsiveScaffoldConst.verticalPaddingExpanded,
                              t,
                            )!,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: IconTheme(
                          data: IconThemeData(
                            size: _ResponsiveScaffoldConst.iconSize,
                            color:
                                selected
                                    ? theme.colorScheme.onSecondaryContainer
                                    : theme.colorScheme.onSurfaceVariant,
                          ),
                          child: destination.icon,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  height: lerpDouble(
                    _ResponsiveScaffoldConst.indicatorHeightCollapsed,
                    _ResponsiveScaffoldConst.indicatorHeightExpanded,
                    t,
                  ),
                  left:
                      _ResponsiveScaffoldConst.horizontalPadding +
                      _ResponsiveScaffoldConst.iconSize +
                      _ResponsiveScaffoldConst.gap,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Opacity(
                      opacity: t,
                      child: Text(
                        destination.label,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color:
                              selected
                                  ? theme.colorScheme.onSecondaryContainer
                                  : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
                _buildBottomLabel(destination, index, t),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomLabel(
    ResponsiveScaffoldDestination destination,
    int index,
    double t,
  ) {
    final theme = Theme.of(context);
    final selected = index == widget.selectedIndex;

    return Positioned(
      bottom: 0,
      width: _ResponsiveScaffoldConst.baseItemWidth,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Opacity(
          opacity: 1 - t,
          child: Text(
            destination.label,
            style: theme.textTheme.labelMedium?.copyWith(
              color:
                  selected
                      ? theme.colorScheme.secondary
                      : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomIndicatorInkWell extends InkResponse {
  const CustomIndicatorInkWell({
    super.key,
    super.child,
    super.onTap,
    super.customBorder,
    super.borderRadius,
    super.splashColor,
    super.hoverColor,
    required this.indicatorOffset,
    required this.textDirection,
    this.applyXOffset = false,
    this.indicatorWidth = 56,
    this.indicatorHeight = 32,
  }) : super(containedInkWell: true, highlightShape: BoxShape.rectangle);

  final Offset indicatorOffset;
  final bool applyXOffset;
  final TextDirection textDirection;

  final double indicatorWidth;
  final double indicatorHeight;

  @override
  RectCallback? getRectCallback(RenderBox referenceBox) {
    final boxWidth = referenceBox.size.width;

    double indicatorCenter = applyXOffset ? indicatorOffset.dx : boxWidth / 2;

    if (textDirection == TextDirection.rtl) {
      indicatorCenter = boxWidth - indicatorCenter;
    }

    return () => Rect.fromLTWH(
      indicatorCenter - (indicatorWidth / 2),
      indicatorOffset.dy,
      indicatorWidth,
      indicatorHeight,
    );
  }
}
