import 'package:flutter/material.dart';
import 'package:stuart_platform_control/core/controller/mdbox_controller.dart';
import 'package:stuart_platform_control/core/net_address.dart';
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
      home: const PlatformControlPage(
        controlFrequency: Duration(milliseconds: 10),
        controller: MdboxController(
          myAddress: NetAddress.localhost(8888),
          controllerAddress: NetAddress.localhost(35),
        ),
      ),
      theme: ThemeData.dark(),
    );
  }
}
