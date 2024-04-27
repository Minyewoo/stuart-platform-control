import 'dart:async';
import 'package:stewart_platform_control/core/io/controller/mdbox_controller.dart';
import 'package:stewart_platform_control/core/io/controller/package/app_control_field/object_channel.dart';
import 'package:stewart_platform_control/core/io/controller/package/app_data_field/axes/three/position_3f.dart';
import 'package:stewart_platform_control/core/io/controller/package/app_data_field/registers/reg_address.dart';
import 'package:stewart_platform_control/core/io/controller/package/app_data_field/registers/reg_data_field.dart';
import 'package:stewart_platform_control/core/io/controller/package/app_data_field/registers/reg_num.dart';
import 'package:stewart_platform_control/core/io/controller/package/byte_sequence.dart';
import 'package:stewart_platform_control/core/math/sine.dart';
///
class StuartPlatform {
  final MdboxController _controller;
  final Duration _controlFrequency;
  final void Function()? _onStart;
  final void Function()? _onStop;
  Timer? _controlTimer;
  ///
  StuartPlatform({
    required Duration controlFrequency,
    required MdboxController controller,
    void Function()? onStart,
    void Function()? onStop,
  }) :
    _controller = controller,
    _controlFrequency = controlFrequency,
    _onStart = onStart,
    _onStop = onStop;
  ///
  void startFluctuations({
    required Sine xSine,
    required Sine ySine,
    required Sine zSine,
  }) {
    _controlTimer?.cancel();
    _controller.writeRegister(
      RegDataField(
        regStart: RegAddress.fromOffset(0),
        regNum: RegNum.fromCount(1),
        regData: const ByteSequence.fromIterable([0x00, 3]),
      ),
      const ObjectChannel.fromIterable(writingCX)
    );
    _controlTimer = Timer.periodic(_controlFrequency, (timer) {
      final t =  DateTime.now().millisecondsSinceEpoch / 1000.0;
      _controller.sendPosition3f(
        Position3f.fromValue(
          x: xSine.of(t).floor(),
          y: ySine.of(t).floor(),
          z: zSine.of(t).floor(),
        ),
      );
    });
    _onStart?.call();
  }
  void stop() {
    _controlTimer?.cancel();
    _onStop?.call();
  }
}