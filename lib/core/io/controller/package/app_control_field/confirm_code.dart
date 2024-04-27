import 'package:stewart_platform_control/core/io/controller/package/byte_sequence.dart';
///
class ConfirmCode implements ByteSequence {
  final Iterable<int> _bytes;
  ///
  const ConfirmCode._(this._bytes);
  /// 
  /// Should contain 2 bytes
  const factory ConfirmCode.fromIterable(Iterable<int> bytes) = ConfirmCode._;
  ///
  /// Default confirm code
  const ConfirmCode.def() : this._(const [0x55, 0xaa]);
  //
  @override
  Iterable<int> get bytes => _bytes;

}