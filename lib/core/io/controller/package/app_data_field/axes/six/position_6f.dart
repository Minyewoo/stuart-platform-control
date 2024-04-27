import 'package:stewart_platform_control/core/bytes/int_extension.dart';
import 'package:stewart_platform_control/core/bytes/iterable_extension.dart';
import 'package:stewart_platform_control/core/io/controller/package/byte_sequence.dart';

class Position6f implements ByteSequence {
  final Iterable<int> _bytes;
  ///
  const Position6f._(this._bytes) : assert(_bytes.length==24);
  ///
  const factory Position6f.fromIterable(Iterable<int> bytes) = Position6f._;
  ///
  factory Position6f.fromValue({
    required int x,
    required int y,
    required int z,
    required int u,
    required int v,
    required int w,
  }) => Position6f._([
    ...x.int32Bytes,
    ...y.int32Bytes,
    ...z.int32Bytes,
    ...u.int32Bytes,
    ...v.int32Bytes,
    ...w.int32Bytes,
  ]);
  ///
  int get x => _bytes.take(4).asInt32();
  ///
  int get y => _bytes.skip(4).take(4).asInt32();
  ///
  int get z => _bytes.skip(8).take(4).asInt32();
  ///
  int get u => _bytes.take(12).take(4).asInt32();
  ///
  int get v => _bytes.skip(16).take(4).asInt32();
  ///
  int get w => _bytes.skip(20).take(4).asInt32();
  //
  @override
  Iterable<int> get bytes => _bytes;
  ///
  Position6f copyWith({
    int? x,
    int? y,
    int? z,
    int? u,
    int? v,
    int? w,
  }) => Position6f.fromValue(
    x: x ?? this.x,
    y: y ?? this.y,
    z: z ?? this.z,
    u: x ?? this.x,
    v: y ?? this.y,
    w: z ?? this.z,
  );
}