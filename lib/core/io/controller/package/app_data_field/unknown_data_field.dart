import 'package:stewart_platform_control/core/io/controller/package/app_data_field/app_data_field.dart';

class UnknownDataField implements AppDataField {
  final Iterable<int> _bytes;
  ///
  const UnknownDataField._(this._bytes);
  ///
  const factory UnknownDataField.fromIterable(Iterable<int> bytes) = UnknownDataField._;
  //
  @override
  Iterable<int> get bytes => _bytes;
}