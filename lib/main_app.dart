import 'package:flutter/material.dart';
import 'package:stewart_platform_control/core/config/config.dart';
import 'package:stewart_platform_control/core/io/controller/mdbox_controller.dart';
import 'package:stewart_platform_control/presentation/platform_control/platform_control_page.dart';
///
class MainApp extends StatelessWidget {
  final Config _config;
  ///
  const MainApp({
    super.key,
    required Config config,
  }) : _config = config;
  //
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PlatformControlPage(
        cilinderMaxHeight: _config.cilinderMaxHeight,
        amplitudeConstraints: _config.amplitudeConstraints,
        periodConstraints: _config.periodConstraints,
        phaseShiftConstraints: _config.phaseShiftConstraints,
        controlFrequency: _config.controlFrequency,
        controller: MdboxController(
          myAddress: _config.myAddress,
          controllerAddress:  _config.controllerAddress,
        ),
      ),
      theme: ThemeData.dark(),
    );
  }
}
