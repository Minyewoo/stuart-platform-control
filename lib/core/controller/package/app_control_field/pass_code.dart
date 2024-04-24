import 'package:stuart_platform_control/core/controller/package/byte_sequence.dart';
///
class PassCode implements ByteSequence {
  final Iterable<int> _bytes;
  ///
  const PassCode._(this._bytes) : assert(_bytes.length==2);
  ///
  const factory PassCode.fromIterable(Iterable<int> bytes) = PassCode._;
  ///
  /// No pass code
  const PassCode.none() : this._(const [0x00, 0x00]);
  //
  @override
  Iterable<int> get bytes => _bytes;

}