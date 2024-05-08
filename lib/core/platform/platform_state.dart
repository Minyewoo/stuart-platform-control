import 'dart:ui';
import 'package:stewart_platform_control/core/entities/cilinders_extractions.dart';
///
class PlatformState {
  final CilinderLengths beamsPosition;
  final Offset fluctuationAngles;
  ///
  const PlatformState({
    required this.beamsPosition,
    required this.fluctuationAngles,
  });
}