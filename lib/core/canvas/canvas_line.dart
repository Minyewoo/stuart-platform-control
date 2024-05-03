import 'package:flutter/painting.dart';
import 'package:stewart_platform_control/core/canvas/canvas_item.dart';
import 'package:stewart_platform_control/core/canvas/canvas_item_dimension.dart';
///
class CanvasLine implements CanvasItem {
  final Color _color;
  final double _strokeWidth;
  final CanvasItemDimension _width;
  ///
  CanvasLine({
    required Color color,
    required double strokeWidth,
    CanvasItemDimension width = const CanvasItemDimension.sizedFromCanvas(),
  }) : 
    _strokeWidth = strokeWidth,
    _width = width,
    _color = color;
  //
  @override
  Path path(Size size) => Path()
    ..moveTo(0.0, 0.0)
    ..lineTo(
      switch(_width) {
        ValueSizedDimension(value:final width) => width,
        CanvasSizedDimension() => size.width,
      },
      0.0,
    );
  //
  @override
  Paint get paint => Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = _strokeWidth
    ..color = _color
    ..isAntiAlias = true;
}