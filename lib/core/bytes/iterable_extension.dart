import 'dart:typed_data';

extension Bytes on Iterable<int> {
  int asInt32() => Int8List.fromList(toList()).buffer.asByteData().getInt32(0);
}