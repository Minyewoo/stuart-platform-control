import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
///
class SinusChart extends StatelessWidget {
  final double _amplitude;
  final double _period;
  final double _shift;
  final double _center;
  ///
  const SinusChart({
    super.key, 
    double amplitude = 1.0, 
    double period = 2*pi,
    double shift = 0.0,
    double center = 0.0,
  }) : 
    _amplitude = amplitude,
    _period = period,
    _shift = shift,
    _center = center;
  //
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            dotData: const FlDotData(show: false),
            isCurved: true,
            spots: List.generate(
              100, 
              (t) => FlSpot(t.toDouble(), _amplitude * sin(2*pi*(t - _shift) / _period) + _center),
            )
          ),
        ],
        titlesData: const FlTitlesData(
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
      ),
    );
  }
}