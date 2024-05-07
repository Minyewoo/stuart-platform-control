import 'package:flutter/painting.dart';
import 'package:stewart_platform_control/core/canvas/canvas_item.dart';
import 'package:stewart_platform_control/core/canvas/canvas_item_dimension.dart';
import 'package:stewart_platform_control/core/canvas/canvas_item_transformations.dart';
import 'package:stewart_platform_control/core/canvas/canvas_rect.dart';
import 'package:vector_math/vector_math_64.dart';
///
class CanvasZLetter implements CanvasItem {
  final Color _color;
  final double _strokeWidth;
  ///
  const CanvasZLetter({
    required Color color,
    double strokeWidth = 1.0,
  }) : 
    _color = color,
    _strokeWidth = strokeWidth;
  @override
  Path path(Size size) {
    return [
      CanvasRect(
        color: _color,
        strokeWidth: _strokeWidth,
        width: const CanvasItemDimension.sizedFrom(15),
        direction: CanvasLineDirection.horizontal,
      ),
      CanvasRect(
        color: _color,
        strokeWidth: _strokeWidth,
        width: const CanvasItemDimension.sizedFrom(22),
        direction: CanvasLineDirection.horizontal,
      )
      .rotate(45*degrees2Radians)
      .translate(const Offset(0.0, 15)),
      CanvasRect(
        color: _color,
        strokeWidth: _strokeWidth,
        width: const CanvasItemDimension.sizedFrom(15),
        direction: CanvasLineDirection.horizontal,
      ).translate(const Offset(0.0, 15)),
    ].combine(PathOperation.union).path(size);
  }
  //
  @override
  Paint get paint => Paint()
    ..style = PaintingStyle.fill
    ..color = _color
    ..isAntiAlias = true;
}