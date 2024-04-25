import 'package:stewart_platform_control/core/io/controller/package/byte_sequence.dart';

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