import 'dart:ui';
import 'package:stewart_platform_control/core/entities/cilinders_extractions_3f.dart';
import 'package:stewart_platform_control/core/math/mapping/mapping.dart';
import 'package:stewart_platform_control/core/math/min_max.dart';
import 'package:stewart_platform_control/core/math/sine.dart';
import 'package:stewart_platform_control/core/platform/platform_state.dart';
///
class FluctuationLengthsFunction implements MinMaxedMapping<double, PlatformState> {
  final Offset _fluctuationCenter;
  final Sine _phiXSine;
  final Sine _phiYSine;
  final Sine _baselineSine;
  ///
  const FluctuationLengthsFunction({
    required Offset fluctuationCenter,
    required Sine phiXSine,
    required Sine phiYSine,
    Sine baselineSine = const Sine(
      amplitude: 0.0,
      baseline: 0.0,
    ),
  }) :
    _baselineSine = baselineSine,
    _phiYSine = phiYSine,
    _phiXSine = phiXSine,
    _fluctuationCenter = fluctuationCenter;
  //
  @override
  PlatformState of(double t) {
    return _computeFunction(
      phiXRadians: _phiXSine.of(t),
      phiYRadians: _phiYSine.of(t),
      baseline: _baselineSine.of(t),
    );
  }
  ///
  PlatformState _computeFunction({
    required double phiXRadians,
    required double phiYRadians,
    required double baseline,
  }) {
    return PlatformState(
      beamsPosition: lengthsFunction3D.of(
        CilinderLengthsDependencies3D(
          dependencies2D: CilinderLengthsDependencies2D(
            dependenciesX: CilinderLengthsDependencies(
              fluctuationAngleRadians: phiXRadians,
              fluctuationCenterOffset: _fluctuationCenter.dx,
            ),
            dependenciesY: CilinderLengthsDependencies(
              fluctuationAngleRadians: phiYRadians,
              fluctuationCenterOffset: _fluctuationCenter.dy,
            ),
          ),
          baseline: baseline,
        ),
      ),
      fluctuationAngles: Offset(phiXRadians, phiYRadians),
    );
  }
  //
  @override
  MinMax<PlatformState> get minMax {
    final phiXMinMax = _phiXSine.minMax;
    final phiYMinMax = _phiYSine.minMax;
    final baselineMinMax = _baselineSine.minMax;
    return MinMax(
      min: _computeFunction(
        phiXRadians: phiXMinMax.min,
        phiYRadians: phiYMinMax.min,
        baseline: baselineMinMax.min,
      ),
      max: _computeFunction(
        phiXRadians: phiXMinMax.max,
        phiYRadians: phiYMinMax.max,
        baseline: baselineMinMax.max,
      ),
    );
  }
  ///
  FluctuationLengthsFunction copyWith({
    Offset? fluctuationCenter,
    Sine? phiXSine,
    Sine? phiYSine,
    Sine? baselineSine,
  }) => FluctuationLengthsFunction(
    fluctuationCenter: fluctuationCenter ?? _fluctuationCenter,
    phiXSine: phiXSine ?? _phiXSine,
    phiYSine: phiYSine ?? _phiYSine,
    baselineSine: baselineSine ?? _baselineSine,
  );
}