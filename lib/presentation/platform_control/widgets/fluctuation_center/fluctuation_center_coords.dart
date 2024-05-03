import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
///
class FluctuationCenterCoords extends StatelessWidget {
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
      builder: (context, center, _) => RichText(
        text: TextSpan(
          children: [
            const TextSpan(
              text: '(',
            ),
            TextSpan(
              text: center.dx.toStringAsFixed(0),
              style: const TextStyle(color: Colors.redAccent),
            ),
            const TextSpan(
              text: ', ',
            ),
            TextSpan(
              text: center.dy.toStringAsFixed(0),
              style: const TextStyle(color: Colors.blueAccent),
            ),
            const TextSpan(
              text: ')',
            ),
          ],
        ),
      ),
    );
  }
}