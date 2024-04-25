import 'package:shared_preferences/shared_preferences.dart';
import 'package:stewart_platform_control/core/math/sine.dart';
///
class SineStorage {
  ///
  const SineStorage();
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
    const defaultSine = Sine();
    return Sine(
      amplitude: prefs.getDouble('${prefix}amplitude') ?? defaultSine.amplitude,
      period: prefs.getDouble('${prefix}period') ?? defaultSine.period,
      phaseShift: prefs.getDouble('${prefix}phaseShift') ?? defaultSine.phaseShift,
      baseline: prefs.getDouble('${prefix}baseline'),
    );
  }
} 