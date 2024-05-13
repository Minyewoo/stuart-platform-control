import 'package:flutter/rendering.dart';
import 'package:stewart_platform_control/core/canvas/canvas_item.dart';
///
class CanvasItemsPainter extends CustomPainter {
  final Iterable<CanvasItem> _items;
  ///
  const CanvasItemsPainter({
    super.repaint,
    required Iterable<CanvasItem> items,
  }) : _items = items;
  //
  @override
  void paint(Canvas canvas, Size size) {
    for(final item in _items) {
      canvas.drawPath(item.path(size), item.paint);
    }
  }
  //
  @override
  bool shouldRepaint(covariant CanvasItemsPainter oldDelegate) {
    return !oldDelegate._items.toSet().containsAll(_items);
  }
}