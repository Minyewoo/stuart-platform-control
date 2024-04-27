import 'package:stewart_platform_control/core/io/controller/package/app_who_field/who.dart';
import 'package:stewart_platform_control/core/io/controller/package/byte_sequence.dart';
///
class AppWhoField implements ByteSequence {
  final Iterable<int> _bytes;
  ///
  const AppWhoField._(this._bytes);
  /// 
  /// Should contain 4 bytes
  const factory AppWhoField.fromIterable(Iterable<int> bytes) = AppWhoField._;
  ///
  AppWhoField({
    required Who whoAccept,
    required Who whoReply,
  }) : this._(
    whoAccept.bytes
    .followedBy(whoReply.bytes),
  );
  ///
  Who get whoAccept => Who.fromIterable(_bytes.take(2));
  ///
  Who get whoReply =>  Who.fromIterable(_bytes.skip(2).take(2));
  ///
  @override
  Iterable<int> get bytes => _bytes;
}