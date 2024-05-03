import 'package:flutter/material.dart';
import 'package:stewart_platform_control/presentation/platform_control/widgets/fluctuation_center/fluctuaction_center_picker_builder.dart';
import 'package:stewart_platform_control/presentation/platform_control/widgets/fluctuation_center/fluctuation_side_projection_paint.dart';
///
enum ProjectionType {
  horizontal,
  vertical,
  both,
}
///
class FluctuationSideProjection extends StatelessWidget {
  final ValueNotifier<Offset> _rotation;
  final ProjectionType _type;
  final double _realPlatformDimention;
  final double _pointSize;
  final ValueNotifier<Offset> _fluctuationCenter;
  ///
  const FluctuationSideProjection({
    super.key,
    ProjectionType type = ProjectionType.horizontal,
    required double realPlatformDimention,
    required ValueNotifier<Offset> fluctuationCenter,
    required ValueNotifier<Offset> rotation,
    double pointSize = 9.0, 
  }) : 
    _rotation = rotation,
    _type = type,
    _realPlatformDimention = realPlatformDimention,
    _fluctuationCenter = fluctuationCenter,
    _pointSize = pointSize;
  //
  @override
  Widget build(BuildContext context) {
    const containerRadius = BorderRadius.all(Radius.circular(16));
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: containerRadius,
        border: Border.all(color: Theme.of(context).colorScheme.surfaceVariant),
      ),
      child: ClipRRect(
        borderRadius: containerRadius,
        child: FluctuationCenterPickerBuilder(
          realPlatformDimention: _realPlatformDimention,
          fluctuationCenter: _fluctuationCenter,
          projectionType: _type,
          builder: (context, constaints, fluctuationCenter, __) {
            return ValueListenableBuilder(
              valueListenable: _rotation,
              builder: (context, rotationAngle, _) {
                return FluctuationSideProjectionPaint(
                  accentColor: switch(_type) {
                    ProjectionType.horizontal => Colors.redAccent,
                    ProjectionType.vertical => Colors.blueAccent,
                    ProjectionType.both => Colors.purpleAccent,
                  },
                  fluctuationOffset: switch(_type) {
                    ProjectionType.horizontal => fluctuationCenter.dx,
                    ProjectionType.vertical => fluctuationCenter.dy,
                    ProjectionType.both => fluctuationCenter.dx,
                  },
                  rotationRadians: switch(_type) {
                    ProjectionType.horizontal => rotationAngle.dx,
                    ProjectionType.vertical => rotationAngle.dy,
                    ProjectionType.both => rotationAngle.dx,
                  },
                  pointSize: _pointSize,
                );
              }
            );
          }
        ),
      ),
    );
  }
}