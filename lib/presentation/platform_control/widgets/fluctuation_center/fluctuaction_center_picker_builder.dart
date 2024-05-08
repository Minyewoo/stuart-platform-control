import 'package:flutter/material.dart';
import 'package:stewart_platform_control/core/math/min_max.dart';
import 'package:stewart_platform_control/presentation/platform_control/widgets/fluctuation_center/fluctuation_side_projection.dart';
///
class FluctuationCenterPickerBuilder extends StatelessWidget {
  final MinMax _borderValues;
  final ValueNotifier<Offset> _fluctuationCenter;
  final double _realPlatformDimention;
  final double _centerOffset;
  final RotationAxis _projectionType;
  final Widget Function(BuildContext, BoxConstraints, Offset, double)? _builder;
  final bool _isInteractive;
  final double _reverseFactor;
  ///
  FluctuationCenterPickerBuilder({
    super.key,
    required double realPlatformDimention,
    required ValueNotifier<Offset> fluctuationCenter,
    RotationAxis projectionType = RotationAxis.both,
    bool isInteractive = true,
    bool isAxisReversed = false,
    MinMax? borderValues,
    Widget Function(
      BuildContext context,
      BoxConstraints constraints,
      Offset fluctuationCenter,
      double coordsFactor,
    )? builder,
  }) :
    _fluctuationCenter = fluctuationCenter,
    _projectionType = projectionType, 
    _builder = builder,
    _borderValues = borderValues ??  MinMax(min: -realPlatformDimention/2, max: realPlatformDimention/2),
    _isInteractive = isInteractive,
    _reverseFactor = isAxisReversed ? -1 : 1,
    _realPlatformDimention = realPlatformDimention,
    _centerOffset = realPlatformDimention/2;
  //
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder:(context, constraints) {
        final widgetDimension = constraints.maxWidth;
        final coordsFactor = _realPlatformDimention/widgetDimension;
        return GestureDetector(
          onTapDown: _isInteractive ? (details) => _updateFluctuationCenter(
            details.localPosition,
            coordsFactor,
          ) : null,
          onVerticalDragUpdate: _isInteractive ? (details) => _updateFluctuationCenter(
            details.localPosition,
            coordsFactor,
          ) : null,
          onHorizontalDragUpdate: _isInteractive ? (details) => _updateFluctuationCenter(
            details.localPosition,
            coordsFactor,
          ) : null,
          child: ValueListenableBuilder(
            valueListenable: _fluctuationCenter,
            builder: (context, fluctuationCenter, _) {
              // final coordsFactor = _realPlatformDimention/widgetDimension;
              return _builder?.call(
                context,
                constraints,
                (fluctuationCenter*_reverseFactor+Offset(_centerOffset, _centerOffset))/coordsFactor,
                coordsFactor,
              ) ?? const SizedBox();
            }
          ),
        );
      },
    );
  }
  ///
  void _updateFluctuationCenter(Offset newCenter, double factor) {
    print(newCenter);
    final newOffset = (newCenter*factor-Offset(_centerOffset, _centerOffset));
    final clampedOffset = Offset(
      newOffset.dx.clamp(_borderValues.min, _borderValues.max).roundToDouble(),
      newOffset.dy.clamp(_borderValues.min, _borderValues.max).roundToDouble(),
    );
    _fluctuationCenter.value = switch(_projectionType){
      RotationAxis.x => Offset(clampedOffset.dx*_reverseFactor, _fluctuationCenter.value.dy),
      RotationAxis.y => Offset(_fluctuationCenter.value.dx, clampedOffset.dy*_reverseFactor),
      RotationAxis.both => Offset(clampedOffset.dx, clampedOffset.dy),
    };
  }
}