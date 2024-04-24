import 'dart:async';
import 'package:stuart_platform_control/core/controller/mdbox_controller.dart';
import 'package:stuart_platform_control/core/controller/package/app_data_field/axes/three/position_3f.dart';
import 'package:stuart_platform_control/core/math/sine.dart';
import 'package:stuart_platform_control/presentation/platform_control/widgets/sine_notifier.dart';
///
class StuartPlatform {
  Sine _xSine;
  Sine _ySine;
  Sine _zSine;
  final MdboxController _controller;
  final Duration _controlFrequency;
  final void Function()? _onStart;
  final void Function()? _onStop;
  Timer? _controlTimer;
  ///
  StuartPlatform({
    required SineNotifier xSineNotifier,
    required SineNotifier ySineNotifier,
    required SineNotifier zSineNotifier,
    required Duration controlFrequency,
    required MdboxController controller,
    void Function()? onStart,
    void Function()? onStop,
  }) :
    _xSine = xSineNotifier.value,
    _ySine = ySineNotifier.value,
    _zSine = zSineNotifier.value,
    _controller = controller,
    _controlFrequency = controlFrequency,
    _onStart = onStart,
    _onStop = onStop {
      xSineNotifier.addListener(() {
        _xSine = xSineNotifier.value;
      });
      ySineNotifier.addListener(() {
        _ySine = xSineNotifier.value;
      });
      zSineNotifier.addListener(() {
        _zSine = zSineNotifier.value;
      });
    }
  ///
  void startFluctuations() {
    _controlTimer?.cancel();
    _controlTimer = Timer.periodic(_controlFrequency, (timer) {
      final t =  DateTime.now().millisecondsSinceEpoch / 1000.0;
      _controller.sendPosition3f(
        Position3f.fromValue(
          x: _xSine.of(t).floor(),
          y: _ySine.of(t).floor(),
          z: _zSine.of(t).floor(),
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