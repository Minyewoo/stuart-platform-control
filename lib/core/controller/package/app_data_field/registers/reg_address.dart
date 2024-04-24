import 'package:stuart_platform_control/core/bytes/int_extension.dart';
import 'package:stuart_platform_control/core/controller/package/byte_sequence.dart';

class RegAddress implements ByteSequence {
  final Iterable<int> _bytes;
  ///
  const RegAddress._(this._bytes) : assert(_bytes.length==2);
  ///
  const factory RegAddress.fromIterable(Iterable<int> bytes) = RegAddress._;
  ///
  factory RegAddress.fromOffset(int offset) => RegAddress._(offset.int16Bytes);
  //
  @override
  Iterable<int> get bytes => _bytes;
}