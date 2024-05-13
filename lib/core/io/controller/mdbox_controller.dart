import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:stewart_platform_control/core/entities/cilinder_lengths_3f.dart';
import 'package:stewart_platform_control/core/io/controller/package/app_control_field/app_control_field.dart';
import 'package:stewart_platform_control/core/io/controller/package/app_control_field/function_code.dart';
import 'package:stewart_platform_control/core/io/controller/package/app_control_field/object_channel.dart';
import 'package:stewart_platform_control/core/io/controller/package/app_data_field/axes/six/position_6f.dart';
import 'package:stewart_platform_control/core/io/controller/package/app_data_field/axes/six/six_axes_data_field.dart';
import 'package:stewart_platform_control/core/io/controller/package/app_data_field/axes/three/position_3f.dart';
import 'package:stewart_platform_control/core/io/controller/package/app_data_field/axes/three/three_axes_data_field.dart';
import 'package:stewart_platform_control/core/io/controller/package/app_data_field/axes/three/validation/three_axes_data_field_coords_delta_check.dart';
import 'package:stewart_platform_control/core/io/controller/package/app_data_field/axes/three/validation/three_axes_data_field_max_time_check.dart';
import 'package:stewart_platform_control/core/io/controller/package/app_data_field/axes/three/validation/three_axes_data_field_max_positions_check.dart';
import 'package:stewart_platform_control/core/io/controller/package/app_data_field/axes/three/validation/three_axes_data_field_min_positions_check.dart';
import 'package:stewart_platform_control/core/io/controller/package/app_data_field/axes/three/validation/three_axes_data_field_min_time_check.dart';
import 'package:stewart_platform_control/core/io/controller/package/app_data_field/registers/reg_data_field.dart';
import 'package:stewart_platform_control/core/io/controller/package/app_who_field/app_who_field.dart';
import 'package:stewart_platform_control/core/io/controller/package/udp_data.dart';
import 'package:stewart_platform_control/core/net_address.dart';
import 'package:stewart_platform_control/core/validation/validation_cases.dart';
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
  static const _positionFactor = 1000000;
  static const _threeAxesDataChecks = ValidationCases<ThreeAxesDataField>(
    cases: [
      ThreeAxesDataFieldMinTimeCheck(minTime: Duration(milliseconds: 1)),
      ThreeAxesDataFieldMaxTimeCheck(maxTime: Duration(milliseconds: 30000)),
      ThreeAxesDataMinPositionsCheck(minPosition: 0),
      ThreeAxesDataMaxPositionsCheck(maxPosition: 800000),
      ThreeAxesDataPositionsDeltaCheck(maxDelta: 400000),
    ],
  );
  final NetAddress _myAddress;
  final NetAddress _controllerAddress;
  final _responseController = StreamController<UdpData>.broadcast();
  RawDatagramSocket? _socket;
  ///
  MdboxController({
    NetAddress myAddress = const NetAddress.localhost(8888),
    required NetAddress controllerAddress,
  }) : 
    _myAddress = myAddress,
    _controllerAddress = controllerAddress;
  ///
  Stream<UdpData> get responseStream => _responseController.stream;
  ///
  Future<void> send(UdpData data) async {
    await _maybeStartSocket();
    final socket = _socket!;
    socket.writeEventsEnabled = true;
    socket.send(
      data.bytes.toList(),
      InternetAddress(_controllerAddress.ipv4, type: InternetAddressType.IPv4),
      _controllerAddress.port,
    );
    await Future.delayed(Duration.zero);
    socket.writeEventsEnabled = false;
  }
  ///
  Future<ResultF<void>> sendPosition3i(
    CilinderLengths3f lengths, {
      Duration time = const Duration(milliseconds: 1),
    }) async {
    final dataField = ThreeAxesDataField(
      lineNumber: 1,
      time: time.inMilliseconds,
      position: Position3i.fromValue(
        x: (lengths.cilinder1 * _positionFactor).round(),
        y: (lengths.cilinder3 * _positionFactor).round(),
        z: (lengths.cilinder2 * _positionFactor).round(),
      ),
    );
    // print('${dataField.position.x}, ${dataField.position.y}, ${dataField.position.z}');
    if(_threeAxesDataChecks.isSatisfiedBy(dataField)) {
      final udpData = UdpData(
        controlField: AppControlField.def(
          functionCode: const FunctionCode.fromIterable(deltaTimePlayAll),
          objectChannel: const ObjectChannel.fromIterable(threeAxisMode),
        ),
        whoField: AppWhoField.all(),
        dataField: dataField,
      );
      await send(udpData);
      return const Ok(null);
    } else {
      return Err(
        Failure(
          message: 'Invalid ThreeAxesDataField',
          stackTrace: StackTrace.current,
        ),
      );
    }
  }
  ///
  Future<ResultF<void>> sendPosition6i(Position6i position, {
    Duration time = const Duration(milliseconds: 1),
  }) async {
    // TODO(minyewoo): make validation
    final udpData = UdpData(
      controlField: AppControlField.def(
        functionCode: const FunctionCode.fromIterable(deltaTimePlayAll),
        objectChannel: const ObjectChannel.fromIterable(sixAxisMode),
      ),
      whoField: AppWhoField.all(),
      dataField: SixAxesDataField(
        lineNumber: 1,
        time: time.inMilliseconds,
        position: position.copyWith(
          x: position.x * _positionFactor,
          y: position.y * _positionFactor,
          z: position.z * _positionFactor,
          u: position.u * _positionFactor,
          v: position.v * _positionFactor,
          w: position.w * _positionFactor,
        ),
      ),
    );
    await send(udpData);
    return const Ok(null);
  }
  ///
  Future<ResultF<void>> readRegister(RegDataField regData, ObjectChannel channel) async {
    final udpData = UdpData(
      controlField: AppControlField.def(
        functionCode: const FunctionCode.fromIterable(readReg),
        objectChannel: channel,
      ),
      whoField: AppWhoField.all(),
      dataField: regData,
    );
    await send(udpData);
    return const Ok(null);
  }
  ///
  Future<ResultF<void>> writeRegister(RegDataField regData, ObjectChannel channel) async {
    final udpData = UdpData(
      controlField: AppControlField.def(
        functionCode: const FunctionCode.fromIterable(writeReg),
        objectChannel: channel,
      ),
      whoField: AppWhoField.all(),
      dataField: regData,
    );
    await send(udpData);
    return const Ok(null);
  }
  ///
  Future<void> _maybeStartSocket() async {
    if(_socket == null) {
      // TODO(minyewoo): catch error with Result
      _socket = await RawDatagramSocket.bind(
        _myAddress.ipv4,
        _myAddress.port,
        reuseAddress: true,
        reusePort: true,
      );
      _socket!.listen((event) {
        switch (event) {
          case RawSocketEvent.read:
            final datagram = _socket?.receive();
            final package = UdpData.fromIterable(datagram!.data);
            _responseController.add(package);
            final functionCode = package.controlField.functionCode.bytes.toList();
            switch(functionCode) {
              case absTimePlayAllRight:
                log('absTimePlayAllRight');
                break;
              case absTimePlayAllErr1:
                log('Error (absTime): internal buffer is full');
                break;
              case absTimePlayAllErr2:
                log('Error (absTime): data length of data frame is inadequate');
                break;
              case deltaTimePlayAllRight:
                log('deltaTimePlayAllRight');
                break;
              case deltaTimePlayAllErr1:
                log('Error (deltaTime): internal buffer is full');
                break;
              case deltaTimePlayAllErr2:
                log('Error (deltaTime): data length of data frame is inadequate');
                break;
              case writeRegRightReply:
                log('writeRegRightReply');
              case writeRegFalseReply:
                log('writeRegFalseReply');
              default:
                log('Unknown function code: ${functionCode.map((e) => e.toRadixString(16).padLeft(2,'0'))}');
            }
            break;
          case RawSocketEvent.readClosed:
            log('readClosed');
            // TODO(minyewoo): Handle this case.
            break;
          case RawSocketEvent.write:
            log('write');
            break;
          case RawSocketEvent.closed:
            log('closed');
            // TODO(minyewoo): Handle this case.
            break;
        }
        event.toString();
      });
    }
  }
}