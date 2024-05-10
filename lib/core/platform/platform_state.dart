import 'dart:ui';
import 'package:stewart_platform_control/core/entities/cilinder_lengths_3f.dart';
///
class PlatformState {
  final CilinderLengths3f beamsPosition;
  final Offset fluctuationAngles;
  ///
  const PlatformState({
    required this.beamsPosition,
    required this.fluctuationAngles,
  });
}