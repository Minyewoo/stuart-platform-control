import 'package:stewart_platform_control/core/validation/validation_case.dart';
///
class ValidationCases<T> implements ValidationCase<T> {
  final Iterable<ValidationCase<T>> _cases;
  ///
  const ValidationCases({
    required Iterable<ValidationCase<T>> cases,
  }) :
    _cases = cases;
  //
  @override
  bool isSatisfiedBy(T value) => _cases.every((c) => c.isSatisfiedBy(value));
}