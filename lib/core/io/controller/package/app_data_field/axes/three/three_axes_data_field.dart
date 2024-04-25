import 'package:stewart_platform_control/core/bytes/int_extension.dart';
import 'package:stewart_platform_control/core/io/controller/package/app_data_field/app_data_field.dart';
import 'package:stewart_platform_control/core/io/controller/package/app_data_field/axes/three/position_3f.dart';
import 'package:stewart_platform_control/core/io/controller/package/byte_sequence.dart';

class ThreeAxesDataField implements AppDataField {
  final Iterable<int> _bytes;
  ///
  const ThreeAxesDataField._(this._bytes);
  ///
  const factory ThreeAxesDataField.fromIterable(Iterable<int> bytes) = ThreeAxesDataField._;
  ///
  factory ThreeAxesDataField({
    required int lineNumber,
    required int time,
    required Position3f position,
    ByteSequence baseDout = const ByteSequence.fromIterable([0x12, 0x34]),
    ByteSequence dac1_2 = const ByteSequence.fromIterable([0x56, 0x78, 0xab, 0xcd]),
    ByteSequence extDout = const ByteSequence.fromIterable([]),
  }) => ThreeAxesDataField._([
    ...lineNumber.int32Bytes,
    ...time.int32Bytes,
    ...position.bytes,
    ...baseDout.bytes,
    ...dac1_2.bytes,
    ...extDout.bytes,
  ]);
  ///
  int get lineNumber => _bytes.take(4).reduce((value, element) => value | element);
  ///
  int get time => _bytes.skip(4).take(4).reduce((value, element) => value | element);
  ///
  Position3f get position => Position3f.fromIterable(_bytes.skip(8).take(12));
  ///
  ByteSequence get baseDout => ByteSequence.fromIterable(_bytes.skip(20).take(2));
  ///
  ByteSequence get dac1_2 => ByteSequence.fromIterable(_bytes.skip(22).take(4));
  ///
  ByteSequence get extDout => ByteSequence.fromIterable(_bytes.skip(26).take(2));
  //
  @override
  Iterable<int> get bytes => _bytes;
}