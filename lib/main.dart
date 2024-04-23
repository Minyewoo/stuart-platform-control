import 'package:flutter/material.dart';
import 'package:stuart_platform_control/presentation/platform_control/platform_control_page.dart';
//
void main() {
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
      home: const PlatformControlPage(),
      theme: ThemeData.dark(),
    );
  }
}
