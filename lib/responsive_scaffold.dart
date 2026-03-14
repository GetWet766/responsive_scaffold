library responsive_scaffold;

import 'package:flutter/material.dart';

import 'constants.dart';
import 'layout/breakpoint_controller.dart';
import 'layout/pane_policy.dart';
import 'navigation/responsive_navigation_rail.dart';
import 'panes/expressive_pane_layout.dart';

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
  const ResponsiveScaffold({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.bodyPanes,
    this.onDestinationSelected,
    this.title,
    this.actions,
    this.floatingActionButton,
  });

  final List<ResponsiveScaffoldDestination> destinations;
  final int selectedIndex;
  final List<Widget> bodyPanes;

  final ValueChanged<int>? onDestinationSelected;

  final Widget? title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  @override
  State<ResponsiveScaffold> createState() => _ResponsiveScaffoldState();
}

class _ResponsiveScaffoldState extends State<ResponsiveScaffold> {
  WindowSizeClass? _lastSizeClass;
  bool collapsed = true;

  void _updateCollapseState(WindowSizeClass sizeClass) {
    if (_lastSizeClass == sizeClass) return;

    _lastSizeClass = sizeClass;

    if (sizeClass == WindowSizeClass.expanded) {
      collapsed = true;
    } else if (sizeClass == WindowSizeClass.large ||
        sizeClass == WindowSizeClass.extraLarge) {
      collapsed = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sizeClass = BreakpointController.of(context);
    final isCompact = sizeClass == WindowSizeClass.compact;

    final paneCount = PanePolicy.resolvePaneCount(
      sizeClass,
      widget.bodyPanes.length,
    );

    final panes = widget.bodyPanes.take(paneCount).toList();

    _updateCollapseState(sizeClass);

    return Scaffold(
      appBar:
          isCompact
              ? AppBar(title: widget.title, actions: widget.actions)
              : null,

      bottomNavigationBar:
          isCompact
              ? NavigationBar(
                selectedIndex: widget.selectedIndex,
                onDestinationSelected: widget.onDestinationSelected,
                destinations: [
                  for (final d in widget.destinations)
                    NavigationDestination(
                      icon: d.icon,
                      selectedIcon: d.selectedIcon ?? d.icon,
                      label: d.label,
                    ),
                ],
              )
              : null,

      floatingActionButton: isCompact ? widget.floatingActionButton : null,

      body: Row(
        children: [
          if (!isCompact)
            ResponsiveNavigationRail(
              destinations: widget.destinations,
              selectedIndex: widget.selectedIndex,
              onSelected: widget.onDestinationSelected,
              fab: widget.floatingActionButton,
              collapsed: collapsed,
              onCollapsedChanged:
                  () => setState(() {
                    collapsed = !collapsed;
                  }),
            ),

          Expanded(
            child: Padding(
              padding: ResponsiveScaffoldConst.panePadding,
              child: ExpressivePaneLayout(panes: panes),
            ),
          ),
        ],
      ),
    );
  }
}
