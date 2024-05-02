import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stewart_platform_control/core/io/controller/mdbox_controller.dart';
import 'package:stewart_platform_control/core/io/controller/package/app_data_field/axes/three/position_3f.dart';
import 'package:stewart_platform_control/core/io/storage/center_storage.dart';
import 'package:stewart_platform_control/core/io/storage/sine_storage.dart';
import 'package:stewart_platform_control/core/math/min_max.dart';
import 'package:stewart_platform_control/core/platform/stuart_platform.dart';
import 'package:stewart_platform_control/presentation/platform_control/widgets/fluctuation_point_picker.dart';
import 'package:stewart_platform_control/presentation/platform_control/widgets/platform_beams/platform_beams_stream_listener.dart';
import 'package:stewart_platform_control/presentation/platform_control/widgets/sines/min_max_notifier.dart';
import 'package:stewart_platform_control/presentation/platform_control/widgets/sines/platform_beams_sines.dart';
import 'package:stewart_platform_control/presentation/platform_control/widgets/sines/platform_control_app_bar.dart';
import 'package:stewart_platform_control/presentation/platform_control/widgets/sines/sine_notifier.dart';
import 'package:toastification/toastification.dart';
///
class PlatformControlPage extends StatefulWidget {
  final SharedPreferences _preferences;
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
    required SharedPreferences preferences,
    Duration controlFrequency = const Duration(milliseconds: 100),
  }) : 
    _controller = controller,
    _cilinderMaxHeight = cilinderMaxHeight,
    _amplitudeConstraints = amplitudeConstraints,
    _periodConstraints = periodConstraints,
    _phaseShiftConstraints = phaseShiftConstraints,
    _preferences = preferences,
    _controlFrequency = controlFrequency;
  //
  @override
  State<PlatformControlPage> createState() => _PlatformControlPageState();
}
///
class _PlatformControlPageState extends State<PlatformControlPage> {
  late final SineStorage _xStorage;
  late final SineStorage _yStorage;
  late final SineStorage _zStorage;
  late final CenterStorage _centerStorage;
  late final SineNotifier _axisXSineNotifier;
  late final SineNotifier _axisYSineNotifier;
  late final SineNotifier _axisZSineNotifier;
  late final MinMaxNotifier _minMaxNotifier;
  late final ValueNotifier<Offset> _fluctuationCenterNotifier;
  late final StuartPlatform _platform;
  late bool _isPlatformMoving;
  //
  @override
  void initState() {
    _xStorage = SineStorage(
      preferences: widget._preferences,
      keysPsrefix: 'x_',
    );
    _yStorage = SineStorage(
      preferences: widget._preferences,
      keysPsrefix: 'y_',
    );
    _zStorage = SineStorage(
      preferences: widget._preferences,
      keysPsrefix: 'z_',
    );
    _centerStorage = CenterStorage(
      preferences: widget._preferences,
      keysPsrefix: 'center_',
    );
    _isPlatformMoving = false;
    _fluctuationCenterNotifier = ValueNotifier(const Offset(50.0, 50.0));
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
    _retrieveValues();
    super.initState();
  }
  //
  @override
  void dispose() {
    _axisXSineNotifier.dispose();
    _axisYSineNotifier.dispose();
    _axisZSineNotifier.dispose();
    _minMaxNotifier.dispose();
    _fluctuationCenterNotifier.dispose();
    super.dispose();
  }
  ///
  Future<void> _retrieveValues() async {
    return Future.wait([
      _xStorage.retrieve().then((value) {
        _axisXSineNotifier.value = value;
      }),
      _yStorage.retrieve().then((value) {
        _axisYSineNotifier.value = value;
      }),
      _zStorage.retrieve().then((value) {
        _axisZSineNotifier.value = value;
      }),
      _centerStorage.retrieve().then((value) {
        _fluctuationCenterNotifier.value = value;
      }),
    ]).then((_) => _showInfo('Параметры загружены'));
  }
  ///
  Future<void> _saveValues() {
    return Future.wait([
      _xStorage.store(_axisXSineNotifier.value),
      _yStorage.store(_axisXSineNotifier.value),
      _zStorage.store(_axisXSineNotifier.value),
      _centerStorage.store(_fluctuationCenterNotifier.value),
    ]).then((_) => _showInfo('Параметры сохранены'));
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
    final random = Random();
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: PlatformControlAppBar(
            onSave: _saveValues,
            onStartFluctuations: _startFluctuations,
            onPlatformStop: _platform.stop,
            isPlatformMoving: _isPlatformMoving,
          ),
          body: Row(
            children: [
              Expanded(
                flex: 3,
                child: PlatformBeamsSines(
                  axisXSineNotifier: _axisXSineNotifier,
                  minMaxNotifier: _minMaxNotifier,
                  axisYSineNotifier: _axisYSineNotifier,
                  axisZSineNotifier: _axisZSineNotifier,
                  cilinderMaxHeight: widget._cilinderMaxHeight,
                  amplitudeConstraints: widget._amplitudeConstraints,
                  periodConstraints: widget._periodConstraints,
                  phaseShiftConstraints: widget._phaseShiftConstraints,
                ),
              ),
              Expanded(
                flex: 1,
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FluctuationPointPicker(
                          realPlatformDimention: 800,
                          fluctuationCenter: _fluctuationCenterNotifier,
                        ),
                      ),
                      Expanded(
                        child: PlatformBeamsStreamListener(
                          positionStream: Stream.periodic(
                            const Duration(milliseconds: 250),
                            (_) => Position3f.fromValue(
                              x: random.nextInt((widget._cilinderMaxHeight-75).toInt()),
                              y: random.nextInt((widget._cilinderMaxHeight-75).toInt()),
                              z: random.nextInt((widget._cilinderMaxHeight-75).toInt()),
                            )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
