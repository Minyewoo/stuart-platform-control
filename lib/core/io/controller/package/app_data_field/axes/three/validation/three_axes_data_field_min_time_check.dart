import 'package:stewart_platform_control/core/io/controller/package/app_data_field/axes/three/three_axes_data_field.dart';
import 'package:stewart_platform_control/core/validation/validation_case.dart';
///
class ThreeAxesDataFieldMinTimeCheck implements ValidationCase<ThreeAxesDataField> {
  final Duration _minTime;
  ///
  const ThreeAxesDataFieldMinTimeCheck({
    required Duration minTime,
  }) : _minTime = minTime;
  //
  @override
  bool isSatisfiedBy(ThreeAxesDataField field) {
    return field.time >= _minTime.inMilliseconds;
  }
}