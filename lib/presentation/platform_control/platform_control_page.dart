import 'dart:math';
import 'package:flutter/material.dart';
import 'package:stuart_platform_control/core/controller/mdbox_controller.dart';
import 'package:stuart_platform_control/core/math/min_max.dart';
import 'package:stuart_platform_control/core/math/sine.dart';
import 'package:stuart_platform_control/core/platform/stuart_platform.dart';
import 'package:stuart_platform_control/presentation/platform_control/widgets/min_max_notifier.dart';
import 'package:stuart_platform_control/presentation/platform_control/widgets/sine_notifier.dart';
import 'package:stuart_platform_control/presentation/platform_control/widgets/sine_control_widget.dart';
///
class PlatformControlPage extends StatefulWidget {
  final Duration _controlFrequency;
  final MdboxController _controller;
  ///
  const PlatformControlPage({
    super.key,
    required MdboxController controller,
    Duration controlFrequency = const Duration(milliseconds: 500),
  }) : 
    _controller = controller,
    _controlFrequency = controlFrequency;
  //
  @override
  State<PlatformControlPage> createState() => _PlatformControlPageState();
}
///
class _PlatformControlPageState extends State<PlatformControlPage> {
  late bool _isPlatformMoving;
  late final SineNotifier _axis1SineNotifier;
  late final SineNotifier _axis2SineNotifier;
  late final SineNotifier _axis3SineNotifier;
  late final MinMaxNotifier _minMaxNotifier;
  late final StuartPlatform _platform;
  //
  @override
  void initState() {
    _isPlatformMoving = false;
    _axis1SineNotifier = SineNotifier(
      sine: const Sine(
        baseline: 200,
      ),
    );
    _axis2SineNotifier = SineNotifier(
      sine: const Sine(
        amplitude: 2,
        period: pi,
        phaseShift: pi/2,
        baseline: 200,
      ),
    );
    _axis3SineNotifier = SineNotifier(
      sine: const Sine(
        amplitude: 0.5,
        period: pi/2,
        phaseShift: pi,
        baseline: 200,
      ),
    );
    _minMaxNotifier = MinMaxNotifier();
    _tryRecomputeMinMax();
    _axis1SineNotifier.addListener(_tryRecomputeMinMax);
    _axis2SineNotifier.addListener(_tryRecomputeMinMax);
    _axis3SineNotifier.addListener(_tryRecomputeMinMax);
    _platform = StuartPlatform(
      xSineNotifier: _axis1SineNotifier,
      ySineNotifier: _axis2SineNotifier,
      zSineNotifier: _axis3SineNotifier,
      controlFrequency: widget._controlFrequency,
      controller: widget._controller,
      onStart: () {
        setState(() {
          _isPlatformMoving = true;
        });
      },
      onStop: () {
        setState(() {
          _isPlatformMoving = false;
        });
      }
    );
    super.initState();
  }
  //
  @override
  void dispose() {
    _axis1SineNotifier.dispose();
    _axis2SineNotifier.dispose();
    _axis3SineNotifier.dispose();
    _minMaxNotifier.dispose();
    super.dispose();
  }
  void _tryRecomputeMinMax() {
    final axis1MinMax = _axis1SineNotifier.value.minMax;
    final axis2MinMax = _axis2SineNotifier.value.minMax;
    final axis3MinMax = _axis3SineNotifier.value.minMax;
    _minMaxNotifier.value =MinMax(
      min: [axis1MinMax.min, axis2MinMax.min, axis3MinMax.min].reduce(min), 
      max: [axis1MinMax.max, axis2MinMax.max, axis3MinMax.max].reduce(max), 
    );
  }
  ///
  @override
  Widget build(BuildContext context) {
    const chartsPadding = EdgeInsets.only(top: 8.0, right: 16.0);
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: OutlinedButton.icon(
              onPressed: _isPlatformMoving ? () {} : null,
              icon: Icon(
                Icons.circle, 
                color: _isPlatformMoving ? Colors.greenAccent : null,
              ), 
              label: const Text('Движение в процессе'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: FilledButton.icon(
              onPressed: _platform.startFluctuations, 
              icon: const Icon(Icons.play_arrow), 
              label: const Text('Начать движение'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: FilledButton.icon(
              onPressed: _platform.stop, 
              icon: const Icon(Icons.stop), 
              label: const Text('Остановить движение'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: chartsPadding,
                child: SineControlWidget(
                  title: 'Ось 1 (X)',
                  sineNotifier: _axis1SineNotifier,
                  minMaxNotifier: _minMaxNotifier,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: chartsPadding,
                child: SineControlWidget(
                  title: 'Ось 2 (Y)',
                  sineNotifier: _axis2SineNotifier,
                  minMaxNotifier: _minMaxNotifier,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: chartsPadding,
                child: SineControlWidget(
                  title: 'Ось 3 (Z)',
                  sineNotifier: _axis3SineNotifier,
                  minMaxNotifier: _minMaxNotifier,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
