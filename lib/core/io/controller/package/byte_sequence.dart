///
abstract interface class ByteSequence {
  ///
  const factory ByteSequence.fromIterable(
    Iterable<int> bytes,
  ) = _IterableByteSequence;
  ///
  Iterable<int> get bytes;
}

extension HexString on ByteSequence {
  String toHexString() {
    return bytes
      .map(
        (byte) => byte
          .toRadixString(16)
          .padLeft(2,'0'),
      )
      .toList()
      .toString();
  }
}

///
class _IterableByteSequence implements ByteSequence {
  final Iterable<int> _iterable;
  ///
  const _IterableByteSequence(Iterable<int> iterable) : _iterable = iterable;
  //
  @override
  Iterable<int> get bytes => _iterable;
}