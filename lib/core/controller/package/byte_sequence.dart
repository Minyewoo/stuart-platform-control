///
abstract interface class ByteSequence {
  ///
  const factory ByteSequence.fromIterable(
    Iterable<int> bytes,
  ) = _IterableByteSequence;
  ///
  Iterable<int> get bytes;
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