import 'dart:io';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:stuart_platform_control/core/controller/package/app_data_field/axes/six/six_axes_data_field.dart';
import 'package:stuart_platform_control/core/controller/package/app_data_field/axes/three/three_axes_data_field.dart';
import 'package:stuart_platform_control/core/controller/package/app_data_field/registers/reg_data_field.dart';
/// 
/// tipical UDP Data: 55aa000014010001ffffffff000004040000005300013b6400013b6400013b6400013b6400013b6400013b6412345678abcd
///
/// 55 aa           Confirm Code
/// 00 00           Pass Code
/// 14 01           Function Code
/// 00 01           Object Channel (axes mode)
/// ff ff           Who Accept
/// ff ff           Who Reply
/// 00 00 04 04     Line
/// 00 00 00 53     Abs Time
/// 00 01 3b 64     X Position
/// 00 01 3b 64     Y Position
/// 00 01 3b 64     Z Position
/// 00 01 3b 64     U Position
/// 00 01 3b 64     V Position
/// 00 01 3b 64     W Position
/// 12 34           Base Dout
/// 56 78 ab cd     DAC 1/2

///
class MdboxController {
  final InternetAddress _address;
  ///
  const MdboxController({
    required InternetAddress address,
  }) : _address = address;
  ///
  ResultF<void> readReg(RegDataField package) {
    // TODO implement readReg
    throw UnimplementedError();
  }
  ///
  ResultF<void> writeReg(RegDataField package) {
    // TODO implement writeReg
    throw UnimplementedError();
  }
  ///
  ResultF<void> sendPosition3f(ThreeAxesDataField package) {
    // TODO implement sendPosition3f
    throw UnimplementedError();
  }
  ///
  ResultF<void> sendPosition6f(SixAxesDataField package) {
    // TODO implement sendPosition6f
    throw UnimplementedError();
  }
}