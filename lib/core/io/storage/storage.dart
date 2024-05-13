abstract interface class Storage<T> {
  T get defaultValue;

  Future<void> store(T newValue);
  Future<T> retrieve();
}