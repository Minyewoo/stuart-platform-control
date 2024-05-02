import 'package:flutter/material.dart';

///
class FluctuationPointPicker extends StatelessWidget {
  final double _realPlatformDimention;
  final double _pointSize;
  final ValueNotifier<Offset> _fluctuationCenter;
  ///
  const FluctuationPointPicker({
    super.key,
    required ValueNotifier<Offset> fluctuationCenter,
    required double realPlatformDimention,
    double pointSize = 9.0, 
  }) : 
    _realPlatformDimention = realPlatformDimention,
    _pointSize = pointSize,
    _fluctuationCenter = fluctuationCenter;
  //
  void _updateFluctuationCenter(Offset newCenter, double factor) {
    _fluctuationCenter.value = Offset(
      (newCenter.dx*factor).clamp(0.0, _realPlatformDimention).roundToDouble(),
      (newCenter.dy*factor).clamp(0.0, _realPlatformDimention).roundToDouble(),
    );
  }
  //
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              const Text('Центр колебаний: '),
              const Spacer(),
              ValueListenableBuilder(
                valueListenable: _fluctuationCenter,
                builder: (context, center, _) => Text(
                  '(${center.dx.toStringAsFixed(0)}, ${center.dy.toStringAsFixed(0)})',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        AspectRatio(
          aspectRatio: 1.0,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final widgetDimension = constraints.maxWidth;
              final coordsFactor = _realPlatformDimention/widgetDimension;
              return GestureDetector(
                onTapDown: (details) => _updateFluctuationCenter(details.localPosition, coordsFactor),
                onVerticalDragUpdate: (details) => _updateFluctuationCenter(details.localPosition, coordsFactor),
                onHorizontalDragUpdate: (details) => _updateFluctuationCenter(details.localPosition, coordsFactor),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: _fluctuationCenter,
                      builder: (context, center, _) => Positioned(
                        top: center.dy/coordsFactor - _pointSize/2,
                        left: center.dx/coordsFactor - _pointSize/2,
                        child: Container(
                          width: _pointSize,
                          height: _pointSize,
                          decoration: const BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
