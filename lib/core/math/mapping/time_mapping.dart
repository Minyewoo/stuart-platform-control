import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stewart_platform_control/core/math/mapping/mapping.dart';
/// 
/// Computes [O] frequently based on how many seconds passed (with seconds fractions).
class TimeMapping<O> extends ValueNotifier<O> implements Mapping<double,O> {
  final Mapping<double,O> _mapping;
  final Duration _frequency;
  DateTime _startTime = DateTime.now();
  Timer? _timer;
  ///
  TimeMapping({
    required Mapping<double, O> mapping,
    required Duration frequency,
  }) :
    _mapping = mapping,
    _frequency = frequency,
    super(mapping.of(0.0));
  ///
  void start() {
    stop();
    _startTime = DateTime.now();
    _timer = Timer.periodic(_frequency, (_) {
      final t =  DateTime.now().difference(_startTime).inMilliseconds / 1000.0;
      value = of(t);
    });
  }
  ///
  void stop() {
    _timer?.cancel();
  }
  //
  @override
  O of(double x) => _mapping.of(x);
}