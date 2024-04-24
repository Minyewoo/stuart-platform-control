import 'package:stuart_platform_control/core/controller/package/app_data_field/app_data_field.dart';
import 'package:stuart_platform_control/core/controller/package/app_data_field/registers/reg_address.dart';
import 'package:stuart_platform_control/core/controller/package/app_data_field/registers/reg_num.dart';
import 'package:stuart_platform_control/core/controller/package/byte_sequence.dart';

class RegDataField implements AppDataField {
  final Iterable<int> _bytes;
  ///
  const RegDataField._(this._bytes);
  ///
  const factory RegDataField.fromIterable(Iterable<int> bytes) = RegDataField._;
  ///
  RegDataField({
    required RegAddress regStart,
    required RegNum regNum,
    ByteSequence regData = const ByteSequence.fromIterable([]),
  }) : this._(regStart.bytes.followedBy(regNum.bytes).followedBy(regData.bytes));
  ///
  RegAddress get regStart => RegAddress.fromIterable(_bytes.take(2));
  ///
  RegNum get regNum => RegNum.fromIterable(_bytes.skip(2).take(2));
  ///
  ByteSequence get regData => ByteSequence.fromIterable(_bytes.skip(4));
  //
  @override
  Iterable<int> get bytes => _bytes;
}