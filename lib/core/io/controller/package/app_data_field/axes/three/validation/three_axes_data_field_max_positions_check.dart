import 'package:stewart_platform_control/core/io/controller/package/app_data_field/axes/three/three_axes_data_field.dart';
import 'package:stewart_platform_control/core/validation/validation_case.dart';
///
class ThreeAxesDataMaxPositionsCheck implements ValidationCase<ThreeAxesDataField> {
  final int _maxPosition;
  ///
  const ThreeAxesDataMaxPositionsCheck({
    required int maxPosition,
  }) : _maxPosition = maxPosition;
  //
  @override
  bool isSatisfiedBy(ThreeAxesDataField field) {
    print('Max position $_maxPosition');
    final position = field.position;
    return [position.x, position.y, position.z]
      .every((coord) => coord < _maxPosition);
  }
}