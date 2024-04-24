import 'package:stuart_platform_control/core/bytes/int_extension.dart';
import 'package:stuart_platform_control/core/controller/package/byte_sequence.dart';

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
    ...x.uInt32Bytes,
    ...y.uInt32Bytes,
    ...z.uInt32Bytes,
    ...u.uInt32Bytes,
    ...v.uInt32Bytes,
    ...w.uInt32Bytes,
  ]);
  //
  @override
  Iterable<int> get bytes => _bytes;
}