import 'package:stewart_platform_control/core/io/controller/package/app_control_field/app_control_field.dart';
import 'package:stewart_platform_control/core/io/controller/package/app_control_field/function_code.dart';
import 'package:stewart_platform_control/core/io/controller/package/app_control_field/object_channel.dart';
import 'package:stewart_platform_control/core/io/controller/package/app_data_field/app_data_field.dart';
import 'package:stewart_platform_control/core/io/controller/package/app_data_field/axes/six/six_axes_data_field.dart';
import 'package:stewart_platform_control/core/io/controller/package/app_data_field/axes/three/three_axes_data_field.dart';
import 'package:stewart_platform_control/core/io/controller/package/app_data_field/unknown_data_field.dart';
import 'package:stewart_platform_control/core/io/controller/package/app_data_field/registers/reg_data_field.dart';
import 'package:stewart_platform_control/core/io/controller/package/app_who_field/app_who_field.dart';
import 'package:stewart_platform_control/core/io/controller/package/byte_sequence.dart';
///
class UdpData implements ByteSequence {
  final Iterable<int> _bytes;
  ///
  const UdpData._(this._bytes);
  ///
  UdpData({
    required AppControlField controlField, 
    required AppWhoField whoField, 
    required AppDataField dataField, 
  }) : this._(
    controlField.bytes
    .followedBy(whoField.bytes)
    .followedBy(dataField.bytes),
  );
  ///
  const factory UdpData.fromIterable(Iterable<int> bytes) = UdpData._;
  ///
  AppControlField get controlField => AppControlField.fromIterable(_bytes.take(8));
  ///
  AppWhoField get whoField => AppWhoField.fromIterable(_bytes.skip(8).take(4));
  ///
  AppDataField get dataField {
    final data = _bytes.skip(12);
    return switch(controlField.functionCode.bytes) {    
      reportReg
      || readReg 
      || readRegRightReply 
      || readRegFalseReply
      || writeReg 
      || writeRegRightReply 
      || writeRegFalseReply => RegDataField.fromIterable(data),
      absTimePlayAll 
      || absTimePlayAllRight 
      || absTimePlayAllErr1
      || absTimePlayAllErr2
      ||deltaTimePlayAll 
      || deltaTimePlayAllRight 
      || deltaTimePlayAllErr1
      || deltaTimePlayAllErr2  => switch(controlField.objectChannel.bytes) {
        threeAxisMode => ThreeAxesDataField.fromIterable(data),
        sixAxisMode => SixAxesDataField.fromIterable(data),
        _ => UnknownDataField.fromIterable(data),
      },
      _ => UnknownDataField.fromIterable(data),
    };
  }
  //
  @override
  Iterable<int> get bytes => _bytes;
}