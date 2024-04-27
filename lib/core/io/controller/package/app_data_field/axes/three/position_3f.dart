import 'package:stewart_platform_control/core/bytes/int_extension.dart';
import 'package:stewart_platform_control/core/bytes/iterable_extension.dart';
import 'package:stewart_platform_control/core/io/controller/package/byte_sequence.dart';

class Position3f implements ByteSequence {
  final Iterable<int> _bytes;
  ///
  const Position3f._(this._bytes);
  /// 
  /// Should be 12 bytes.
  const factory Position3f.fromIterable(Iterable<int> bytes) = Position3f._;
  ///
  factory Position3f.fromValue({
    required int x,
    required int y,
    required int z,
  }) => Position3f._([
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
  String toString() => '$Position3f{x: $x; y: $y; z: $z}';
  //
  @override
  Iterable<int> get bytes => _bytes;
}