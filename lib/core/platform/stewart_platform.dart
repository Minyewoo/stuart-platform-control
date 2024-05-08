import 'dart:async';
import 'dart:math' hide log;
import 'package:flutter/cupertino.dart';
import 'package:stewart_platform_control/core/entities/cilinders_extractions.dart';
import 'package:stewart_platform_control/core/io/controller/mdbox_controller.dart';
import 'package:stewart_platform_control/core/io/controller/package/app_data_field/axes/three/position_3f.dart';
import 'package:stewart_platform_control/core/math/mapping/time_mapping.dart';
import 'package:stewart_platform_control/core/platform/platform_state.dart';
///
class StewartPlatform {
  final MdboxController _controller;
  final void Function()? _onStartControl;
  final void Function()? _onStopControl;
  TimeMapping<PlatformState>? _continousPosition;
  final _stateController = StreamController<PlatformState>.broadcast();
  ///
  StewartPlatform({
    required Duration controlFrequency,
    required Duration reportFrequency,
    required MdboxController controller,
    void Function()? onStartControl,
    void Function()? onStopControl,
  }) :
    _controller = controller,
    _onStartControl = onStartControl,
    _onStopControl = onStopControl;
  ///
  Stream<PlatformState> get state => _stateController.stream;
  ///
  Future<void> startFluctuations(TimeMapping<PlatformState> continousPosition) async {
    _continousPosition?.stop();
    _continousPosition = continousPosition;
    final starterPosition = _continousPosition!.of(0);
    await _extractBeamsToStarterPositions(
      starterPosition.beamsPosition,
      starterPosition.fluctuationAngles,
    );
    _continousPosition!.start();
    _continousPosition!.addListener(() {
      _updatePlatformState(_continousPosition!.value);
    });
    _onStartControl?.call();
  }
  ///
  Future<void> extractBeamsToInitialPositions() {
    const rampTimeForMeter = Duration(seconds: 10);
    final initialPositioningtime = Duration(milliseconds: (rampTimeForMeter.inMilliseconds/2).floor());
    const zeroPosition = CilinderLengths();
    // _controller.sendPosition3i(zeroPosition, time: initialPositioningtime);
    _stateController.add(
      const PlatformState(
        beamsPosition: zeroPosition,
        fluctuationAngles: Offset(0,0),
      ),
    );
    return Future.delayed(initialPositioningtime);
  }
  ///
  Future<void> _extractBeamsToStarterPositions(CilinderLengths lengths, Offset angles) async {
    const rampTimeForMeter = Duration(seconds: 10);
    await extractBeamsToInitialPositions();
    final actualRampTime = Duration(
      milliseconds: (
        // TODO check cilinder binding (old: X,Y,Z)
        [lengths.cilinder1, lengths.cilinder2, lengths.cilinder3]
          .reduce(max) / 1000 * rampTimeForMeter.inMilliseconds
      ).round(),
    );
    // _controller.sendPosition3f(
    //   position,
    //   time: actualRampTime,
    // );
    _stateController.add(
      PlatformState(
        beamsPosition: lengths,
        fluctuationAngles: angles,
      ),
    );
    await Future.delayed(actualRampTime);
  }
  ///
  void _updatePlatformState(PlatformState state) {
    // _controller.sendPosition3f(state.beamsPosition);
    _stateController.add(state);
  }
  ///
  void stop() {
    _continousPosition?.stop();
    _onStopControl?.call();
  }
  ///
  void dispose() {
    stop();
    _stateController.close();
  }
}