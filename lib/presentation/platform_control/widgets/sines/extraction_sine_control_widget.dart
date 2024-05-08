import 'dart:math';
import 'package:flutter/material.dart';
import 'package:stewart_platform_control/core/math/min_max.dart';
import 'package:stewart_platform_control/core/math/sine.dart';
import 'package:stewart_platform_control/presentation/platform_control/widgets/sines/parameter_slider.dart';
import 'package:stewart_platform_control/presentation/platform_control/widgets/sines/sine_chart.dart';
import 'package:vector_math/vector_math_64.dart';
///
class ExtractionSineControlWidget extends StatelessWidget {
  final MinMax _amplitudeConstraints;
  final MinMax _perionConstraints;
  final MinMax _phaseShiftConstraints;
  final String _title;
  final ValueNotifier<Sine> _sineNotifier;
  final ValueNotifier<MinMax> _minMaxNotifier;
  final bool _isDisabled;
  ///
  const ExtractionSineControlWidget({
    super.key, 
    required ValueNotifier<Sine> sineNotifier,
    required MinMax amplitudeConstraints,
    required MinMax perionConstraints,
    required MinMax phaseShiftConstraints,
    required ValueNotifier<MinMax> minMaxNotifier,
    String title = '',
    bool isDisabled = false,
  }) : 
    _phaseShiftConstraints = phaseShiftConstraints,
    _perionConstraints = perionConstraints,
    _amplitudeConstraints = amplitudeConstraints,
    _title = title,
    _isDisabled = isDisabled,
    _minMaxNotifier = minMaxNotifier,
    _sineNotifier = sineNotifier;
  //
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            if(_title.isNotEmpty)
              ...[
                const SizedBox(width: 16),
                Text(
                  _title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: _sineNotifier,
                      builder: (context, sine, child) {
                        return ParameterSlider(
                          label: 'Амплитуда',
                          valueNotifier: _sineNotifier,
                          minMax: MinMax(
                            min: _amplitudeConstraints.min,
                            max: _amplitudeConstraints.max,
                          ),
                          divisions: (_amplitudeConstraints.max - _amplitudeConstraints.min).floor(),
                          sliderValueBuilder: (sine) => sine.amplitude*1000,
                          displayValueBuilder: (sine) => (sine.amplitude*1000).toStringAsFixed(0),
                          valueUnit: 'мм',
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
                      divisions: (_perionConstraints.max - _perionConstraints.min).floor(),
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
                      divisions: ((_phaseShiftConstraints.max - _phaseShiftConstraints.min)/5).floor(),
                      sliderValueBuilder: (sine) => double.parse((sine.phaseShift*radians2Degrees).toStringAsFixed(0)),
                      displayValueBuilder: (sine) => (sine.phaseShift*radians2Degrees).toStringAsFixed(0),
                      valueUnit: '°',
                      onChanged: _isDisabled ? null : _changePhaseShift,
                    ),
                  ),
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: _minMaxNotifier,
                      builder: (context, minMax, child) {
                        return ParameterSlider(
                          label: 'Среднее',
                          valueNotifier: _sineNotifier,
                          minMax: MinMax(
                            min: minMax.min,
                            max: minMax.max,
                          ),
                          divisions: (minMax.max - minMax.min).floor(),
                          sliderValueBuilder: (sine) => sine.baseline*1000,
                          displayValueBuilder: (sine) => (sine.baseline*1000).toStringAsFixed(0),
                          valueUnit: 'мм',
                          onChanged: _isDisabled ? null : _changeBaseline,
                        );
                      }
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Expanded(
          child: SineChart(
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
      amplitude: value/1000,
    );
  }
  //
  void _changeBaseline(double value) {
    _sineNotifier.value = _sineNotifier.value.copyWith(
      baseline: value/1000,
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
      phaseShift: _degreesToRadians(value),
    );
  }
  //
  double _degreesToRadians(double degrees) => degrees*pi/180;
}