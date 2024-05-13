import 'dart:ui';
import 'package:stewart_platform_control/core/canvas/canvas_item.dart';
///
class CanvasScaledItem implements CanvasItem {
  final CanvasItem _item;
  ///
  const CanvasScaledItem(CanvasItem item) :
    _item = item;
  //
  @override
  Path path(Size size) {
    return _item.path(size)..close();
  }  
  //
  @override
  Paint get paint => _item.paint;
}