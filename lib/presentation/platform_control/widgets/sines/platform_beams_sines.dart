import 'package:flutter/material.dart';
import 'package:stewart_platform_control/core/math/min_max.dart';
import 'package:stewart_platform_control/presentation/platform_control/widgets/sines/min_max_notifier.dart';
import 'package:stewart_platform_control/presentation/platform_control/widgets/sines/sine_control_widget.dart';
import 'package:stewart_platform_control/presentation/platform_control/widgets/sines/sine_notifier.dart';

///
class PlatformBeamsSines extends StatelessWidget {
  final double _cilinderMaxHeight;
  final MinMax _amplitudeConstraints;
  final MinMax _periodConstraints;
  final MinMax _phaseShiftConstraints;
  final SineNotifier _axisXSineNotifier;
  final MinMaxNotifier _minMaxNotifier;
  final SineNotifier _axisYSineNotifier;
  final SineNotifier _axisZSineNotifier;
  ///
  const PlatformBeamsSines({
    super.key,
    required SineNotifier axisXSineNotifier,
    required MinMaxNotifier minMaxNotifier,
    required SineNotifier axisYSineNotifier,
    required SineNotifier axisZSineNotifier,
    required double cilinderMaxHeight,
    required MinMax amplitudeConstraints,
    required MinMax periodConstraints,
    required MinMax phaseShiftConstraints,
  }) :
    _axisXSineNotifier = axisXSineNotifier,
    _minMaxNotifier = minMaxNotifier,
    _axisYSineNotifier = axisYSineNotifier,
    _axisZSineNotifier = axisZSineNotifier,
    _cilinderMaxHeight = cilinderMaxHeight,
    _amplitudeConstraints = amplitudeConstraints,
    _periodConstraints = periodConstraints,
    _phaseShiftConstraints = phaseShiftConstraints;
  //
  @override
  Widget build(BuildContext context) {
    const chartsPadding = EdgeInsets.only(top: 8.0, right: 16.0);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: chartsPadding,
              child: SineControlWidget(
                cilinderMaxHeight: _cilinderMaxHeight,
                amplitudeConstraints: _amplitudeConstraints,
                perionConstraints: _periodConstraints,
                phaseShiftConstraints: _phaseShiftConstraints,
                title: 'Ось I (X)',
                sineNotifier: _axisXSineNotifier,
                minMaxNotifier: _minMaxNotifier,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: chartsPadding,
              child: SineControlWidget(
                cilinderMaxHeight: _cilinderMaxHeight,
                amplitudeConstraints: _amplitudeConstraints,
                perionConstraints: _periodConstraints,
                phaseShiftConstraints: _phaseShiftConstraints,
                title: 'Ось II (Y)',
                sineNotifier: _axisYSineNotifier,
                minMaxNotifier: _minMaxNotifier,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: chartsPadding,
              child: SineControlWidget(
                cilinderMaxHeight: _cilinderMaxHeight,
                amplitudeConstraints: _amplitudeConstraints,
                perionConstraints: _periodConstraints,
                phaseShiftConstraints: _phaseShiftConstraints,
                title: 'Ось III (Z)',
                sineNotifier: _axisZSineNotifier,
                minMaxNotifier: _minMaxNotifier,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
