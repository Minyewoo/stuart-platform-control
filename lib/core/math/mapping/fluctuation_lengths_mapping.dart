import 'dart:ui';
import 'package:stewart_platform_control/core/entities/cilinders_extractions.dart';
import 'package:stewart_platform_control/core/math/mapping/mapping.dart';
import 'package:stewart_platform_control/core/math/sine.dart';
///
class FluctuationLengthsFunction implements Mapping<double, CilinderLengths> {
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
  CilinderLengths of(double t) {
    return lengthsFunction3D.of(
      CilinderLengthsDependencies3D(
        dependencies2D: CilinderLengthsDependencies2D(
          dependenciesX: CilinderLengthsDependencies(
            fluctuationAngleRadians: _phiXSine.of(t),
            fluctuationCenterOffset: _fluctuationCenter.dx,
          ),
          dependenciesY: CilinderLengthsDependencies(
            fluctuationAngleRadians: _phiYSine.of(t),
            fluctuationCenterOffset: _fluctuationCenter.dy,
          ),
        ),
        baseline: _baselineSine.of(t),
      ),
    );
  }
}