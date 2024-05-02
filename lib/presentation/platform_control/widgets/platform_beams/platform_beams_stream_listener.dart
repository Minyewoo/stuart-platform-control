import 'package:flutter/material.dart';
import 'package:stewart_platform_control/core/io/controller/package/app_data_field/axes/three/position_3f.dart';
import 'package:stewart_platform_control/presentation/platform_control/widgets/platform_beams/platform_beams_widget.dart';

class PlatformBeamsStreamListener extends StatelessWidget {
  final Stream<Position3f> _positionStream;
  ///
  const PlatformBeamsStreamListener({
    super.key,
    required Stream<Position3f> positionStream,
  }) : _positionStream = positionStream;
  //
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _positionStream,
      builder:(context, snapshot) => switch(snapshot.hasData) {
          true => PlarformBeamsWidget(position: snapshot.data!),
          false => const SizedBox(),
        },
    );
  }
}