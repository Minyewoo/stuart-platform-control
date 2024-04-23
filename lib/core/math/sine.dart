import 'dart:math';
import 'package:stuart_platform_control/core/math/min_max.dart';

/// 
/// Parameterized sine function
class Sine {
  final double amplitude;
  final double period;
  final double phaseShift;
  /// 
  /// Parameterized sine function
  const Sine({
    this.amplitude = 1.0, 
    this.period = 2*pi,
    this.phaseShift = 0.0,
  });
  ///
  /// Create new instance of [Sine] with slightly different parameters.
  Sine copyWith({
    double? amplitude, 
    double? period,
    double? phaseShift,
  }) => Sine(
    amplitude: amplitude ?? this.amplitude,
    period: period ?? this.period,
    phaseShift: phaseShift ?? this.phaseShift,
  );
  /// 
  /// Compute sine value of [t].
  double of(double t) => amplitude * sin(2*pi*t/period + phaseShift);

  ///
  /// Compute minimum and maximum values of the sine function.
  MinMax get minMax {
    final factor = period/(2*pi);
    const halfPi = pi/2;
    final t_0_1 = (-halfPi - phaseShift)*factor;
    final t_0_2 = (halfPi - phaseShift)*factor;
    final sine_0_1 = of(t_0_1);
    final sine_0_2 = of(t_0_2);
    return switch(sine_0_1 > sine_0_2) {
      true => MinMax(min: sine_0_2, max: sine_0_1),
      false => MinMax(min: sine_0_1, max: sine_0_2),
    };
  }
  //
  @override
  int get hashCode => amplitude.hashCode ^ period.hashCode ^ phaseShift.hashCode;
  //
  @override
  bool operator ==(Object other) {
    return other is Sine
      && amplitude == other.amplitude
      && period == other.period
      && phaseShift == other.phaseShift;
  }
}