import 'package:flutter/material.dart';
import '../constants.dart';

class ExpressivePaneLayout extends StatelessWidget {
  const ExpressivePaneLayout({super.key, required this.panes});

  final List<Widget> panes;

  @override
  Widget build(BuildContext context) {
    if (panes.length == 1) {
      return panes.first;
    }

    if (panes.length == 2) {
      return Row(
        children: [
          Flexible(flex: 4, child: panes[0]),
          const SizedBox(width: ResponsiveScaffoldConst.paneGap),
          Flexible(flex: 6, child: panes[1]),
        ],
      );
    }

    return Row(
      children: [
        Flexible(flex: 3, child: panes[0]),
        const SizedBox(width: ResponsiveScaffoldConst.paneGap),
        Flexible(flex: 5, child: panes[1]),
        const SizedBox(width: ResponsiveScaffoldConst.paneGap),
        Flexible(flex: 6, child: panes[2]),
      ],
    );
  }
}
