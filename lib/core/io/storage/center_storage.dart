import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stewart_platform_control/core/io/storage/storage.dart';
///
class CenterStorage implements Storage<Offset> {
  final SharedPreferences _preferences;
  final String _keysPrefix;
  @override
  final Offset defaultValue = const Offset(0.0, 0.0);
  ///
  const CenterStorage({
    required SharedPreferences preferences,
    required keysPrefix,
  }) :
    _preferences = preferences,
    _keysPrefix = keysPrefix;
  //
  @override
  Future<void> store(Offset newValue) async {
     final fields = {
      'dx': newValue.dx,
      'dy': newValue.dy,
    };
    for (final MapEntry(:key, :value) in fields.entries) {
      await _preferences.setDouble('$_keysPrefix$key', value);
    }
  }
  //
  @override
  Future<Offset> retrieve() async {
    return Offset(
      _preferences.getDouble('${_keysPrefix}dx') ?? defaultValue.dx,
      _preferences.getDouble('${_keysPrefix}dy') ?? defaultValue.dy,
    );
  }
} 