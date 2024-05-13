import 'package:flutter/material.dart';
import 'package:stewart_platform_control/core/io/controller/package/app_data_field/axes/three/position_3f.dart';
///
class PlatformBeamsPainter extends CustomPainter {
  final double _scaleY;
  final Position3i _position;
  ///
  const PlatformBeamsPainter({
    super.repaint,
    required Position3i position,
    double scaleY = 1.0,
  }) : 
    _position = position,
    _scaleY = scaleY;
  //
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.blue.shade400;
    const cilinderShellRadius = 15.0;
    final tirdPart = size.width / 3;
    final cilinderCenters = List.generate(3, (index) => (0.5 + index)*tirdPart);
    final positions = [_position.x, _position.y, _position.z];
    for (int i = 0; i<cilinderCenters.length; i++) {
      final center = cilinderCenters[i];
      canvas.drawRect(
        Rect.fromLTWH(
          center-cilinderShellRadius/2,
          size.height-positions[i]*_scaleY,
          cilinderShellRadius,
          positions[i]*_scaleY.toDouble(),
        ),
        paint..style = PaintingStyle.stroke,
      );
    }
    canvas.drawLine(
      Offset(cilinderCenters.first, size.height-positions.first*_scaleY),
      Offset(cilinderCenters.last,  size.height-positions.last*_scaleY),
      paint,
    );
  }
  //
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return ((oldDelegate as PlatformBeamsPainter)._position != _position);
  }
}