import 'package:flutter_test/flutter_test.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:stewart_platform_control/core/entities/cilinders_extractions.dart';
import 'package:stewart_platform_control/core/math/mapping/fluctuation_lengths_mapping.dart';
import 'package:stewart_platform_control/core/math/sine.dart';
import 'package:vector_math/vector_math_64.dart';

void main() {
  hierarchicalLoggingEnabled = true;
  const log = Log('FluctuationLengthsFunction Test');
  group('Function value matches with', () {
    test('X rotation computations', () {
      const testDataX = [
        {
          'title': 'Centered rotation around X',
          'angleAmplitudeXDegree': 15.0,
          'angleAmplitudeYDegree': 0.0,
          'centerX': 0.0,
          'centerY': 0.0,
          'periodXSeconds': 5.0,
          'periodYSeconds': 0.001,
          'cilinder1Seconds': 1.271,
          'cilinder1PosMeters': 0.0569,
          'cilinder3Seconds': 3.750,
          'cilinder3PosMeters': 0.0285,
        },
        {
          'title': 'Shifted Rotation around X',
          'angleAmplitudeXDegree': 10.0,
          'angleAmplitudeYDegree': 0.0,
          'centerX': -0.25*cilindersPlacementRadius,
          'centerY': 0.0,
          'periodXSeconds': 6.0,
          'periodYSeconds': 0.001,
          'cilinder1Seconds': 1.500,
          'cilinder1PosMeters': 0.0478,
          'cilinder3Seconds': 4.514,
          'cilinder3PosMeters': 0.00955,
        },
      ];
      for(
        final {
          'title': title as String,
          'angleAmplitudeXDegree': angleAmplitudeXDegree as double,
          'angleAmplitudeYDegree': angleAmplitudeYDegree as double,
          'centerX': centerX as double,
          'centerY': centerY as double,
          'periodXSeconds': periodXSeconds as double,
          'periodYSeconds': periodYSeconds as double,
          'cilinder1Seconds': cilinder1Seconds as double,
          'cilinder1PosMeters': cilinder1PosMeters as double,
          'cilinder3Seconds': cilinder3Seconds as double,
          'cilinder3PosMeters': cilinder3PosMeters as double,
        }  in testDataX
      ) {
        final lengthFunction = FluctuationLengthsFunction(
          fluctuationCenter: Offset(centerX, centerY),
          phiXSine: Sine(
            amplitude: angleAmplitudeXDegree*degrees2Radians,
            period: periodXSeconds,
            baseline: 0.0,
          ),
          phiYSine: Sine(
            amplitude: angleAmplitudeYDegree*degrees2Radians,
            period: periodYSeconds,
            baseline: 0.0,
          ),
        );
        final cilinder1Result = double.parse(
          lengthFunction.of(cilinder1Seconds).cilinder1.toStringAsFixed(4),
        );
        final cilinder3Result = double.parse(
          lengthFunction.of(cilinder3Seconds).cilinder3.toStringAsFixed(4),
        );
        log.debug('[$title]');
        log.debug('(Cilinder 1) Expected: $cilinder1PosMeters; Got: $cilinder1Result');
        log.debug('(Cilinder 3) Expected: $cilinder3PosMeters; Got: $cilinder3Result');
        log.debug('');
        expect(
          (cilinder1Result-cilinder1PosMeters).abs(),
          lessThan(0.001),
          reason: 'Invalid result. Params was: cilinder1Seconds($cilinder1Seconds), angleAmplitudeXDegree($angleAmplitudeXDegree), angleAmplitudeYDegree($angleAmplitudeYDegree), centerX($centerX), centerY($centerY), cilinder1PosMeters($cilinder1PosMeters), cilinder1Result($cilinder1Result)',
        );
        expect(
          (cilinder3Result-cilinder3PosMeters).abs(),
          lessThan(0.001),
          reason: 'Invalid result. Params was: cilinder3Seconds($cilinder3Seconds), angleAmplitudeXDegree($angleAmplitudeXDegree), angleAmplitudeYDegree($angleAmplitudeYDegree), centerX($centerX), centerY($centerY), cilinder3PosMeters($cilinder3PosMeters), cilinder3Result($cilinder3Result)',
        );
      }
    });
    test('Y rotation computations', () {
      const testDataY = [
        {
          'title': 'Centered rotation around Y',
          'angleAmplitudeXDegree': 0.0,
          'angleAmplitudeYDegree': 15.0,
          'centerX': 0.0,
          'centerY': 0.0,
          'periodXSeconds': 0.001,
          'periodYSeconds': 5.0,
          'cilinder3Seconds': 1.244,
          'cilinder3PosMeters': 0.0493,
          'cilinder2Seconds': 3.775,
          'cilinder2PosMeters': 0.0493,
        },
        {
          'title': 'Shifted rotation around Y',
          'angleAmplitudeXDegree': 0.0,
          'angleAmplitudeYDegree': 10.0,
          'centerX': 0.0,
          'centerY': -0.25*sqrt3*cilindersPlacementRadius,
          'periodXSeconds': 0.001,
          'periodYSeconds': 6.0,
          'cilinder3Seconds': 1.528,
          'cilinder3PosMeters': 0.0165,
          'cilinder2Seconds': 4.500,
          'cilinder2PosMeters': 0.0496,
        },
      ];
      for(
        final {
          'title': title as String,
          'angleAmplitudeXDegree': angleAmplitudeXDegree as double,
          'angleAmplitudeYDegree': angleAmplitudeYDegree as double,
          'centerX': centerX as double,
          'centerY': centerY as double,
          'periodXSeconds': periodXSeconds as double,
          'periodYSeconds': periodYSeconds as double,
          'cilinder2Seconds': cilinder2Seconds as double,
          'cilinder2PosMeters': cilinder2PosMeters as double,
          'cilinder3Seconds': cilinder3Seconds as double,
          'cilinder3PosMeters': cilinder3PosMeters as double,
        }  in testDataY
      ) {
        final lengthFunction = FluctuationLengthsFunction(
          fluctuationCenter: Offset(centerX, centerY),
          phiXSine: Sine(
            amplitude: angleAmplitudeXDegree*degrees2Radians,
            period: periodXSeconds,
            baseline: 0.0,
          ),
          phiYSine: Sine(
            amplitude: angleAmplitudeYDegree*degrees2Radians,
            period: periodYSeconds,
            baseline: 0.0,
          ),
        );
        final cilinder2Result = double.parse(
          lengthFunction.of(cilinder2Seconds).cilinder2.toStringAsFixed(4),
        );
        final cilinder3Result = double.parse(
          lengthFunction.of(cilinder3Seconds).cilinder3.toStringAsFixed(4),
        );
        log.debug('[$title]');
        log.debug('(Cilinder 2) Expected: $cilinder2PosMeters; Got: $cilinder2Result');
        log.debug('(Cilinder 3) Expected: $cilinder3PosMeters; Got: $cilinder3Result');
        log.debug('');
        expect(
          (cilinder2Result-cilinder2PosMeters).abs(),
          lessThan(0.001),
          reason: 'Invalid result. Params was: cilinder2Seconds($cilinder2Seconds), angleAmplitudeXDegree($angleAmplitudeXDegree), angleAmplitudeYDegree($angleAmplitudeYDegree), centerX($centerX), centerY($centerY), cilinder2PosMeters($cilinder2PosMeters), cilinder2Result($cilinder2Result)',
        );
        expect(
          (cilinder3Result-cilinder3PosMeters).abs(),
          lessThan(0.001),
          reason: 'Invalid result. Params was: cilinder3Seconds($cilinder3Seconds), angleAmplitudeXDegree($angleAmplitudeXDegree), angleAmplitudeYDegree($angleAmplitudeYDegree), centerX($centerX), centerY($centerY), cilinder3PosMeters($cilinder3PosMeters), cilinder3Result($cilinder3Result)',
        );
      }
    });
  });
}