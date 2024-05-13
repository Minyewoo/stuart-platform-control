import 'package:stewart_platform_control/core/io/controller/package/app_data_field/axes/three/three_axes_data_field.dart';
import 'package:stewart_platform_control/core/validation/validation_case.dart';
///
class ThreeAxesDataFieldMaxTimeCheck implements ValidationCase<ThreeAxesDataField> {
  final Duration _maxTime;
  ///
  const ThreeAxesDataFieldMaxTimeCheck({
    required Duration maxTime,
  }) : _maxTime = maxTime;
  //
  @override
  bool isSatisfiedBy(ThreeAxesDataField field) {
    return field.time <= _maxTime.inMilliseconds;
  }
}