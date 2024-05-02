import 'package:ditredi/ditredi.dart';
import 'package:flutter/material.dart';
import 'package:stewart_platform_control/core/io/controller/package/app_data_field/axes/three/position_3f.dart';
import 'package:vector_math/vector_math_64.dart';

class PlarformBeamsWidget extends StatefulWidget {
  final Position3f _position;
  const PlarformBeamsWidget({
    super.key,
    required Position3f position,
  }) : _position = position;

  @override
  State<PlarformBeamsWidget> createState() => _PlarformBeamsWidgetState();
}

class _PlarformBeamsWidgetState extends State<PlarformBeamsWidget> {
  late final DiTreDiController _controller;
  @override
  void initState() {
    _controller = DiTreDiController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return DiTreDiDraggable(
      controller: _controller,
      child: DiTreDi(
        controller: _controller,
        figures: [
          TransformModifier3D(
            Cube3D(1, Vector3(0, 0, 0)),
            Matrix4.identity()
              ..scale(0.13, 1.5, 0.13)
          ),
          TransformModifier3D(
            Cube3D(1, Vector3(0, 0, 0)),
            Matrix4.identity()
              ..scale(0.07, 1.5, 0.07)
              ..translate(0.0, widget._position.x / 1000)
          ),
          TransformModifier3D(
            Cube3D(1, Vector3(0.5, 0, 3)),
            Matrix4.identity()
              ..scale(0.13, 1.5, 0.13)
          ),
          TransformModifier3D(
            Cube3D(1, Vector3(0.5, 0, 3)),
            Matrix4.identity()
              ..scale(0.07, 1.5, 0.07)
              ..translate(0.0, widget._position.y / 1000)
          ),
          TransformModifier3D(
            Cube3D(1, Vector3(3, 0, 0)),
            Matrix4.identity()
              ..scale(0.13, 1.5, 0.13)
          ),
          TransformModifier3D(
            Cube3D(1, Vector3(3, 0, 0)),
            Matrix4.identity()
              ..scale(0.07, 1.5, 0.07)
              ..translate(0.0, widget._position.z / 1000)
          ),
        ],
      ),
    );
  }
}