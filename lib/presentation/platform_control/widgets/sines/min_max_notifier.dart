import 'package:flutter/foundation.dart';
import 'package:stewart_platform_control/core/math/min_max.dart';
///
class MinMaxNotifier<T> extends ValueNotifier<MinMax> {
  ///
  MinMaxNotifier({required MinMax<T> minMax}) : super(minMax);
}