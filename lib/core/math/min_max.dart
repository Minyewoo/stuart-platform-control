///
class MinMax {
  final double min;
  final double max;
  ///
  const MinMax({
    this.min = 0.0,
    this.max = 0.0,
  });
  ///
  factory MinMax.fromMap(Map<String, dynamic> map) {
    return MinMax(
      min: double.parse('${map['min']}'),
      max: double.parse('${map['max']}'),
    );
  }
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