import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:stewart_platform_control/core/entities/cilinders_extractions_3f.dart';
import 'package:stewart_platform_control/core/io/controller/mdbox_controller.dart';
import 'package:stewart_platform_control/core/math/mapping/fluctuation_lengths_mapping.dart';
import 'package:stewart_platform_control/core/math/mapping/time_mapping.dart';
import 'package:stewart_platform_control/core/math/mapping/mapping.dart';
import 'package:stewart_platform_control/core/math/min_max.dart';
import 'package:stewart_platform_control/core/math/sine.dart';
import 'package:stewart_platform_control/core/platform/platform_state.dart';
import 'package:stewart_platform_control/core/platform/stewart_platform.dart';
import 'package:stewart_platform_control/presentation/platform_control/widgets/fluctuation_center/colored_coords.dart';
import 'package:stewart_platform_control/presentation/platform_control/widgets/fluctuation_center/fluctuation_center_coords.dart';
import 'package:stewart_platform_control/presentation/platform_control/widgets/fluctuation_center/fluctuation_side_projection.dart';
import 'package:stewart_platform_control/presentation/platform_control/widgets/sines/min_max_notifier.dart';
import 'package:stewart_platform_control/presentation/platform_control/widgets/sines/platform_angle_sines.dart';
import 'package:stewart_platform_control/presentation/platform_control/widgets/sines/platform_control_app_bar.dart';
import 'package:stewart_platform_control/presentation/platform_control/widgets/sines/sine_notifier.dart';
///
class PlatformControlPage extends StatefulWidget {
  final double _cilinderMaxHeight;
  final Duration _controlFrequency;
  final Duration _reportFrequency;
  final double _realPlatformDimension;
  final MdboxController _controller;
  ///
  const PlatformControlPage({
    super.key,
    required MdboxController controller,
    required double realPlatformDimension,
    required double cilinderMaxHeight,
    Duration controlFrequency = const Duration(milliseconds: 100),
    Duration reportFrequency = const Duration(milliseconds: 100),
  }) :
    _realPlatformDimension = realPlatformDimension, 
    _controller = controller,
    _cilinderMaxHeight = cilinderMaxHeight,
    _controlFrequency = controlFrequency,
    _reportFrequency = reportFrequency;
  //
  @override
  State<PlatformControlPage> createState() => _PlatformControlPageState();
}
///
class _PlatformControlPageState extends State<PlatformControlPage> {
  late final SineNotifier _rotationAngleX;
  late final SineNotifier _rotationAngleY;
  late final SineNotifier _baseline;
  late final MinMaxNotifier _angleMinMaxNotifier;
  late final MinMaxNotifier _baselineMinMaxNotifier;
  late final ValueNotifier<Offset> _fluctuationCenterNotifier;
  late final StewartPlatform _platform;
  late final Stream<DsDataPoint<double>> _lengthsStream;
  late bool _isPlatformMoving;
  //
  @override
  void initState() {
    _isPlatformMoving = false;
    _fluctuationCenterNotifier = ValueNotifier(const Offset(0.0, 0.0));
    _rotationAngleX = SineNotifier(
      sine: const Sine(
        amplitude: 0.0,
        baseline: 0.0,
      ),
    );
    _rotationAngleY = SineNotifier(
      sine: const Sine(
        amplitude: 0.0,
        baseline: 0.0,
      ),
    );
    _baseline = SineNotifier(
      sine: const Sine(
        amplitude: 0.0,
        baseline: 0.0,
        alwaysGreaterThanZero: true,
      ),
    );
    final angleXMinMax = _rotationAngleX.value.minMax;
    final angleYMinMax = _rotationAngleY.value.minMax;
    _angleMinMaxNotifier = MinMaxNotifier(
      minMax: MinMax(
        min: min(angleXMinMax.min, angleYMinMax.min),
        max: max(angleXMinMax.max, angleYMinMax.max),
      ),
    );
    _baselineMinMaxNotifier = MinMaxNotifier(
      minMax: MinMax(
        min: 0.0,
        max: widget._cilinderMaxHeight,
      ),
    );
    _rotationAngleX.addListener(() {
      final newMinMax = _rotationAngleX.value.minMax;
      final currentYMinMax = _rotationAngleY.value.minMax;
      _angleMinMaxNotifier.value = MinMax(
        min: min(newMinMax.min, currentYMinMax.min),
        max: max(newMinMax.max, currentYMinMax.max),
      );
    });
     _rotationAngleY.addListener(() {
      final newYMinMax = _rotationAngleY.value.minMax;
      final currentXMinMax = _rotationAngleX.value.minMax;
      _angleMinMaxNotifier.value = MinMax(
        min: min(newYMinMax.min, currentXMinMax.min),
        max: max(newYMinMax.max, currentXMinMax.max),
      );
    });
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
    _lengthsStream = _platform.state.transform(
      StreamTransformer.fromHandlers(
        handleData: (state, sink) {
          final now = DsTimeStamp.now().toString();
          final position = state.beamsPosition;
          final dataToAdd = [position.cilinder1, position.cilinder2, position.cilinder3];
          for(int i = 0; i<dataToAdd.length; i++) {
            sink.add(
              DsDataPoint<double>(
                type: DsDataType.integer,
                name: DsPointName('/cilinder$i'),
                value: dataToAdd[i]*1000,
                status: DsStatus.ok,
                timestamp: now,
                cot: DsCot.inf,
              ),
            );
          }
        },
      ),
    );
    super.initState();
  }
  //
  @override
  void dispose() {
    _rotationAngleX.dispose();
    _rotationAngleY.dispose();
    _baseline.dispose();
    _fluctuationCenterNotifier.dispose();
    _platform.dispose();
    super.dispose();
  }
  //
  @override
  Widget build(BuildContext context) {
    const horizontalRadius = cilindersPlacementRadius*sqrt3/2;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: PlatformControlAppBar(
            onSave: () {}, //_saveValues,
            onStartFluctuations:  _onStartFluctuations,
            onInitialPositionRequest: _platform.extractBeamsToInitialPositions,
            onPlatformStop: _platform.stop,
            isPlatformMoving: _isPlatformMoving,
          ),
          body: Row(
            children: [
              Expanded(
                flex: 3,
                child: AnimatedSwitcher(
                  switchInCurve: Curves.easeIn,
                  switchOutCurve: Curves.easeOut,
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) => ScaleTransition(
                    scale: animation,
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  ),
                  child: switch(_isPlatformMoving) {
                    true => LiveChartWidget(
                      minX: DateTime.now().subtract(const Duration(seconds: 6))
                        .millisecondsSinceEpoch.toDouble(),
                      xInterval: 6000,
                      axes: [
                        LiveAxis(
                          bufferLength: 4000,
                          stream: _lengthsStream,
                          signalName: 'cilinder0',
                          caption: 'Цилиндр I',
                          color: Colors.purpleAccent,
                        ),
                        LiveAxis(
                          bufferLength: 4000,
                          stream: _lengthsStream,
                          signalName: 'cilinder1',
                          caption: 'Цилиндр II',
                          color: Colors.greenAccent,
                        ),
                        LiveAxis(
                          bufferLength: 4000,
                          stream: _lengthsStream,
                          signalName: 'cilinder2',
                          caption: 'Цилиндр III',
                          color: Colors.orangeAccent,
                        ),
                      ],
                    ),
                    false => PlatformAngleSines(
                      baselineMinMax: _baselineMinMaxNotifier,
                      anglesMinMax: _angleMinMaxNotifier,  
                      isDisabled: _isPlatformMoving,              
                      rotationAngleX: _rotationAngleX,
                      rotationAngleY: _rotationAngleY,
                      baseline: _baseline,
                    ),
                  },
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
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  ColoredCoords(
                                    xText: TextSpan(
                                      style: const TextStyle(color: Colors.redAccent),
                                      children: [
                                        const TextSpan(text: 'x'),
                                        WidgetSpan(
                                          child: Transform.translate(
                                            offset: const Offset(2, 4),
                                            child: const Text(
                                              'O',
                                              textScaler: TextScaler.linear(0.8),
                                              style: TextStyle(color: Colors.redAccent),
                                            ),
                                          ),
                                        ),
                                        WidgetSpan(
                                          child: Transform.translate(
                                            offset: const Offset(2, 4),
                                            child: const Text(
                                              'y ',
                                              textScaler: TextScaler.linear(0.6),
                                              style: TextStyle(color: Colors.redAccent),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    yText: TextSpan(
                                      style: const TextStyle(color: Colors.blueAccent),
                                      children: [
                                        const TextSpan(text: 'y'),
                                        WidgetSpan(
                                          child: Transform.translate(
                                            offset: const Offset(2, 4),
                                            child: const Text(
                                              'O',
                                              textScaler: TextScaler.linear(0.8),
                                              style: TextStyle(color: Colors.blueAccent),
                                            ),
                                          ),
                                        ),
                                        WidgetSpan(
                                          child: Transform.translate(
                                            offset: const Offset(2, 4),
                                            child: const Text(
                                              'x ',
                                              textScaler: TextScaler.linear(0.6),
                                              style: TextStyle(color: Colors.blueAccent),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Text(':'),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Expanded(
                              flex: 3,
                              child: FluctuationCenterCoords(
                                fluctuationCenter: _fluctuationCenterNotifier,
                              ),
                            ),
                            const Spacer(),
                            Expanded(
                              flex: 2,
                              child: IconButton(
                                onPressed: _isPlatformMoving ? null : () {
                                  _fluctuationCenterNotifier.value = const Offset(0.0, 0.0);
                                },
                                icon: const Icon(Icons.cancel)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: FluctuationSideProjection(
                            borderValues: const MinMax(
                              min: -horizontalRadius, 
                              max: horizontalRadius,
                            ),
                            isPlatformMoving: _isPlatformMoving,
                            type: RotationAxis.y,
                            realPlatformDimention: widget._realPlatformDimension,
                            fluctuationCenter: _fluctuationCenterNotifier,
                            platformState: _platform.state,
                            pointSize: 9,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: FluctuationSideProjection(
                            borderValues: const MinMax(
                              min: -cilindersPlacementRadius/2, 
                              max: cilindersPlacementRadius,
                            ),
                            isPlatformMoving: _isPlatformMoving,
                            type: RotationAxis.x,
                            realPlatformDimention: widget._realPlatformDimension,
                            fluctuationCenter: _fluctuationCenterNotifier,
                            platformState: _platform.state,
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
    setState(() {
      _isPlatformMoving = true;
    });
    _platform.startFluctuations(
      _generateFluctuationFunction(),
    );
  }
  ///
  TimeMapping<PlatformState> _generateFluctuationFunction() {
    final phiXSine = _rotationAngleX.value;
    final phiYSine =  _rotationAngleY.value;
    final lengthsFunction = FluctuationLengthsFunction(
      fluctuationCenter: _fluctuationCenterNotifier.value,
      phiXSine: phiXSine,
      phiYSine: phiYSine,
      baselineSine: _baseline.value,
    );
    return TimeMapping(
      mapping: Mapping.generic(
        (seconds) {
          final lengths = lengthsFunction.of(seconds);
          return PlatformState(
            beamsPosition: lengths,
            fluctuationAngles: Offset(phiXSine.of(seconds), phiYSine.of(seconds)),
          );
        },
      ),
      frequency: const Duration(milliseconds: 10),
    );
  }
}
