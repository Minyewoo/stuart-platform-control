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
    _borderValues = borderValues == null 
      ? MinMax(min: -realPlatformDimention*1000/2, max: realPlatformDimention*1000/2) 
      : MinMax(min: borderValues.min*1000, max: borderValues.max*1000),
    _isInteractive = isInteractive,
    _reverseFactor = isAxisReversed ? -1 : 1,
    _realPlatformDimention = realPlatformDimention*1000,
    _centerOffset = realPlatformDimention*1000/2;
  //
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder:(context, constraints) {
        final widgetDimension = constraints.maxWidth;
        final coordsFactor = _realPlatformDimention/(widgetDimension);
        return GestureDetector(
          onTapDown: _isInteractive ? (details) => _updateFluctuationCenter(
            details.localPosition.dx,
            coordsFactor,
          ) : null,
          onVerticalDragUpdate: _isInteractive ? (details) => _updateFluctuationCenter(
            details.localPosition.dx,
            coordsFactor,
          ) : null,
          onHorizontalDragUpdate: _isInteractive ? (details) => _updateFluctuationCenter(
            details.localPosition.dx,
            coordsFactor,
          ) : null,
          child: ValueListenableBuilder(
            valueListenable: _fluctuationCenter,
            builder: (context, fluctuationCenter, _) {
              // final coordsFactor = _realPlatformDimention/widgetDimension;
              return _builder?.call(
                context,
                constraints,
                (fluctuationCenter*1000*_reverseFactor+Offset(_centerOffset, _centerOffset))/coordsFactor,
                coordsFactor,
              ) ?? const SizedBox();
            }
          ),
        );
      },
    );
  }
  ///
  void _updateFluctuationCenter(double newCenterOffset, double factor) {
    final newOffset = newCenterOffset*factor-_centerOffset;
    // print(newOffset);
    // print('${_borderValues.min}, ${_borderValues.max}',);
    final clampedOffset = newOffset.clamp(_borderValues.min, _borderValues.max).roundToDouble();
    _fluctuationCenter.value = switch(_projectionType){
      RotationAxis.x => Offset(clampedOffset*_reverseFactor/1000, _fluctuationCenter.value.dy),
      RotationAxis.y => Offset(_fluctuationCenter.value.dx, clampedOffset*_reverseFactor/1000),
      RotationAxis.both => Offset(clampedOffset, clampedOffset)/1000,
    };
    // print(_fluctuationCenter.value);
  }
}