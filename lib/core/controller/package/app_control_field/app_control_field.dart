import 'package:stuart_platform_control/core/controller/package/app_control_field/confirm_code.dart';
import 'package:stuart_platform_control/core/controller/package/app_control_field/function_code.dart';
import 'package:stuart_platform_control/core/controller/package/app_control_field/object_channel.dart';
import 'package:stuart_platform_control/core/controller/package/app_control_field/pass_code.dart';
import 'package:stuart_platform_control/core/controller/package/byte_sequence.dart';
///
class AppControlField implements ByteSequence {
  final Iterable<int> _bytes;
  ///
  const AppControlField._(this._bytes) : assert(_bytes.length == 8);
  ///
  AppControlField({
    required ConfirmCode confirmCode, 
    required PassCode passCode, 
    required FunctionCode functionCode, 
    required ObjectChannel objectChannel,
  }) : this._(
    confirmCode.bytes
    .followedBy(passCode.bytes)
    .followedBy(functionCode.bytes)
    .followedBy(objectChannel.bytes),
  );
  ///
  const factory AppControlField.fromIterable(Iterable<int> bytes) = AppControlField._;
  ///
  ConfirmCode get confirmCode => ConfirmCode.fromIterable(_bytes.take(2));
  ///
  PassCode get passCode => PassCode.fromIterable(_bytes.skip(2).take(2));
  ///
  FunctionCode get functionCode => FunctionCode.fromIterable(_bytes.skip(4).take(2));
  ///
  ObjectChannel get objectChannel => ObjectChannel.fromIterable(_bytes.skip(6).take(2));
  //
  @override
  Iterable<int> get bytes => _bytes;
}