
import 'package:flutter/material.dart';
import 'package:stewart_platform_control/core/math/min_max.dart';
///
class ParameterSlider<T> extends StatelessWidget {
  final int? _divisions;
  final MinMax _minMax;
  final String _label;
  final String _valueUnit;
  final ValueNotifier<T> _valueNotifier;
  final double Function(T) _sliderValueBuilder;
  final String Function(T)? _displayValueBuilder;
  final void Function(double)? _onChanged;
  ///
  const ParameterSlider({
    super.key,
    required ValueNotifier<T> valueNotifier,
    required double Function(T value) sliderValueBuilder, 
    String Function(T value)? displayValueBuilder,
    required MinMax minMax,
    String label = '', 
    String valueUnit = '', 
    int? divisions, 
    void Function(double value)? onChanged, 
  }) : 
    _sliderValueBuilder = sliderValueBuilder, 
    _displayValueBuilder = displayValueBuilder,
    _divisions = divisions, 
    _minMax = minMax,
    _onChanged = onChanged,
    _valueUnit = valueUnit,
    _label = label,
    _valueNotifier = valueNotifier;
  //
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T>(
      valueListenable: _valueNotifier,
      builder: (context, value, child) {
        final sliderValue = _sliderValueBuilder(value);
        final displayValue = _displayValueBuilder?.call(value) ?? sliderValue.toString();
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Text(
                    _label,
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                  ),
                ),
                const Spacer(),
                Expanded(
                  flex: 5,
                  child: Text('$displayValue$_valueUnit'),
                ),
              ],
            ),
            Slider(
              
              value: sliderValue,
              min: _minMax.min,
              max: _minMax.max,
              divisions: _divisions,
              onChanged: _onChanged,
            ),
          ],
        );
      }
    );
  }
}