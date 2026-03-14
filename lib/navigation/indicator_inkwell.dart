import 'package:flutter/material.dart';

class IndicatorInkWell extends InkResponse {
  const IndicatorInkWell({
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
