import 'package:stewart_platform_control/core/bytes/int_extension.dart';
import 'package:stewart_platform_control/core/bytes/iterable_extension.dart';
import 'package:stewart_platform_control/core/io/controller/package/byte_sequence.dart';

class Position3i implements ByteSequence {
  final Iterable<int> _bytes;
  ///
  const Position3i._(this._bytes);
  ///
  const Position3i.zero() : this._(const [0,0,0,0,0,0,0,0,0,0,0,0]);
  /// 
  /// Should be 12 bytes.
  const factory Position3i.fromIterable(Iterable<int> bytes) = Position3i._;
  ///
  factory Position3i.fromValue({
    required int x,
    required int y,
    required int z,
  }) => Position3i._([
    ...x.int32Bytes,
    ...y.int32Bytes,
    ...z.int32Bytes,
  ]);
  ///
  int get x => _bytes.take(4).asInt32();
  ///
  int get y => _bytes.skip(4).take(4).asInt32();
  ///
  int get z => _bytes.skip(8).take(4).asInt32();
  //
  @override
  String toString() => '$Position3i{x: $x; y: $y; z: $z}';
  //
  @override
  Iterable<int> get bytes => _bytes;
  ///
  Position3i copyWith({
    int? x,
    int? y,
    int? z,
  }) => Position3i.fromValue(
    x: x ?? this.x,
    y: y ?? this.y,
    z: z ?? this.z,
  );
  ///
  Position3i add(num value) {
    final flooredValue = value.floor();
    return Position3i.fromValue(
      x: x + flooredValue,
      y: y + flooredValue,
      z: z + flooredValue,
    );
  }
}