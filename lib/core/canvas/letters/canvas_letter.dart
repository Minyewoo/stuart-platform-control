import 'package:flutter/painting.dart';
import 'package:stewart_platform_control/core/canvas/canvas_item.dart';
import 'package:stewart_platform_control/core/canvas/letters/canvas_x_letter.dart';
import 'package:stewart_platform_control/core/canvas/letters/canvas_y_letter.dart';
import 'package:stewart_platform_control/core/canvas/letters/canvas_z_letter.dart';
///
enum CanvasLetterName {
  x,
  y,
  z,
}
///
class CanvasLetter implements CanvasItem {
  final CanvasLetterName _name; 
  final Color _color;
  final double _strokeWidth;
  ///
  const CanvasLetter({
    required Color color,
    double strokeWidth = 1.0,
    CanvasLetterName name = CanvasLetterName.x,
  }) : 
    _color = color,
    _name = name,
    _strokeWidth = strokeWidth;
  //
  @override
  Path path(Size size) => switch(_name) {
    CanvasLetterName.x => CanvasXLetter(
      color: _color,
      strokeWidth: _strokeWidth,
    ).path(size),
    CanvasLetterName.y => CanvasYLetter(
      color: _color,
      strokeWidth: _strokeWidth,
    ).path(size),
    CanvasLetterName.z => CanvasZLetter(
      color: _color,
      strokeWidth: _strokeWidth,
    ).path(size),
  };
  //
  @override
  Paint get paint => Paint()
    ..style = PaintingStyle.fill
    ..color = _color
    ..isAntiAlias = true;
}