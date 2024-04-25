import 'package:flutter/material.dart';
import 'package:stewart_platform_control/core/io/controller/mdbox_controller.dart';
import 'package:stewart_platform_control/core/net_address.dart';
import 'package:stewart_platform_control/presentation/platform_control/platform_control_page.dart';
import 'package:window_manager/window_manager.dart';
//
Future<void> main() async {
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
      home: const PlatformControlPage(
        controlFrequency: Duration(milliseconds: 10),
        controller: MdboxController(
          myAddress: NetAddress.localhost(8889),
          controllerAddress:  NetAddress.localhost(8889),
        ),
      ),
      theme: ThemeData.dark(),
    );
  }
}
