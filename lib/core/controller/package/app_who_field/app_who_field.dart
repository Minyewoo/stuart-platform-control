import 'package:stuart_platform_control/core/controller/package/app_who_field/who.dart';
import 'package:stuart_platform_control/core/controller/package/byte_sequence.dart';
///
class AppWhoField implements ByteSequence {
  final Iterable<int> _bytes;
  ///
  const AppWhoField._(this._bytes) : assert(_bytes.length==4);
  ///
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