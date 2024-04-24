import 'package:stuart_platform_control/core/bytes/int_extension.dart';
import 'package:stuart_platform_control/core/controller/package/byte_sequence.dart';

class RegNum implements ByteSequence {
  final Iterable<int> _bytes;
  ///
  const RegNum._(this._bytes) : assert(_bytes.length==2);
  ///
  const factory RegNum.fromIterable(Iterable<int> bytes) = RegNum._;
  //
  ///
  factory RegNum.fromCount(int count) => RegNum._(count.int16Bytes);
  //
  @override
  Iterable<int> get bytes => _bytes;
}