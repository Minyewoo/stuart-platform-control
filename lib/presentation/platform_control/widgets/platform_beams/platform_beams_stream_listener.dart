import 'package:flutter/material.dart';
import 'package:stewart_platform_control/core/io/controller/package/app_data_field/axes/three/position_3f.dart';
import 'package:stewart_platform_control/presentation/platform_control/widgets/platform_beams/platform_beams_widget.dart';

class PlatformBeamsStreamListener extends StatelessWidget {
  final Stream<Position3i> _positionStream;
  ///
  const PlatformBeamsStreamListener({
    super.key,
    required Stream<Position3i> positionStream,
  }) : _positionStream = positionStream;
  //
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Position3i>(
      initialData: Position3i.fromValue(x: 0, y: 0, z: 0),
      stream: _positionStream,
      builder:(context, snapshot) => switch(snapshot.hasData) {
          true => PlarformBeamsWidget(position: snapshot.data!),
          false => const SizedBox(),
        },
    );
  }
}