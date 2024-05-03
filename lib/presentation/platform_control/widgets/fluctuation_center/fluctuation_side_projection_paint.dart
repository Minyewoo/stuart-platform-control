import 'package:flutter/material.dart';
import 'package:stewart_platform_control/core/canvas/canvas_centered_item.dart';
import 'package:stewart_platform_control/core/canvas/canvas_item_transformations.dart';
import 'package:stewart_platform_control/core/canvas/canvas_items_painter.dart';
import 'package:stewart_platform_control/core/canvas/canvas_line.dart';
import 'package:stewart_platform_control/core/canvas/canvas_point.dart';
///
class FluctuationSideProjectionPaint extends StatelessWidget {
  final Color _accentColor;
  final double _fluctuationOffset;
  final double _rotationRadians;
  final double _pointSize;
  ///
  const FluctuationSideProjectionPaint({
    super.key,
    required Color accentColor,
    required double fluctuationOffset,
    required double rotationRadians,
    required double pointSize,
  }) :
    _pointSize = pointSize,
    _rotationRadians = rotationRadians,
    _fluctuationOffset = fluctuationOffset,
    _accentColor = accentColor;
  //
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CanvasItemsPainter(
        items: [
          CanvasLine(
            color: Colors.black,
            strokeWidth: 15.0,
          )
            .translate(Offset(-_fluctuationOffset, 0.0))
            .rotate(_rotationRadians)
            .translate(Offset(_fluctuationOffset, 0.0))
            .center(direction: CenteringDirection.vertical),
          CanvasLine(
            color: _accentColor,
            strokeWidth: 1.0,
          )
            .center(direction: CenteringDirection.vertical),
          CanvasPoint(
            color: _accentColor,
            width: _pointSize/2,
          )
            .translate(Offset(_fluctuationOffset, 0.0))
            .center(direction: CenteringDirection.vertical),
        ],
      ),
    );
  }
}