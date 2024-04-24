import 'package:stuart_platform_control/core/bytes/int_extension.dart';
import 'package:stuart_platform_control/core/controller/package/byte_sequence.dart';

class Position3f implements ByteSequence {
  final Iterable<int> _bytes;
  ///
  const Position3f._(this._bytes) : assert(_bytes.length==12);
  ///
  const factory Position3f.fromIterable(Iterable<int> bytes) = Position3f._;
  ///
  factory Position3f.fromValue({
    required int x,
    required int y,
    required int z,
  }) => Position3f._([
    ...x.uInt32Bytes,
    ...y.uInt32Bytes,
    ...z.uInt32Bytes,
  ]);
  //
  @override
  Iterable<int> get bytes => _bytes;
}