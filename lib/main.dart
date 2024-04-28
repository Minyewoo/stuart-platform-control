import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:stewart_platform_control/core/config/file_config.dart';
import 'package:stewart_platform_control/main_app.dart';
import 'package:window_manager/window_manager.dart';
//
Future<void> main() async {
  const log = Log('main');
  const fileConfig = FileConfig(
    file: TextFile.asset('assets/configs/app-config.json'),
  );
  const windowOptions = WindowOptions(
    title: 'Управление платформой Стюарта',
    minimumSize: Size(800, 600),
    size: Size(1280, 720),
    center: true,
    backgroundColor: Colors.black,
    fullScreen: true,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
  );
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await windowManager.ensureInitialized();
      windowManager.waitUntilReadyToShow(
        windowOptions, 
        () async {
          await windowManager.show();
          await windowManager.focus();
        },
      );
      final config = await fileConfig.read();
      runApp(MainApp(config: config));
    },
    (error, stackTrace) => log.error(
      error.toString(),
      error,
      stackTrace,
    ),
  );
}
