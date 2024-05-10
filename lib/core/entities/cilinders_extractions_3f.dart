import 'dart:math';
import 'package:stewart_platform_control/core/entities/cilinder_lengths_3f.dart';
import 'package:stewart_platform_control/core/math/mapping/mapping.dart';
///
class CilinderLengthsDependencies {
  final double fluctuationAngleRadians;
  final double fluctuationCenterOffset;
  ///
  const CilinderLengthsDependencies({
    required this.fluctuationAngleRadians,
    required this.fluctuationCenterOffset,
  });
}
///
class CilinderLengthsDependencies2D {
  final CilinderLengthsDependencies dependenciesX;
  final CilinderLengthsDependencies dependenciesY;
  ///
  const CilinderLengthsDependencies2D({
    required this.dependenciesX,
    required this.dependenciesY,
  });
}
///
class CilinderLengthsDependencies3D {
  final CilinderLengthsDependencies2D dependencies2D;
  final double baseline;
  ///
  const CilinderLengthsDependencies3D({
    required this.dependencies2D,
    required this.baseline,
  });
}
/// 
/// Blue dot projection lengths function
class CilinderLengthsXFunction implements Mapping<CilinderLengthsDependencies,CilinderLengths3f> {
  final double _cilinder1Offset;
  final double _cilinder2Offset;
  final double _cilinder3Offset;
  /// 
  /// Blue dot projection lengths function
  const CilinderLengthsXFunction({
    required double cilinder1Offset,
    required double cilinder2Offset,
    required double cilinder3Offset,
  }) :
    _cilinder3Offset = cilinder3Offset,
    _cilinder2Offset = cilinder2Offset,
    _cilinder1Offset = cilinder1Offset;
  ///
  /// Computes cilinder lengths from y_O_x and phi_x
  @override
  CilinderLengths3f of(CilinderLengthsDependencies dependency) {
    final fluctuationOffset = dependency.fluctuationCenterOffset;
    final angleSine = sin(dependency.fluctuationAngleRadians);
    return CilinderLengths3f(
      cilinder1: (_cilinder1Offset-fluctuationOffset)*angleSine,
      cilinder2: (_cilinder2Offset-fluctuationOffset)*angleSine,
      cilinder3: (_cilinder3Offset-fluctuationOffset)*angleSine,
    );
  }
}
///
/// Red dot projection lengths function
class CilinderLengthsYFunction implements Mapping<CilinderLengthsDependencies,CilinderLengths3f> {
  final double _cilinder1Offset;
  final double _cilinder2Offset;
  final double _cilinder3Offset;
  ///
  /// Red dot projection lengths function
  const CilinderLengthsYFunction({
    required double cilinder1Offset,
    required double cilinder2Offset,
    required double cilinder3Offset,
  }) :
    _cilinder3Offset = cilinder3Offset,
    _cilinder2Offset = cilinder2Offset,
    _cilinder1Offset = cilinder1Offset;
  ///
  /// Computes cilinder lengths from x_O_y and phi_y
  @override
  CilinderLengths3f of(CilinderLengthsDependencies dependency) {
    final fluctuationOffset = dependency.fluctuationCenterOffset;
    final angleSine = sin(dependency.fluctuationAngleRadians);
    return CilinderLengths3f(
      cilinder1: (fluctuationOffset-_cilinder1Offset)*angleSine,
      cilinder2: (fluctuationOffset-_cilinder2Offset)*angleSine,
      cilinder3: (fluctuationOffset-_cilinder3Offset)*angleSine,
    );
  }
}
///
class CilinderLengthsFunction2D implements Mapping<CilinderLengthsDependencies2D,CilinderLengths3f> {
  final CilinderLengthsXFunction _lengthsFunctionX;
  final CilinderLengthsYFunction _lengthsFunctionY;
  ///
  const CilinderLengthsFunction2D({
    required CilinderLengthsXFunction lengthsFunctionX,
    required CilinderLengthsYFunction lengthsFunctionY,
  }) :
    _lengthsFunctionY = lengthsFunctionY,
    _lengthsFunctionX = lengthsFunctionX;
  //
  @override
  CilinderLengths3f of(CilinderLengthsDependencies2D dependencies2D) {
    final lengthsX = _lengthsFunctionX.of(dependencies2D.dependenciesX);
    final lengthsY = _lengthsFunctionY.of(dependencies2D.dependenciesY);
    return lengthsX.addLengths(lengthsY);
  }
}

///
class CilinderLengthsFunction3D implements Mapping<CilinderLengthsDependencies3D,CilinderLengths3f> {
  final CilinderLengthsFunction2D _lengthsFunction2D;
  ///
  const CilinderLengthsFunction3D({
    required CilinderLengthsFunction2D lengthsFunction2D,
  }) :
    _lengthsFunction2D = lengthsFunction2D;
  //
  @override
  CilinderLengths3f of(CilinderLengthsDependencies3D dependencies3D) {
    final lengths2D = _lengthsFunction2D.of(dependencies3D.dependencies2D);
    final baseline = dependencies3D.baseline;
    return lengths2D.addValue(baseline);
  }
}

const sqrt3 = 1.7320508075688772;
const cilindersPlacementRadius = 0.220;
const lengthsFunctionX = CilinderLengthsXFunction(
  cilinder1Offset: cilindersPlacementRadius,
  cilinder2Offset: -0.5*cilindersPlacementRadius,
  cilinder3Offset: -0.5*cilindersPlacementRadius,
);
const lengthsFunctionY = CilinderLengthsYFunction(
  cilinder1Offset: 0.0,
  cilinder2Offset: sqrt3*cilindersPlacementRadius/2,
  cilinder3Offset: -sqrt3*cilindersPlacementRadius/2,
);
const lengthsFunction2D = CilinderLengthsFunction2D(
  lengthsFunctionX: lengthsFunctionX,
  lengthsFunctionY: lengthsFunctionY,
);
const lengthsFunction3D = CilinderLengthsFunction3D(
  lengthsFunction2D: lengthsFunction2D,
);