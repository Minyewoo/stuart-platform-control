import 'package:stuart_platform_control/core/controller/package/byte_sequence.dart';

class RegData implements ByteSequence {
  final Iterable<int> _bytes;
  ///
  const RegData._(this._bytes);
  ///
  const factory RegData.fromIterable(Iterable<int> bytes) = RegData._;
  ///
  
  //
  @override
  Iterable<int> get bytes => _bytes;
}