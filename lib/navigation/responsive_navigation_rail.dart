import 'dart:ui';

import 'package:flutter/material.dart';
import 'responsive_navigation_rail_item.dart';
import '../constants.dart';
import '../responsive_scaffold.dart';

class ResponsiveNavigationRail extends StatelessWidget {
  const ResponsiveNavigationRail({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onSelected,
    required this.collapsed,
    required this.onCollapsedChanged,
    this.fab,
  });

  final List<ResponsiveScaffoldDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int>? onSelected;
  final bool collapsed;
  final VoidCallback onCollapsedChanged;
  final Widget? fab;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: !collapsed ? 1 : 0),
      duration: ResponsiveScaffoldConst.animationDuration,
      curve: Curves.easeInOutCubic,
      builder: (context, t, _) {
        final width =
            lerpDouble(
              ResponsiveScaffoldConst.collapsedRailWidth,
              ResponsiveScaffoldConst.expandedRailWidth,
              t,
            )!;

        return Container(
          constraints: BoxConstraints(minWidth: width),
          color: theme.colorScheme.surface,
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: ResponsiveScaffoldConst.railHeaderPadding,
                child: Column(
                  children: [
                    IconButton(
                      icon:
                          collapsed
                              ? const Icon(Icons.menu)
                              : const Icon(Icons.menu_open),
                      onPressed: onCollapsedChanged,
                    ),
                    if (fab != null)
                      Padding(
                        padding: ResponsiveScaffoldConst.fabPadding,
                        child: fab!,
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
                    for (int i = 0; i < destinations.length; i++)
                      ResponsiveNavigationRailItem(
                        t: t,
                        destination: destinations[i],
                        selected: i == selectedIndex,
                        collapsed: collapsed,
                        onTap: () => onSelected?.call(i),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
