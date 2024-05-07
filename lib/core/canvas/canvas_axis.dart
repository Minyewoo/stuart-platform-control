import 'package:flutter/material.dart';
import 'package:stewart_platform_control/core/canvas/canvas_centered_item.dart';
import 'package:stewart_platform_control/core/canvas/canvas_item.dart';
import 'package:stewart_platform_control/core/canvas/canvas_item_dimension.dart';
import 'package:stewart_platform_control/core/canvas/canvas_item_transformations.dart';
import 'package:stewart_platform_control/core/canvas/canvas_rect.dart';
import 'package:stewart_platform_control/core/canvas/letters/canvas_letter.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
///
class CanvasAxis implements CanvasItem {
  final CanvasLetterName _letterName;
  final double _sharpnessAngle;
  final double _length;
  final double _strokeWidth;
  final Color _color;
  final CanvasLineDirection _direction;
  final bool _isReversed;
  ///
  const CanvasAxis({
    required CanvasLineDirection direction,
    CanvasLetterName letterName = CanvasLetterName.x,
    double sharpnessAngle = 0.0,
    double length = 10.0,
    double strokeWidth = 1.0,
    Color color = Colors.black,
    bool isReversed = false,
  }) :
    _sharpnessAngle = sharpnessAngle,
    _length = length,
    _strokeWidth = strokeWidth,
    _color = color,
    _letterName = letterName,
    _direction = direction,
    _isReversed = isReversed;
  //
  @override
  Path path(Size size) {
    final centeringDirection = switch(_direction) {
      CanvasLineDirection.vertical
      || CanvasLineDirection.undefined => CenteringDirection.horizontal,
      CanvasLineDirection.horizontal => CenteringDirection.vertical,
    };
    final letterOffset = switch(_direction) {
      CanvasLineDirection.vertical
      || CanvasLineDirection.undefined => const Offset(15, 10),
      CanvasLineDirection.horizontal => const Offset(10, -40),
    };
    final letterScale = switch(_isReversed) {
      true => const Offset(-1.0, 1.0),
      false => const Offset(1.0, 1.0),
    };
    final reversedLetterOffset =  switch(_isReversed) {
      true => const Offset(15, 0.0),
      false => const Offset(0.0, 0.0),
    };
    final item = [
      CanvasRect(
      color: _color,
      strokeWidth: _strokeWidth,
      direction: _direction,
      width: CanvasItemDimension.sizedFrom(_length)
    )
      .rotate(_sharpnessAngle*degrees2Radians),
      CanvasRect(
        color: _color,
        strokeWidth: _strokeWidth,
        direction: _direction,
        width: CanvasItemDimension.sizedFrom(_length)
      )
        .rotate(-_sharpnessAngle*degrees2Radians),
      CanvasRect(
        color: _color,
        strokeWidth: _strokeWidth,
        direction: _direction,
      )
    ].combine(PathOperation.union)
    .combine(
      CanvasLetter(
        strokeWidth: _strokeWidth,
        name: _letterName,
        color: _color,
      )
        .scale(letterScale)
        .translate(letterOffset+reversedLetterOffset),
      operation: PathOperation.union,
    );
    return (_isReversed ? item.mirror(_direction) : item)
      .center(centeringDirection)
      .path(size);
  }  
  //
  @override
  Paint get paint => Paint()
    ..style = PaintingStyle.fill
    ..color = _color
    ..isAntiAlias = true;
}