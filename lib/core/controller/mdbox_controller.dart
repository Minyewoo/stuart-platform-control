import 'dart:io';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:stuart_platform_control/core/controller/package/app_control_field/app_control_field.dart';
import 'package:stuart_platform_control/core/controller/package/app_control_field/function_code.dart';
import 'package:stuart_platform_control/core/controller/package/app_control_field/object_channel.dart';
import 'package:stuart_platform_control/core/controller/package/app_data_field/axes/six/six_axes_data_field.dart';
import 'package:stuart_platform_control/core/controller/package/app_data_field/axes/three/position_3f.dart';
import 'package:stuart_platform_control/core/controller/package/app_data_field/axes/three/three_axes_data_field.dart';
import 'package:stuart_platform_control/core/controller/package/app_data_field/registers/reg_data_field.dart';
import 'package:stuart_platform_control/core/controller/package/app_who_field/app_who_field.dart';
import 'package:stuart_platform_control/core/controller/package/app_who_field/who.dart';
import 'package:stuart_platform_control/core/controller/package/udp_data.dart';
import 'package:stuart_platform_control/core/net_address.dart';
/// 
/// tipical UDP Data: 55aa000014010001ffffffff000004040000005300013b6400013b6400013b6400013b6400013b6400013b6412345678abcd
///
/// 55 aa           Confirm Code
/// 00 00           Pass Code
/// 14 01           Function Code
/// 00 01           Object Channel (e.g. axes mode)
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
  final NetAddress _myAddress;
  final NetAddress _controllerAddress;
  ///
  const MdboxController({
    NetAddress myAddress = const NetAddress.localhost(8888),
    required NetAddress controllerAddress,
  }) : 
    _myAddress = myAddress,
    _controllerAddress = controllerAddress;
  ///
  Future<ResultF<void>> readReg(RegDataField package) {
    // TODO implement readReg
    throw UnimplementedError();
  }
  ///
  Future<ResultF<void>> writeReg(RegDataField package) {
    // TODO implement writeReg
    throw UnimplementedError();
  }
  ///
  Future<ResultF<void>> sendPosition3f(Position3f position) async {
    final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, _myAddress.port);
    socket.send(
      UdpData(
        controlField: AppControlField.def(
          functionCode: const FunctionCode.fromIterable(deltaTimePlayAll),
          objectChannel: const ObjectChannel.fromIterable(threeAxisMode),
        ),
        whoField: AppWhoField(
          whoAccept: const Who.all(),
          whoReply: const Who.all(),
        ),
        dataField: ThreeAxesDataField(
          lineNumber: 1,
          time: 64,
          position: position,
        ),
      ).bytes.toList(),
      InternetAddress(_controllerAddress.ipv4, type: InternetAddressType.IPv4),
      _controllerAddress.port,
    );
    socket.close();
    return const Ok(null);
  }
  ///
  Future<ResultF<void>> sendPosition6f(SixAxesDataField package) {
    // TODO implement sendPosition6f
    throw UnimplementedError();
  }
}