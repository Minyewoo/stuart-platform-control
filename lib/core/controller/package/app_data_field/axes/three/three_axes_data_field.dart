import 'package:stuart_platform_control/core/bytes/int_extension.dart';
import 'package:stuart_platform_control/core/controller/package/app_data_field/app_data_field.dart';
import 'package:stuart_platform_control/core/controller/package/app_data_field/axes/three/position_3f.dart';
import 'package:stuart_platform_control/core/controller/package/byte_sequence.dart';

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
    required ByteSequence baseDout,
    required ByteSequence dac1_2,
    required ByteSequence extDout,
  }) => ThreeAxesDataField._([
    ...lineNumber.uInt32Bytes,
    ...time.uInt32Bytes,
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