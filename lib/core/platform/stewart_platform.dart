import 'dart:async';
import 'dart:developer';
import 'dart:math' hide log;
import 'package:stewart_platform_control/core/io/controller/mdbox_controller.dart';
import 'package:stewart_platform_control/core/io/controller/package/app_control_field/object_channel.dart';
import 'package:stewart_platform_control/core/io/controller/package/app_data_field/axes/three/position_3f.dart';
import 'package:stewart_platform_control/core/io/controller/package/app_data_field/registers/reg_address.dart';
import 'package:stewart_platform_control/core/io/controller/package/app_data_field/registers/reg_data_field.dart';
import 'package:stewart_platform_control/core/io/controller/package/app_data_field/registers/reg_num.dart';
import 'package:stewart_platform_control/core/math/sine.dart';
///
class StewartPlatform {
  final MdboxController _controller;
  final Duration _controlFrequency;
  final Duration _reportFrequency;
  final void Function()? _onStartControl;
  final void Function()? _onStopControl;
  final _reportController = StreamController<Position3f>.broadcast();
  Timer? _controlTimer;
  Timer? _reportTimer;
  ///
  StewartPlatform({
    required Duration controlFrequency,
    required Duration reportFrequency,
    required MdboxController controller,
    void Function()? onStartControl,
    void Function()? onStopControl,
  }) :
    _controller = controller,
    _controlFrequency = controlFrequency,
    _reportFrequency = reportFrequency,
    _onStartControl = onStartControl,
    _onStopControl = onStopControl;
  ///
  Future<void> startFluctuations({
    required Sine xSine,
    required Sine ySine,
    required Sine zSine,
  }) async {
    _controlTimer?.cancel();
    _goOnBaselines(xSine, ySine, zSine);
    _controlTimer = Timer.periodic(_controlFrequency, (_) {
      final t =  DateTime.now().millisecondsSinceEpoch / 1000.0;
      _controller.sendPosition3f(
        Position3f.fromValue(
          x: xSine.of(t).floor(),
          y: ySine.of(t).floor(),
          z: zSine.of(t).floor(),
        ),
      );
    });
    _onStartControl?.call();
  }
  ///
  void startReportingPosition() {
    const encoderPulsesInMm = 1000 * 100;
    _controller.responseStream.listen((package) {
      final functionCode = package.controlField.functionCode.bytes.toList();
      if(functionCode == reportDX) {
        final dataField = package.dataField as RegDataField;
        final regData = dataField.regData.bytes.toList();
        if (regData.length == 6) {
          final position = Position3f.fromIterable(regData);
          _reportController.add(position.copyWith(
            x: (position.x / encoderPulsesInMm).round(),
            y: (position.y / encoderPulsesInMm).round(),
            z: (position.z / encoderPulsesInMm).round(),
          ));
        } else {
          log('Position reporting | invalud RegData: $regData');
        }
      }
    });
    _reportTimer?.cancel();
    _reportTimer = Timer.periodic(_reportFrequency, (_) {
      _controller.readRegister(
        RegDataField(
          regStart: RegAddress.fromOffset(6),
          regNum: RegNum.fromCount(1),
        ),
        const ObjectChannel.fromIterable(readingDX)
      );
    });
    _onStartControl?.call();
  }
  ///
  Future<void> _goOnBaselines(Sine xSine, Sine ySine, Sine zSine) async {
    const rampTimeForMeter = Duration(seconds: 10);
    _controller.sendPosition3f(
      Position3f.fromValue(
        x: 0,
        y: 0,
        z: 0,
      ),
      time: rampTimeForMeter,
    );
    await Future.delayed(rampTimeForMeter);
    final actualRampTime = Duration(
      milliseconds: (
        [xSine.baseline, ySine.baseline, zSine.baseline].reduce(max) / 1000 * rampTimeForMeter.inMilliseconds
      ).round(),
    );
    _controller.sendPosition3f(
      Position3f.fromValue(
        x: xSine.baseline.round(),
        y: ySine.baseline.round(),
        z: zSine.baseline.round(),
      ),
      time: actualRampTime,
    );
    await Future.delayed(actualRampTime);
  }
  ///
  Stream<Position3f> get platformPositions => _reportController.stream;
  ///
  void stop() {
    _controlTimer?.cancel();
    _reportTimer?.cancel();
    _onStopControl?.call();
  }
}