import 'package:flutter/material.dart';
import 'package:stewart_platform_control/core/math/min_max.dart';
import 'package:stewart_platform_control/presentation/platform_control/widgets/sines/angle_sine_control_widget.dart';
import 'package:stewart_platform_control/presentation/platform_control/widgets/sines/extraction_sine_control_widget.dart';
import 'package:stewart_platform_control/presentation/platform_control/widgets/sines/min_max_notifier.dart';
import 'package:stewart_platform_control/presentation/platform_control/widgets/sines/sine_notifier.dart';

///
class PlatformAngleSines extends StatelessWidget {
  final bool _isDisabled;
  final SineNotifier _baseline;
  final SineNotifier _rotationAngleX;
  final SineNotifier _rotationAngleY;
  final MinMaxNotifier _anglesMinMax;
  final MinMaxNotifier _baselineMinMax;
  ///
  const PlatformAngleSines({
    super.key,
    required SineNotifier baseline,
    required SineNotifier rotationAngleX,
    required SineNotifier rotationAngleY,
    required MinMaxNotifier anglesMinMax,
    required MinMaxNotifier baselineMinMax,
    bool isDisabled = false,
  }) :
    _baseline = baseline,
    _rotationAngleX = rotationAngleX,
    _rotationAngleY = rotationAngleY,
    _anglesMinMax = anglesMinMax,
    _baselineMinMax = baselineMinMax,
    _isDisabled = isDisabled;
  //
  @override
  Widget build(BuildContext context) {
    const chartsPadding = EdgeInsets.only(top: 8.0, right: 16.0);
    const angleAmplitudeConstraints = MinMax(
      min: 0,
      max: 20,
    );
    const baselineAmplitudeConstraints = MinMax(
      min: 0,
      max: 400,
    );
    const periodConstraints = MinMax(
      min: 1,
      max: 10,
    );
    const phaseShiftConstraints = MinMax(
      min: 0,
      max: 180,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: chartsPadding,
              child: AngleSineControlWidget(
                sineColor: Colors.redAccent,
                minMaxNotifier: _anglesMinMax,
                amplitudeConstraints: angleAmplitudeConstraints,
                perionConstraints: periodConstraints,
                phaseShiftConstraints: phaseShiftConstraints,
                title: 'φ_y',
                sineNotifier: _rotationAngleY,
                isDisabled: _isDisabled,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: chartsPadding,
              child: AngleSineControlWidget(
                sineColor: Colors.blueAccent,
                minMaxNotifier: _anglesMinMax,
                amplitudeConstraints: angleAmplitudeConstraints,
                perionConstraints: periodConstraints,
                phaseShiftConstraints: phaseShiftConstraints,
                title: 'φ_x',
                sineNotifier: _rotationAngleX,
                isDisabled: _isDisabled,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: chartsPadding,
              child: ExtractionSineControlWidget(
                minMaxNotifier: _baselineMinMax,
                amplitudeConstraints: baselineAmplitudeConstraints,
                perionConstraints: periodConstraints,
                phaseShiftConstraints: phaseShiftConstraints,
                title: 'Уровень',
                sineNotifier: _baseline,
                isDisabled: _isDisabled,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
