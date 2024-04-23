///
class MinMax {
  final double min;
  final double max;
  ///
  const MinMax({
    this.min = 0.0,
    this.max = 0.0,
  });
  //
  @override
  int get hashCode => min.hashCode ^ max.hashCode;
  //
  @override
  bool operator ==(Object other) {
    return other is MinMax
      && min == other.min
      && max == other.max;
  }
}