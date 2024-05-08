///
abstract interface class Mapping<I, O> {
  const factory Mapping.generic(O Function(I) mappingFunction) = _GenericMapping<I,O>;
  ///
  O of(I x);
}
///
class _GenericMapping<I, O> implements Mapping<I, O> {
  final O Function(I) _mappingFunction;
  ///
  const _GenericMapping(O Function(I) mappingFunction) : 
    _mappingFunction = mappingFunction;
  //
  @override
  O of(I x) => _mappingFunction(x);
}