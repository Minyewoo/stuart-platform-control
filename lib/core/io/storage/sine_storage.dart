import 'package:shared_preferences/shared_preferences.dart';
import 'package:stewart_platform_control/core/io/storage/storage.dart';
import 'package:stewart_platform_control/core/math/sine.dart';
///
class SineStorage implements Storage<Sine> {
  final SharedPreferences _preferences;
  final String _keysPsrefix;
  @override
  final defaultValue = const Sine(
      amplitude: 20.0,
      period: 2.0,
      phaseShift: 0.0,
  );
  ///
  const SineStorage({
    required SharedPreferences preferences,
    required String keysPsrefix,
  }) : 
    _keysPsrefix = keysPsrefix,
    _preferences = preferences;
  //
  @override
  Future<void> store(Sine newValue) async {
    final fields = {
      'amplitude': newValue.amplitude,
      'period': newValue.period,
      'phaseShift': newValue.phaseShift,
      'baseline': newValue.baseline,
    };
    for (final MapEntry(:key, :value) in fields.entries) {
       await _preferences.setDouble('$_keysPsrefix$key', value);
    }
  }
  //
  @override
  Future<Sine> retrieve() async {
    return Sine(
      amplitude: _preferences.getDouble('${_keysPsrefix}amplitude') ?? defaultValue.amplitude,
      period: _preferences.getDouble('${_keysPsrefix}period') ?? defaultValue.period,
      phaseShift: _preferences.getDouble('${_keysPsrefix}phaseShift') ?? defaultValue.phaseShift,
      baseline: _preferences.getDouble('${_keysPsrefix}baseline'),
    );
  }
} 