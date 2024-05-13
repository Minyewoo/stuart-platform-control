import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:stewart_platform_control/core/config/config.dart';
///
class FileConfig {
  final TextFile _file;
  ///
  const FileConfig({
    required TextFile file,
  }) : _file = file;
  ///
  Future<Config> read() async {
    final content = await _file.content;
    return switch(content) {
      Ok(value: final str) => switch(await JsonMap.fromString(str).decoded) {
        Ok(value: final map) => Config.fromMap(map),
        Err() => const Config(),
      },
      Err() => const Config(),
    };
  }
}