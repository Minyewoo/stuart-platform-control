import 'package:stuart_platform_control/core/controller/package/byte_sequence.dart';
///
class ConfirmCode implements ByteSequence {
  final Iterable<int> _bytes;
  ///
  const ConfirmCode._(this._bytes) : assert(_bytes.length==2);
  ///
  const factory ConfirmCode.fromIterable(Iterable<int> bytes) = ConfirmCode._;
  ///
  /// Default confirm code
  const ConfirmCode.def() : this._(const [0x55, 0xaa]);
  //
  @override
  Iterable<int> get bytes => _bytes;

}