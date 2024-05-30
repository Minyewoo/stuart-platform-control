import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stewart_platform_control/core/config/file_config.dart';
import 'package:stewart_platform_control/main_app.dart';
import 'package:window_manager/window_manager.dart';
//
Future<void> main() async {
  hierarchicalLoggingEnabled = true;
  final log = const Log('main')..level=LogLevel.all;
  const fileConfig = FileConfig(
    file: TextFile.asset('assets/configs/app-config.json'),
  );
  const windowOptions = WindowOptions(
    title: 'Управление платформой Стюарта',
    minimumSize: Size(800, 600),
    size: Size(1280, 720),
    center: true,
    backgroundColor: Colors.black,
    fullScreen: false,
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
        },
      );
      final config = await fileConfig.read();
      final preferences = await SharedPreferences.getInstance();
      runApp(
        MainApp(
          config: config,
          preferences: preferences,
          chartsAppSocket: await RawDatagramSocket.bind(InternetAddress.loopbackIPv4, 4755),
        ),
      );
    },
    (error, stackTrace) => log.error(
      error.toString(),
      error,
      stackTrace,
    ),
  );
}
