import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:responsive_scaffold/navigation/indicator_inkwell.dart';
import '../constants.dart';
import '../responsive_scaffold.dart';

class ResponsiveNavigationRailItem extends StatelessWidget {
  const ResponsiveNavigationRailItem({
    super.key,
    required this.t,
    required this.destination,
    required this.selected,
    required this.collapsed,
    required this.onTap,
  });

  final double t;
  final ResponsiveScaffoldDestination destination;
  final bool selected;
  final bool collapsed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final icon =
        selected
            ? (destination.selectedIcon ?? destination.icon)
            : destination.icon;

    final compactLabelStyle = theme.textTheme.labelMedium?.copyWith(
      letterSpacing: 0.5,
      color:
          selected
              ? theme.colorScheme.onSecondaryContainer
              : theme.colorScheme.onSurfaceVariant,
    );
    final expandedLabelStyle = theme.textTheme.labelLarge?.copyWith(
      color:
          selected
              ? theme.colorScheme.onSecondaryContainer
              : theme.colorScheme.onSurfaceVariant,
    );

    final expandedTextPainter = TextPainter(
      text: TextSpan(text: destination.label, style: expandedLabelStyle),
      maxLines: 1,
      textDirection: Directionality.of(context),
    )..layout();
    final expandedTextWidth = expandedTextPainter.width;

    final compactTextPainter = TextPainter(
      text: TextSpan(text: destination.label, style: compactLabelStyle),
      maxLines: 1,
      textDirection: Directionality.of(context),
    )..layout();
    final compactTextWidth = compactTextPainter.width;
    final compactTextHeight = compactTextPainter.height;

    final expandedWidth =
        ResponsiveScaffoldConst.baseItemWidth +
        ResponsiveScaffoldConst.gap +
        expandedTextWidth;

    final width =
        lerpDouble(ResponsiveScaffoldConst.baseItemWidth, expandedWidth, t)!;

    return Container(
      constraints: BoxConstraints(
        minWidth: ResponsiveScaffoldConst.collapsedRailWidth,
      ),
      width: lerpDouble(compactTextWidth + 40, expandedWidth, t)!,
      padding: EdgeInsets.only(bottom: lerpDouble(4, 0, t)!),
      child: Material(
        color: Colors.transparent,
        child: IndicatorInkWell(
          onTap: onTap,

          indicatorOffset: Offset(0, lerpDouble(6, 0, t)!),
          applyXOffset: false,
          textDirection: Directionality.of(context),

          indicatorWidth: width,
          indicatorHeight:
              lerpDouble(
                ResponsiveScaffoldConst.indicatorHeightCollapsed,
                ResponsiveScaffoldConst.indicatorHeightExpanded,
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
                          ResponsiveScaffoldConst.collapsedLabelSpacing +
                              compactTextHeight,
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
                        horizontal:
                            ResponsiveScaffoldConst.indicatorPaddingExpanded,
                        vertical:
                            lerpDouble(
                              ResponsiveScaffoldConst.indicatorPaddingCollapsed,
                              ResponsiveScaffoldConst.indicatorPaddingExpanded,
                              t,
                            )!,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: IconTheme(
                          data: IconThemeData(
                            size: ResponsiveScaffoldConst.iconSize,
                            color:
                                selected
                                    ? theme.colorScheme.onSecondaryContainer
                                    : theme.colorScheme.onSurfaceVariant,
                          ),
                          child: icon,
                        ),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 0,
                  height: lerpDouble(
                    ResponsiveScaffoldConst.indicatorHeightCollapsed,
                    ResponsiveScaffoldConst.indicatorHeightExpanded,
                    t,
                  ),
                  left:
                      ResponsiveScaffoldConst.indicatorPaddingExpanded +
                      ResponsiveScaffoldConst.iconSize +
                      ResponsiveScaffoldConst.gap,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Opacity(
                      opacity: t,
                      child: Text(destination.label, style: expandedLabelStyle),
                    ),
                  ),
                ),

                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  // width: collapsedTextWidth > ResponsiveScaffoldConst.baseItemWidth ? collapsedTextWidth : ResponsiveScaffoldConst.baseItemWidth,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Opacity(
                      opacity: 1 - t,
                      child: Text(destination.label, style: compactLabelStyle, maxLines: 1, softWrap: false,),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
