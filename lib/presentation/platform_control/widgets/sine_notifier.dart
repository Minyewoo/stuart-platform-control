import 'package:flutter/foundation.dart';
import 'package:stewart_platform_control/core/math/sine.dart';
///
class SineNotifier extends ValueNotifier<Sine> {
  ///
  SineNotifier({Sine sine = const Sine()}) : super(sine);
}