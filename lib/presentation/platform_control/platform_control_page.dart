import 'dart:math';
import 'package:flutter/material.dart';
import 'package:stuart_platform_control/core/math/min_max.dart';
import 'package:stuart_platform_control/core/math/sine.dart';
import 'package:stuart_platform_control/presentation/platform_control/widgets/min_max_notifier.dart';
import 'package:stuart_platform_control/presentation/platform_control/widgets/sine_notifier.dart';
import 'package:stuart_platform_control/presentation/platform_control/widgets/sine_control_widget.dart';
///
class PlatformControlPage extends StatefulWidget {
  ///
  const PlatformControlPage({super.key});
  //
  @override
  State<PlatformControlPage> createState() => _PlatformControlPageState();
}
///
class _PlatformControlPageState extends State<PlatformControlPage> {
  late final SineNotifier _axis1SineNotifier;
  late final SineNotifier _axis2SineNotifier;
  late final SineNotifier _axis3SineNotifier;
  late final MinMaxNotifier _minMaxNotifier;
  //
  @override
  void initState() {
    _axis1SineNotifier = SineNotifier(
      sine: const Sine(),
    );
    _axis2SineNotifier = SineNotifier(
      sine: const Sine(
        amplitude: 2,
        period: pi,
        phaseShift: pi/2,
      ),
    );
    _axis3SineNotifier = SineNotifier(
      sine: const Sine(
        amplitude: 0.5,
        period: pi/2,
        phaseShift: pi,
      ),
    );
    _minMaxNotifier = MinMaxNotifier();
    _tryRecomputeMinMax();
    _axis1SineNotifier.addListener(_tryRecomputeMinMax);
    _axis2SineNotifier.addListener(_tryRecomputeMinMax);
    _axis3SineNotifier.addListener(_tryRecomputeMinMax);
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
            child: FilledButton.icon(
              onPressed: () {}, 
              icon: const Icon(Icons.save), 
              label: const Text('Загрузить на контроллер'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: FilledButton.icon(
              onPressed: () {}, 
              icon: const Icon(Icons.play_arrow), 
              label: const Text('Начать движение'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: FilledButton.icon(
              onPressed: () {}, 
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
                  title: 'Ось 1',
                  sineNotifier: _axis1SineNotifier,
                  minMaxNotifier: _minMaxNotifier,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: chartsPadding,
                child: SineControlWidget(
                  title: 'Ось 2',
                  sineNotifier: _axis2SineNotifier,
                  minMaxNotifier: _minMaxNotifier,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: chartsPadding,
                child: SineControlWidget(
                  title: 'Ось 3',
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
