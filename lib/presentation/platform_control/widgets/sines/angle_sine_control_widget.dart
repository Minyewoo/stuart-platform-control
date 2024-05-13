import 'package:flutter/material.dart';
import 'package:stewart_platform_control/core/math/min_max.dart';
import 'package:stewart_platform_control/core/math/sine.dart';
import 'package:stewart_platform_control/presentation/platform_control/widgets/sines/parameter_slider.dart';
import 'package:stewart_platform_control/presentation/platform_control/widgets/sines/sine_chart.dart';
import 'package:vector_math/vector_math_64.dart';
///
class AngleSineControlWidget extends StatelessWidget {
  final Color? _sineColor;
  final MinMax<double> _amplitudeConstraints;
  final MinMax<double> _perionConstraints;
  final MinMax<double> _phaseShiftConstraints;
  final Widget? _title;
  final ValueNotifier<Sine> _sineNotifier;
  final ValueNotifier<MinMax>? _amplitudeMinMaxNotifier;
  final bool _isDisabled;
  ///
  const AngleSineControlWidget({
    super.key, 
    required ValueNotifier<Sine> sineNotifier,
    required MinMax<double> amplitudeConstraints,
    required MinMax<double> perionConstraints,
    required MinMax<double> phaseShiftConstraints,
    Color? sineColor,
    ValueNotifier<MinMax>? minMaxNotifier,
    Widget? title,
    bool isDisabled = false,
  }) :
    _sineColor = sineColor,
    _phaseShiftConstraints = phaseShiftConstraints,
    _perionConstraints = perionConstraints,
    _amplitudeConstraints = amplitudeConstraints,
    _title = title,
    _isDisabled = isDisabled,
    _amplitudeMinMaxNotifier = minMaxNotifier,
    _sineNotifier = sineNotifier;
  //
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            if(_title != null)
              ...[
                const SizedBox(width: 16),
                _title
              ],
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: _amplitudeMinMaxNotifier ?? ValueNotifier(_amplitudeConstraints),
                      builder: (context, minMax, _) {
                        return ParameterSlider(
                          minMax: _amplitudeConstraints,
                          label: 'Амплитуда',
                          valueNotifier: _sineNotifier,
                          divisions: (_amplitudeConstraints.max - _amplitudeConstraints.min).ceil(),
                          sliderValueBuilder: (sine) => double.parse((sine.amplitude*radians2Degrees).toStringAsFixed(0)),
                          displayValueBuilder: (sine) => (sine.amplitude*radians2Degrees).toStringAsFixed(0),
                          valueUnit: '°',
                          onChanged: _isDisabled ? null : _changeAmplitude,
                        );
                      }
                    ),
                  ),
                  Expanded(
                    child: ParameterSlider(
                      label: 'Период',
                      valueNotifier: _sineNotifier,
                      minMax: _perionConstraints,
                      divisions: (_perionConstraints.max - _perionConstraints.min).ceil(),
                      sliderValueBuilder: (sine) => sine.period,
                      displayValueBuilder: (sine) => sine.period.toStringAsFixed(0),
                      valueUnit: ' с',
                      onChanged: _isDisabled ? null : _changePeriod,
                    ),
                  ),
                  Expanded(
                    child: ParameterSlider(
                      label: 'Сдвиг фазы',
                      valueNotifier: _sineNotifier,
                      minMax: _phaseShiftConstraints,
                      divisions: ((_phaseShiftConstraints.max - _phaseShiftConstraints.min)/5).ceil(),
                      sliderValueBuilder: (sine) => double.parse((sine.phaseShift*radians2Degrees).toStringAsFixed(0)),
                      displayValueBuilder: (sine) => (sine.phaseShift*radians2Degrees).toStringAsFixed(0),
                      valueUnit: '°',
                      onChanged: _isDisabled ? null : _changePhaseShift,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Expanded(
          child: SineChart(
            minMaxNotifier: _amplitudeMinMaxNotifier,
            sineColor: _sineColor,
            factor: radians2Degrees,
            sineNotifier: _sineNotifier,
            periodWindow: _perionConstraints.max.floor(),
            pointsCountFactor: 30,
          ),
        ),
      ],
    );
  }
  //
  void _changeAmplitude(double value) {
    _sineNotifier.value = _sineNotifier.value.copyWith(
      amplitude: value*degrees2Radians,
    );
  }
  //
  void _changePeriod(double value) {
    _sineNotifier.value = _sineNotifier.value.copyWith(
      period: double.parse(value.toStringAsFixed(1)),
    );
  }
  //
  void _changePhaseShift(double value) {
    _sineNotifier.value = _sineNotifier.value.copyWith(
      phaseShift: value*degrees2Radians,
    );
  }
}