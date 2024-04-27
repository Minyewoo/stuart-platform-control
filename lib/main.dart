import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:stewart_platform_control/core/io/controller/mdbox_controller.dart';
import 'package:stewart_platform_control/core/math/min_max.dart';
import 'package:stewart_platform_control/core/net_address.dart';
import 'package:stewart_platform_control/presentation/platform_control/platform_control_page.dart';
import 'package:window_manager/window_manager.dart';
//
Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await windowManager.ensureInitialized();
      WindowOptions windowOptions = const WindowOptions(
        title: 'Управление платформой Стюарта',
        minimumSize: Size(800, 600),
        size: Size(1280, 720),
        center: true,
        backgroundColor: Colors.black,
        fullScreen: true,
        skipTaskbar: false,
        titleBarStyle: TitleBarStyle.normal,
      );
      windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.show();
        await windowManager.focus();
      });
      runApp(const MainApp());
    },
    (error, stackTrace) => log('', error: error, stackTrace: stackTrace),
  );
}
///
class MainApp extends StatelessWidget {
  ///
  const MainApp({super.key});
  //
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PlatformControlPage(
        cilinderMaxHeight: 900,
        amplitudeConstraints: const MinMax(min: 0, max: 300),
        periodConstraints: const MinMax(min: 1, max: 30),
        phaseShiftConstraints: const MinMax(min: 0, max: 90),
        controlFrequency: const Duration(milliseconds: 10),
        controller: MdboxController(
          myAddress: const NetAddress(ipv4: '192.168.15.101', port:8410),
          // controllerAddress:  NetAddress(ipv4: '192.168.15.201', port: 8401),
          controllerAddress:  const NetAddress(ipv4: '192.168.15.201', port: 7408),
        ),
      ),
      theme: ThemeData.dark(),
    );
  }
}
