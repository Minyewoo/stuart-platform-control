import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stewart_platform_control/core/io/controller/mdbox_controller.dart';
import 'package:stewart_platform_control/core/io/storage/center_storage.dart';
import 'package:stewart_platform_control/core/io/storage/sine_storage.dart';
import 'package:stewart_platform_control/core/math/min_max.dart';
import 'package:stewart_platform_control/core/platform/stewart_platform.dart';
import 'package:stewart_platform_control/presentation/platform_control/widgets/fluctuation_center/fluctuation_center_coords.dart';
import 'package:stewart_platform_control/presentation/platform_control/widgets/fluctuation_center/fluctuation_side_projection.dart';
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
  final Duration _reportFrequency;
  final double _realPlatformDimension;
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
    required double realPlatformDimension,
    Duration controlFrequency = const Duration(milliseconds: 100),
    Duration reportFrequency = const Duration(milliseconds: 100),
  }) :
    _realPlatformDimension = realPlatformDimension, 
    _controller = controller,
    _cilinderMaxHeight = cilinderMaxHeight,
    _amplitudeConstraints = amplitudeConstraints,
    _periodConstraints = periodConstraints,
    _phaseShiftConstraints = phaseShiftConstraints,
    _preferences = preferences,
    _controlFrequency = controlFrequency,
    _reportFrequency = reportFrequency;
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
  late final ValueNotifier<Offset> _rotationNotifier;
  late final StewartPlatform _platform;
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
    _rotationNotifier = ValueNotifier(const Offset(pi/3, pi/5));
    _axisXSineNotifier = SineNotifier();
    _axisYSineNotifier = SineNotifier();
    _axisZSineNotifier = SineNotifier();
    _minMaxNotifier = MinMaxNotifier();
    _tryRecomputeMinMax();
    _axisXSineNotifier.addListener(_tryRecomputeMinMax);
    _axisYSineNotifier.addListener(_tryRecomputeMinMax);
    _axisZSineNotifier.addListener(_tryRecomputeMinMax);
    _platform = StewartPlatform(
      controlFrequency: widget._controlFrequency,
      reportFrequency: widget._reportFrequency,
      controller: widget._controller,
      onStartControl: () {
        setState(() {
          _isPlatformMoving = true;
        });
      },
      onStopControl: () {
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: PlatformControlAppBar(
            onSave: _saveValues,
            onStartFluctuations:  _onStartFluctuations,
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Центр колебаний: '
                            ),
                            const Spacer(),
                            FluctuationCenterCoords(
                              fluctuationCenter: _fluctuationCenterNotifier,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // FluctuationTopProjection(
                        //   realPlatformDimention: 800,
                        //   fluctuationCenter: _fluctuationCenterNotifier,
                        // ),
                        // const SizedBox(height: 8),
                        Expanded(
                          child: FluctuationSideProjection(
                            type: ProjectionType.horizontal,
                            realPlatformDimention: widget._realPlatformDimension,
                            fluctuationCenter: _fluctuationCenterNotifier,
                            rotation: _rotationNotifier,
                            pointSize: 9,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: FluctuationSideProjection(
                            type: ProjectionType.vertical,
                            realPlatformDimention: widget._realPlatformDimension,
                            fluctuationCenter: _fluctuationCenterNotifier,
                            rotation: _rotationNotifier,
                            pointSize: 9,
                          ),
                        ),
                      ],
                    ),
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
  void _onStartFluctuations() {
    _platform.startFluctuations(
      xSine: _axisXSineNotifier.value,
      ySine: _axisYSineNotifier.value,
      zSine: _axisZSineNotifier.value,
    );
    _platform.startReportingPosition();
  }
}
