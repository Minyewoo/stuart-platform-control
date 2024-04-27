import 'package:stewart_platform_control/core/io/controller/package/byte_sequence.dart';
///
sealed class Who implements ByteSequence {
  ///
  const factory Who.none() = _None;
  ///
  const factory Who.all() = _All;
  ///
  const factory Who.num(int num) = _Num;
  ///
  const factory Who.group(int group) = _Group;
  ///
  const factory Who.me(int group, int num) = _Me;
  ///
  factory Who.fromIterable(Iterable<int> bytes) {
    final bytesList = bytes.toList(growable: false);
    assert(bytesList.length==2);
    return _Me(bytesList[0], bytesList[1]);
  }
}
///
final class _None implements Who {
  ///
  const _None();
  //
  @override
  Iterable<int> get bytes => const [0x00, 0x00];
}
///
final class _All implements Who {
  ///
  const _All();
  //
  @override
  Iterable<int> get bytes => const [0xff, 0xff];
}
///
final class _Num implements Who {
  final int _num;
  ///
  const _Num(this._num);
  //
  @override
  Iterable<int> get bytes => [0xff, _num];
}
///
final class _Group implements Who {
  final int _group;
  ///
  const _Group(this._group);
  //
  @override
  Iterable<int> get bytes => [_group, 0xff];
}
///
final class _Me implements Who {
  final int _group;
  final int _num;
  ///
  const _Me(this._group, this._num);
  //
  @override
  Iterable<int> get bytes => [_group, _num];
}
