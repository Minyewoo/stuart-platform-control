import 'package:flutter/material.dart';
import 'package:stewart_platform_control/presentation/platform_control/widgets/fluctuation_center/fluctuation_side_projection.dart';
///
class FluctuationCenterPickerBuilder extends StatelessWidget {
  final ValueNotifier<Offset> _fluctuationCenter;
  final double _realPlatformDimention;
  final ProjectionType _projectionType;
  final Widget Function(BuildContext, BoxConstraints, Offset, double)? _builder;
  ///
  const FluctuationCenterPickerBuilder({
    super.key,
    required double realPlatformDimention,
    required ValueNotifier<Offset> fluctuationCenter,
    ProjectionType projectionType = ProjectionType.both,
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
    _realPlatformDimention = realPlatformDimention;
  //
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder:(context, constraints) {
        final widgetDimension = constraints.maxWidth;
        final coordsFactor = _realPlatformDimention/widgetDimension;
        return GestureDetector(
          onTapDown: (details) => _updateFluctuationCenter(
            details.localPosition,
            coordsFactor,
          ),
          onVerticalDragUpdate: (details) => _updateFluctuationCenter(
            details.localPosition,
            coordsFactor,
          ),
          onHorizontalDragUpdate: (details) => _updateFluctuationCenter(
            details.localPosition,
            coordsFactor,
          ),
          child: ValueListenableBuilder(
            valueListenable: _fluctuationCenter,
            builder: (context, fluctuationCenter, _) {
              // final coordsFactor = _realPlatformDimention/widgetDimension;
              return _builder?.call(
                context,
                constraints,
                fluctuationCenter/coordsFactor,
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
    final newDx = (newCenter.dx*factor).clamp(0.0, _realPlatformDimention).roundToDouble();
    final newDy = (newCenter.dy*factor).clamp(0.0, _realPlatformDimention).roundToDouble();
    _fluctuationCenter.value = switch(_projectionType){
      ProjectionType.horizontal => Offset(newDx, _fluctuationCenter.value.dy),
      ProjectionType.vertical =>Offset(_fluctuationCenter.value.dx, newDx),
      ProjectionType.both => Offset(newDx, newDy),
    };
  }
}