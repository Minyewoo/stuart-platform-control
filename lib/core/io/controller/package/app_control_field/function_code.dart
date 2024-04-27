import 'package:stewart_platform_control/core/io/controller/package/byte_sequence.dart';
///
class FunctionCode implements ByteSequence {
  final Iterable<int> _bytes;
  ///
  const FunctionCode._(this._bytes);
  /// 
  /// Should contain 2 bytes
  const factory FunctionCode.fromIterable(Iterable<int> bytes) = FunctionCode._;
  //
  @override
  Iterable<int> get bytes => _bytes;
}

/// Monitoring funtion code
const reportReg = [0x10, 0x01];

/// Registers read function codes
const readReg = [0x11, 0x01];
const readRegRightReply = [0x11, 0x02];
const readRegFalseReply = [0x11, 0x03];

/// Registers write function codes
const writeReg = [0x12, 0x01];
const writeRegRightReply = [0x12, 0x02];
const writeRegFalseReply = [0x12, 0x03];

/// Operation of MBOX Absolute Playing Time Data (3-axis or 6-axis modes) codes
const absTimePlayAll = [0x13, 0x01];
const absTimePlayAllRight = [0x13, 0x02];
/// cause of error: internal buffer is full
const absTimePlayAllErr1 = [0x13, 0x03];
/// cause of error: data length of data frame is inadequate
const absTimePlayAllErr2 = [0x13, 0x04];

/// Operation of MBOX Relative Playing Time Data (3-axis or 6-axis modes) codes
const deltaTimePlayAll = [0x14, 0x01];
const deltaTimePlayAllRight = [0x14, 0x02];
/// cause of error: internal buffer is full
const deltaTimePlayAllErr1 = [0x14, 0x03];
/// cause of error: data length of data frame is inadequate
const deltaTimePlayAllErr2 = [0x14, 0x04];