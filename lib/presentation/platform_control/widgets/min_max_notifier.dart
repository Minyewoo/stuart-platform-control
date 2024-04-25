import 'package:flutter/foundation.dart';
import 'package:stewart_platform_control/core/math/min_max.dart';
///
class MinMaxNotifier extends ValueNotifier<MinMax> {
  ///
  MinMaxNotifier({MinMax minMax = const MinMax()}) : super(minMax);
}