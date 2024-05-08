
import 'package:flutter/material.dart';
import 'package:stewart_platform_control/core/canvas/canvas_axis.dart';
import 'package:stewart_platform_control/core/canvas/canvas_centered_item.dart';
import 'package:stewart_platform_control/core/canvas/canvas_item_transformations.dart';
import 'package:stewart_platform_control/core/canvas/canvas_items_painter.dart';
import 'package:stewart_platform_control/core/canvas/canvas_rect.dart';
import 'package:stewart_platform_control/core/canvas/canvas_point.dart';
import 'package:stewart_platform_control/core/canvas/letters/canvas_letter.dart';
///
class FluctuationSideProjectionPaint extends StatelessWidget {
  final CanvasLetterName _horizontalAxisName;
  final bool _isReversed;
  // final MinMax? _borderValues;
  final Color _accentColor;
  final Color _zAxisColor;
  final double _fluctuationOffset;
  final double _rotationRadians;
  final double _pointSize;
  ///
  const FluctuationSideProjectionPaint({
    super.key,
    required Color accentColor,
    required Color zAxisColor,
    required double fluctuationOffset,
    required double rotationRadians,
    required double pointSize,
    CanvasLetterName horizontalAxisName = CanvasLetterName.x,
    bool isReversed = false,
    // MinMax? borderValues,
  }) :
    _pointSize = pointSize,
    _rotationRadians = rotationRadians,
    _fluctuationOffset = fluctuationOffset,
    _horizontalAxisName = horizontalAxisName,
    // _borderValues = borderValues,
    _zAxisColor = zAxisColor,
    _accentColor = accentColor,
    _isReversed = isReversed;
  //
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CanvasItemsPainter(
        items: [
          const CanvasRect(
            color: Colors.black,
            strokeWidth: 15.0,
          )
            .transformAroundPoint(
              Offset(-_fluctuationOffset, 0.0),
              rotatationAngleRadians: _rotationRadians,
            )
            .center(CenteringDirection.vertical),
          CanvasAxis(
            letterName: CanvasLetterName.z,
            sharpnessAngle: 30,
            length: 20,
            strokeWidth: 2,
            color:  _zAxisColor.withOpacity(0.5),
            direction:  CanvasLineDirection.vertical,
            isReversed: false,
          ),
          CanvasAxis(
            letterName: _horizontalAxisName,
            sharpnessAngle: 30,
            length: 20,
            strokeWidth: 2,
            color:  _accentColor.withOpacity(0.5),
            direction:  CanvasLineDirection.horizontal,
            isReversed: _isReversed,
          ),
          CanvasPoint(
            color: _accentColor,
            width: _pointSize/2,
          )
            .translate(Offset(_fluctuationOffset, 0.0))
            .center(CenteringDirection.vertical),
        ],
      ),
    );
  }
}