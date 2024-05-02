import 'package:flutter/material.dart';
import 'package:stewart_platform_control/core/platform/stewart_platform.dart';
import 'package:stewart_platform_control/presentation/platform_control/widgets/platform_beams/platform_beams_stream_listener.dart';
///
class PlatformBeamsController extends StatelessWidget {
  final StewartPlatform _platform;
  ///
  const PlatformBeamsController({
    super.key,
    required StewartPlatform platform,
  }) : _platform = platform;

  @override
  Widget build(BuildContext context) {
    return PlatformBeamsStreamListener(
      positionStream: _platform.platformPositions,
    );
  }
}