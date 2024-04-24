import 'package:stuart_platform_control/core/bytes/int_extension.dart';
import 'package:stuart_platform_control/core/controller/package/app_data_field/app_data_field.dart';
import 'package:stuart_platform_control/core/controller/package/app_data_field/axes/six/position_6f.dart';
import 'package:stuart_platform_control/core/controller/package/byte_sequence.dart';

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
    required Position6f position,
    required ByteSequence baseDout,
    required ByteSequence dac1_2,
    required ByteSequence extDout,
  }) => SixAxesDataField._([
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
  Position6f get position => Position6f.fromIterable(_bytes.skip(8).take(24));
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