import 'package:stuart_platform_control/core/controller/package/byte_sequence.dart';
///
class ObjectChannel implements ByteSequence {
  final Iterable<int> _bytes;
  ///
  const ObjectChannel._(this._bytes) : assert(_bytes.length==2);
  ///
  const factory ObjectChannel.fromIterable(Iterable<int> bytes) = ObjectChannel._;
  //
  @override
  Iterable<int> get bytes => _bytes;
}

/// Active report channels
const reportDX = [0x00, 0x00];

/// Register reading channels
const readingDX = [0x00, 0x00];
const readingFX = [0x00, 0x01];

/// Register writing channels
const writingFXm = [0x00, 0x00];
const writingFX = [0x00, 0x01];
const writingCX = [0x00, 0x02];

/// Axis mode channels
const threeAxisMode = [0x00, 0x00];
const sixAxisMode = [0x00, 0x01];