import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stewart_platform_control/core/io/controller/mdbox_controller.dart';
import 'package:stewart_platform_control/core/io/storage/sine_storage.dart';
import 'package:stewart_platform_control/core/math/min_max.dart';
import 'package:stewart_platform_control/core/platform/stuart_platform.dart';
import 'package:stewart_platform_control/presentation/platform_control/widgets/min_max_notifier.dart';
import 'package:stewart_platform_control/presentation/platform_control/widgets/platform_beams_sines.dart';
import 'package:stewart_platform_control/presentation/platform_control/widgets/platform_control_app_bar.dart';
import 'package:stewart_platform_control/presentation/platform_control/widgets/sine_notifier.dart';
import 'package:toastification/toastification.dart';
///
class PlatformControlPage extends StatefulWidget {
  final double _cilinderMaxHeight;
  final MinMax _amplitudeConstraints;
  final MinMax _periodConstraints;
  final MinMax _phaseShiftConstraints;
  final Duration _controlFrequency;
  final MdboxController _controller;
  ///
  const PlatformControlPage({
    super.key,
    required MdboxController controller,
    required double cilinderMaxHeight,
    required MinMax amplitudeConstraints,
    required MinMax periodConstraints,
    required MinMax phaseShiftConstraints,
    Duration controlFrequency = const Duration(milliseconds: 100),
  }) : 
    _controller = controller,
    _cilinderMaxHeight = cilinderMaxHeight,
    _amplitudeConstraints = amplitudeConstraints,
    _periodConstraints = periodConstraints,
    _phaseShiftConstraints = phaseShiftConstraints,
    _controlFrequency = controlFrequency;
  //
  @override
  State<PlatformControlPage> createState() => _PlatformControlPageState();
}
///
class _PlatformControlPageState extends State<PlatformControlPage> {
  static const _xSinePrefix = 'x_';
  static const _ySinePrefix = 'y_';
  static const _zSinePrefix = 'z_';
  final _storage = const SineStorage();
  late bool _isPlatformMoving;
  late final SineNotifier _axisXSineNotifier;
  late final SineNotifier _axisYSineNotifier;
  late final SineNotifier _axisZSineNotifier;
  late final MinMaxNotifier _minMaxNotifier;
  late final StuartPlatform _platform;
  //
  @override
  void initState() {
    _isPlatformMoving = false;
    _axisXSineNotifier = SineNotifier();
    _axisYSineNotifier = SineNotifier();
    _axisZSineNotifier = SineNotifier();
    _minMaxNotifier = MinMaxNotifier();
    _tryRecomputeMinMax();
    _axisXSineNotifier.addListener(_tryRecomputeMinMax);
    _axisYSineNotifier.addListener(_tryRecomputeMinMax);
    _axisZSineNotifier.addListener(_tryRecomputeMinMax);
    _platform = StuartPlatform(
      controlFrequency: widget._controlFrequency,
      controller: widget._controller,
      onStart: () {
        setState(() {
          _isPlatformMoving = true;
        });
      },
      onStop: () {
        setState(() {
          _isPlatformMoving = false;
        });
      }
    );
    _retrieveSines();
    super.initState();
  }
  //
  @override
  void dispose() {
    _axisXSineNotifier.dispose();
    _axisYSineNotifier.dispose();
    _axisZSineNotifier.dispose();
    _minMaxNotifier.dispose();
    super.dispose();
  }
  ///
  void _retrieveSines() {
    SharedPreferences.getInstance().then(
      (prefs) {
        _axisXSineNotifier.value = _storage.retrieveSine(_xSinePrefix, prefs);
        _axisYSineNotifier.value = _storage.retrieveSine(_ySinePrefix, prefs);
        _axisZSineNotifier.value = _storage.retrieveSine(_zSinePrefix, prefs);
        _showInfo('Параметры загружены');
      },
    );
  }
  ///
  void _saveSines() {
    SharedPreferences.getInstance().then((prefs) {
      _storage.storeSine(_xSinePrefix, _axisXSineNotifier.value, prefs);
      _storage.storeSine(_ySinePrefix, _axisYSineNotifier.value, prefs);
      _storage.storeSine(_zSinePrefix, _axisZSineNotifier.value, prefs);
      _showInfo('Параметры сохранены');
    });
  }
  ///
  void _showInfo(String message) {
    toastification.show(
      alignment: Alignment.topCenter,
      showProgressBar: false,
      type: ToastificationType.info,
      style: ToastificationStyle.flat,
      backgroundColor: Theme.of(context).colorScheme.background,
      foregroundColor: Theme.of(context).colorScheme.onBackground,
      context: context,
      title: Text(message),
      autoCloseDuration: const Duration(seconds: 2),
    );
  }
  ///
  void _tryRecomputeMinMax() {
    final axis1MinMax = _axisXSineNotifier.value.minMax;
    final axis2MinMax = _axisYSineNotifier.value.minMax;
    final axis3MinMax = _axisZSineNotifier.value.minMax;
    _minMaxNotifier.value =MinMax(
      min: [axis1MinMax.min, axis2MinMax.min, axis3MinMax.min].reduce(min), 
      max: [axis1MinMax.max, axis2MinMax.max, axis3MinMax.max].reduce(max), 
    );
  }
  ///
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: PlatformControlAppBar(
            onSaveSines: _saveSines,
            onStartFluctuations: _startFluctuations,
            onPlatformStop: _platform.stop,
            isPlatformMoving: _isPlatformMoving,
          ),
          body: PlatformBeamsSines(
            axisXSineNotifier: _axisXSineNotifier,
            minMaxNotifier: _minMaxNotifier,
            axisYSineNotifier: _axisYSineNotifier,
            axisZSineNotifier: _axisZSineNotifier,
            cilinderMaxHeight: widget._cilinderMaxHeight,
            amplitudeConstraints: widget._amplitudeConstraints,
            periodConstraints: widget._periodConstraints,
            phaseShiftConstraints: widget._phaseShiftConstraints,
          ),
        );
      },
    );
  }
  //
  void _startFluctuations() {
    _platform.startFluctuations(
      xSine: _axisXSineNotifier.value,
      ySine: _axisYSineNotifier.value,
      zSine: _axisZSineNotifier.value,
    );
  }
}
