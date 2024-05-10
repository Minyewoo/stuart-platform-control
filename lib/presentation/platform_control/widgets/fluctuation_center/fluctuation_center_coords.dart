import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stewart_platform_control/presentation/platform_control/widgets/fluctuation_center/colored_coords.dart';
///
class FluctuationCenterCoords extends StatelessWidget {
  static const _millimetersInMeter = 1000;
  final ValueListenable<Offset> _fluctuationCenter;
  ///
  const FluctuationCenterCoords({
    super.key,
    required ValueListenable<Offset> fluctuationCenter,
  }) : _fluctuationCenter = fluctuationCenter;
  //
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _fluctuationCenter,
      builder: (context, center, _) => ColoredCoords(
        xText: TextSpan(
          text: (center.dy*_millimetersInMeter).toStringAsFixed(0),
          style: const TextStyle(color: Colors.redAccent)
        ),
        yText: TextSpan(
          text: (center.dx*_millimetersInMeter).toStringAsFixed(0),
          style: const TextStyle(color: Colors.blueAccent)
        ),
      ),
    );
  }
}
