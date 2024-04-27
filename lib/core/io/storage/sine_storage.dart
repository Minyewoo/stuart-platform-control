import 'package:shared_preferences/shared_preferences.dart';
import 'package:stewart_platform_control/core/math/sine.dart';
///
class SineStorage {
  final Sine _defaultSine;
  ///
  const SineStorage({
    Sine defaultSine = const Sine(
      amplitude: 20.0,
      period: 2.0,
      phaseShift: 0.0,
    ),
  }) : _defaultSine = defaultSine;
  ///
  void storeSine(String prefix, Sine sine, SharedPreferences prefs) {
    final fields = {
      'amplitude': sine.amplitude,
      'period': sine.period,
      'phaseShift': sine.phaseShift,
      'baseline': sine.baseline,
    };
    for (final MapEntry(:key, :value) in fields.entries) {
       prefs.setDouble('$prefix$key', value);
    }
  }
  ///
  Sine retrieveSine(String prefix, SharedPreferences prefs) {
    return Sine(
      amplitude: prefs.getDouble('${prefix}amplitude') ?? _defaultSine.amplitude,
      period: prefs.getDouble('${prefix}period') ?? _defaultSine.period,
      phaseShift: prefs.getDouble('${prefix}phaseShift') ?? _defaultSine.phaseShift,
      baseline: prefs.getDouble('${prefix}baseline'),
    );
  }
} 