import 'package:stewart_platform_control/core/io/controller/package/app_data_field/axes/three/three_axes_data_field.dart';
import 'package:stewart_platform_control/core/validation/validation_case.dart';
///
class ThreeAxesDataPositionsDeltaCheck implements ValidationCase<ThreeAxesDataField> {
  final int _maxDelta;
  ///
  const ThreeAxesDataPositionsDeltaCheck({
    required int maxDelta,
  }) : _maxDelta = maxDelta;
  //
  @override
  bool isSatisfiedBy(ThreeAxesDataField field) {
    final position = field.position;
    final coords = [position.x, position.y, position.z];
    return coords.every(
      (coord) => coords.every(
        (otherCoord) => _isDeltaValid(coord, otherCoord),
      ),
    );
  }
  ///
  bool _isDeltaValid(int coord, int otherCoord) {
    return (coord - otherCoord).abs() < _maxDelta;
  }
}