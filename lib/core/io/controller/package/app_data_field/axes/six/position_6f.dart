import 'package:stewart_platform_control/core/bytes/int_extension.dart';
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
  //
  @override
  Iterable<int> get bytes => _bytes;
}