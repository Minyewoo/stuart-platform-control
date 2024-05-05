import 'package:flutter/painting.dart';
import 'package:stewart_platform_control/core/canvas/canvas_item.dart';
import 'package:stewart_platform_control/core/canvas/canvas_item_dimension.dart';
///
enum CanvasLineDirection {
  vertical,
  horizontal,
  undefined,
}
///
class CanvasLine implements CanvasItem {
  final Color _color;
  final double _strokeWidth;
  final CanvasItemDimension _width;
  final CanvasLineDirection _direction;
  ///
  const CanvasLine({
    required Color color,
    required double strokeWidth,
    CanvasItemDimension width = const CanvasItemDimension.sizedFromCanvas(),
    CanvasLineDirection direction = CanvasLineDirection.undefined,
  }) : 
    _strokeWidth = strokeWidth,
    _width = width,
    _color = color,
    _direction = direction;
  //
  @override
  Path path(Size size) {
    final lineLength = switch(_width) {
      ValueSizedDimension(value:final length) => length,
      CanvasSizedDimension() => switch(_direction) {
        CanvasLineDirection.horizontal 
        || CanvasLineDirection.undefined => size.width,
        CanvasLineDirection.vertical => size.height,
      },
    };
    final destination = switch(_direction) {
      CanvasLineDirection.horizontal 
      || CanvasLineDirection.undefined => Offset(lineLength, 0.0),
      CanvasLineDirection.vertical => Offset(0.0, lineLength),
    };
    return Path()
      ..moveTo(0.0, 0.0)
      ..lineTo(destination.dx, destination.dy);
  }
  //
  @override
  Paint get paint => Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = _strokeWidth
    ..color = _color
    ..isAntiAlias = true;
}