import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:stuart_platform_control/core/math/min_max.dart';
import 'package:stuart_platform_control/core/math/sine.dart';
///
class SineChart extends StatelessWidget {
  final int _periodWindow;
  final ValueNotifier<Sine> _sineNotifier;
  final ValueNotifier<MinMax> _minMaxNotifier;
  ///
  const SineChart({
    super.key,
    required ValueNotifier<Sine> sineNotifier,
    required ValueNotifier<MinMax> minMaxNotifier,
    int periodWindow = 60,
  }) : 
    _periodWindow = periodWindow, 
    _sineNotifier = sineNotifier,
    _minMaxNotifier = minMaxNotifier;
  //
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _minMaxNotifier,
      builder: (context, minMax, child) => ValueListenableBuilder(
        valueListenable: _sineNotifier,
        builder: (context, sine, child) => LineChart(
          LineChartData(
            minY: minMax.min,
            maxY: minMax.max,
            lineBarsData: [
              LineChartBarData(
                barWidth: 2.0,
                dotData: const FlDotData(show: false),
                isCurved: true,
                spots: List.generate(
                  _periodWindow * 10,
                  (t) => FlSpot(t / 10, sine.of(t/10)),
                )
              ),
            ],
            titlesData: const FlTitlesData(
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
          ),
        ),
      ),
    );
  }
}