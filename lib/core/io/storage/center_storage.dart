import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stewart_platform_control/core/io/storage/storage.dart';
///
class CenterStorage implements Storage<Offset> {
  final SharedPreferences _preferences;
  final String _keysPsrefix;
  @override
  final Offset defaultValue = const Offset(0.0, 0.0);
  ///
  const CenterStorage({
    required SharedPreferences preferences,
    required keysPsrefix,
  }) :
    _preferences = preferences,
    _keysPsrefix = keysPsrefix;
  //
  @override
  Future<void> store(Offset newValue) async {
     final fields = {
      'dx': newValue.dx,
      'dy': newValue.dy,
    };
    for (final MapEntry(:key, :value) in fields.entries) {
      await _preferences.setDouble('$_keysPsrefix$key', value);
    }
  }
  //
  @override
  Future<Offset> retrieve() async {
    return Offset(
      _preferences.getDouble('${_keysPsrefix}dx') ?? defaultValue.dx,
      _preferences.getDouble('${_keysPsrefix}dy') ?? defaultValue.dy,
    );
  }
} 