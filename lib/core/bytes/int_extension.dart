import 'dart:typed_data';

///
extension Bytes on int {
  ///
  Iterable<int> get int8Bytes => Uint8List(1)
    ..buffer.asByteData().setInt8(0, this);
  ///
  Iterable<int> get int16Bytes => Uint8List(2)
    ..buffer.asByteData().setInt16(0, this, Endian.big);
  ///
  Iterable<int> get int32Bytes => Uint8List(4)
    ..buffer.asByteData().setInt32(0, this, Endian.big);
}