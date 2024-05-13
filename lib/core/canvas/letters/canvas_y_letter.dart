import 'dart:math';

import 'package:flutter/painting.dart';
import 'package:stewart_platform_control/core/canvas/canvas_item.dart';
import 'package:stewart_platform_control/core/canvas/canvas_item_dimension.dart';
import 'package:stewart_platform_control/core/canvas/canvas_item_transformations.dart';
import 'package:stewart_platform_control/core/canvas/canvas_rect.dart';
import 'package:vector_math/vector_math_64.dart';
///
class CanvasYLetter implements CanvasItem {
  final Color _color;
  final double _strokeWidth;
  ///
  const CanvasYLetter({
    required Color color,
    double strokeWidth = 1.0,
  }) : 
    _color = color,
    _strokeWidth = strokeWidth;
  @override
  Path path(Size size) {
    const partLength = 30.0;
    const partRotation = 50*degrees2Radians;
    return [
      CanvasRect(
        color: _color,
        strokeWidth: _strokeWidth,
        width: const CanvasItemDimension.sizedFrom(partLength),
        direction: CanvasLineDirection.horizontal,
      )
      .rotate(partRotation)
      .translate(Offset(0.0, partLength*sin(partRotation))),
      CanvasRect(
        color: _color,
        strokeWidth: _strokeWidth,
        width: const CanvasItemDimension.sizedFrom(partLength/2),
        direction: CanvasLineDirection.horizontal,
      )
      .rotate(-50*degrees2Radians)
    ].combine(PathOperation.union).path(size);
  }
  //
  @override
  Paint get paint => Paint()
    ..style = PaintingStyle.fill
    ..color = _color
    ..isAntiAlias = true;
}