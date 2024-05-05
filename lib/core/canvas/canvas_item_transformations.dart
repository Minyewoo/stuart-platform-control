import 'package:flutter/painting.dart';
import 'package:stewart_platform_control/core/canvas/canvas_centered_item.dart';
import 'package:stewart_platform_control/core/canvas/canvas_item.dart';
import 'package:stewart_platform_control/core/canvas/canvas_rotated_line.dart';
import 'package:stewart_platform_control/core/canvas/canvas_translated_item.dart';
///
extension CanvasItemTransformations on CanvasItem {
  ///
  CanvasItem rotate(double rotationRadians) => CanvasRotatedItem(
    this,
    rotationRadians: rotationRadians,
  );
  ///
  CanvasItem rotateAroundPoint(double rotationRadians, Offset point) => this
    ..translate(Offset.zero-point)
    ..rotate(rotationRadians)
    ..translate(point);
  ///
  CanvasItem center({
    CenteringDirection direction = CenteringDirection.both,
  }) => CanvasCenteredItem(
    this,
    direction: direction,
  );
  ///
  CanvasItem translate(Offset translation) => CanvasTranslatedItem(
    this,
    translation: translation,
  );
}
///
extension CanvasItemIterableTransformations on Iterable<CanvasItem> {
  ///
  Iterable<CanvasItem> rotate(double rotationRadians) => map(
    (item) => item.rotate(rotationRadians),
  );
  ///
  Iterable<CanvasItem> center({
    CenteringDirection direction = CenteringDirection.both,
  }) => map(
    (item) => item.center(direction: direction),
  );
  ///
  Iterable<CanvasItem> translate(Offset translation) => map(
    (item) => item.translate(translation),
  );
}
