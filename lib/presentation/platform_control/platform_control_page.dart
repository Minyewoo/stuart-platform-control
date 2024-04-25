import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stewart_platform_control/core/io/controller/mdbox_controller.dart';
import 'package:stewart_platform_control/core/io/storage/sine_storage.dart';
import 'package:stewart_platform_control/core/math/min_max.dart';
import 'package:stewart_platform_control/core/platform/stuart_platform.dart';
import 'package:stewart_platform_control/presentation/platform_control/widgets/min_max_notifier.dart';
import 'package:stewart_platform_control/presentation/platform_control/widgets/sine_notifier.dart';
import 'package:stewart_platform_control/presentation/platform_control/widgets/sine_control_widget.dart';
import 'package:toastification/toastification.dart';
///
class PlatformControlPage extends StatefulWidget {
  final Duration _controlFrequency;
  final MdboxController _controller;
  ///
  const PlatformControlPage({
    super.key,
    required MdboxController controller,
    Duration controlFrequency = const Duration(milliseconds: 100),
  }) : 
    _controller = controller,
    _controlFrequency = controlFrequency;
  //
  @override
  State<PlatformControlPage> createState() => _PlatformControlPageState();
}
///
class _PlatformControlPageState extends State<PlatformControlPage> {
  static const _xSinePrefix = 'x_';
  static const _ySinePrefix = 'y_';
  static const _zSinePrefix = 'z_';
  final _storage = const SineStorage();
  late bool _isPlatformMoving;
  late final SineNotifier _axisXSineNotifier;
  late final SineNotifier _axisYSineNotifier;
  late final SineNotifier _axisZSineNotifier;
  late final MinMaxNotifier _minMaxNotifier;
  late final StuartPlatform _platform;
  //
  @override
  void initState() {
    _isPlatformMoving = false;
    _axisXSineNotifier = SineNotifier();
    _axisYSineNotifier = SineNotifier();
    _axisZSineNotifier = SineNotifier();
    _minMaxNotifier = MinMaxNotifier();
    _tryRecomputeMinMax();
    _axisXSineNotifier.addListener(_tryRecomputeMinMax);
    _axisYSineNotifier.addListener(_tryRecomputeMinMax);
    _axisZSineNotifier.addListener(_tryRecomputeMinMax);
    _platform = StuartPlatform(
      xSineNotifier: _axisXSineNotifier,
      ySineNotifier: _axisYSineNotifier,
      zSineNotifier: _axisZSineNotifier,
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
    _retrieveSines();
    super.initState();
  }
  //
  @override
  void dispose() {
    _axisXSineNotifier.dispose();
    _axisYSineNotifier.dispose();
    _axisZSineNotifier.dispose();
    _minMaxNotifier.dispose();
    super.dispose();
  }
  ///
  void _retrieveSines() {
    SharedPreferences.getInstance().then(
      (prefs) {
        _axisXSineNotifier.value = _storage.retrieveSine(_xSinePrefix, prefs);
        _axisYSineNotifier.value = _storage.retrieveSine(_ySinePrefix, prefs);
        _axisZSineNotifier.value = _storage.retrieveSine(_zSinePrefix, prefs);
        _showInfo('Параметры загружены');
      },
    );
  }
  ///
  void _saveSines() {
    SharedPreferences.getInstance().then((prefs) {
      _storage.storeSine(_xSinePrefix, _axisXSineNotifier.value, prefs);
      _storage.storeSine(_ySinePrefix, _axisYSineNotifier.value, prefs);
      _storage.storeSine(_zSinePrefix, _axisZSineNotifier.value, prefs);
      _showInfo('Параметры сохранены');
    });
  }
  ///
  void _showInfo(String message) {
    toastification.show(
      alignment: Alignment.topCenter,
      showProgressBar: false,
      type: ToastificationType.info,
      style: ToastificationStyle.flat,
      backgroundColor: Theme.of(context).colorScheme.background,
      foregroundColor: Theme.of(context).colorScheme.onBackground,
      context: context,
      title: Text(message),
      autoCloseDuration: const Duration(seconds: 2),
    );
  }
  ///
  void _tryRecomputeMinMax() {
    final axis1MinMax = _axisXSineNotifier.value.minMax;
    final axis2MinMax = _axisYSineNotifier.value.minMax;
    final axis3MinMax = _axisZSineNotifier.value.minMax;
    _minMaxNotifier.value =MinMax(
      min: [axis1MinMax.min, axis2MinMax.min, axis3MinMax.min].reduce(min), 
      max: [axis1MinMax.max, axis2MinMax.max, axis3MinMax.max].reduce(max), 
    );
  }
  ///
  @override
  Widget build(BuildContext context) {
    const chartsPadding = EdgeInsets.only(top: 8.0, right: 16.0);
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTight = constraints.maxWidth < 1000;
        return Scaffold(
          appBar: AppBar(
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: isTight ? IconButton(
                  onPressed: _saveSines, 
                  icon: const Icon(Icons.save),
                  tooltip: 'Сохранить параметры',
                ) : FilledButton.icon(
                  onPressed: _saveSines, 
                  icon: const Icon(Icons.save), 
                  label: isTight ? const SizedBox() : const Text('Сохранить параметры'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: isTight ? Tooltip(
                  message: _isPlatformMoving 
                    ? 'Движение в процессе' 
                    : 'Движение остановлено',
                  child: Icon(
                      Icons.circle, 
                      color: _isPlatformMoving ? Colors.greenAccent : null,
                    ),
                ) : OutlinedButton.icon(
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
                child: isTight ? IconButton(
                  onPressed: _platform.startFluctuations,
                  icon: const Icon(Icons.play_arrow),
                  tooltip: 'Начать движение',
                ) : FilledButton.icon(
                  onPressed: _platform.startFluctuations,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Начать движение'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: isTight ? IconButton(
                  onPressed: _platform.stop,
                  icon: const Icon(Icons.stop),
                  tooltip: 'Остановить движение',
                ) : FilledButton.icon(
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
                      sineNotifier: _axisXSineNotifier,
                      minMaxNotifier: _minMaxNotifier,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: chartsPadding,
                    child: SineControlWidget(
                      title: 'Ось 2 (Y)',
                      sineNotifier: _axisYSineNotifier,
                      minMaxNotifier: _minMaxNotifier,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: chartsPadding,
                    child: SineControlWidget(
                      title: 'Ось 3 (Z)',
                      sineNotifier: _axisZSineNotifier,
                      minMaxNotifier: _minMaxNotifier,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
