import 'package:stewart_platform_control/core/bytes/int_extension.dart';
import 'package:stewart_platform_control/core/io/controller/package/app_data_field/app_data_field.dart';
import 'package:stewart_platform_control/core/io/controller/package/app_data_field/axes/six/position_6f.dart';
import 'package:stewart_platform_control/core/io/controller/package/byte_sequence.dart';

class SixAxesDataField implements AppDataField {
  final Iterable<int> _bytes;
  ///
  const SixAxesDataField._(this._bytes);
  ///
  const factory SixAxesDataField.fromIterable(Iterable<int> bytes) = SixAxesDataField._;
  ///
  factory SixAxesDataField({
    required int lineNumber,
    required int time,
    required Position6i position,
    ByteSequence baseDout = const ByteSequence.fromIterable([0x12, 0x34]),
    ByteSequence dac1_2 = const ByteSequence.fromIterable([0x56, 0x78, 0xab, 0xcd]),
    ByteSequence extDout = const ByteSequence.fromIterable([]),
  }) => SixAxesDataField._([
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
  Position6i get position => Position6i.fromIterable(_bytes.skip(8).take(24));
  ///
  ByteSequence get baseDout => ByteSequence.fromIterable(_bytes.skip(32).take(2));
  ///
  ByteSequence get dac1_2 => ByteSequence.fromIterable(_bytes.skip(34).take(4));
  ///
  ByteSequence get extDout => ByteSequence.fromIterable(_bytes.skip(38).take(2));
  //
  @override
  Iterable<int> get bytes => _bytes;
}