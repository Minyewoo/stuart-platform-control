import 'package:flutter/material.dart';
import 'package:stewart_platform_control/presentation/platform_control/widgets/fluctuation_center/fluctuaction_center_picker_builder.dart';
///
class FluctuationTopProjection extends StatelessWidget {
  final double _realPlatformDimention;
  final double _pointSize;
  final ValueNotifier<Offset> _fluctuationCenter;
  ///
  const FluctuationTopProjection({
    super.key,
    required ValueNotifier<Offset> fluctuationCenter,
    required double realPlatformDimention,
    double pointSize = 9.0,
  }) : 
    _realPlatformDimention = realPlatformDimention,
    _pointSize = pointSize,
    _fluctuationCenter = fluctuationCenter;
  //
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: FluctuationCenterPickerBuilder(
        realPlatformDimention: _realPlatformDimention,
        fluctuationCenter: _fluctuationCenter,
        builder: (context, _, __, coordsFactor) {
          return Stack(
            children: [
              const SizedBox.expand(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 1,
                  child: SizedBox.expand(
                    child: ColoredBox(
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: 1,
                  child: SizedBox.expand(
                    child: ColoredBox(
                      color: Colors.blueAccent,
                    ),
                  ),
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
                      color: Colors.purpleAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
