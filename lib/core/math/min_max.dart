///
class MinMax<T> {
  final T min;
  final T max;
  ///
  const MinMax({
    required this.min,
    required this.max,
  });
  ///
  factory MinMax.fromMap(Map<String,dynamic> map) {
    return MinMax(
      min: map['min'] as T,
      max: map['max'] as T,
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