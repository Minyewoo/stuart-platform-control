///
extension Bytes on int {
  ///
  Iterable<int> get uInt8Bytes => [
    this & 0x000000FF,
  ];
  ///
  Iterable<int> get uInt16Bytes => [
    this & 0x0000FF00,
    this & 0x000000FF,
  ];
  ///
  Iterable<int> get uInt32Bytes => [
    this & 0xFF000000,
    this & 0x00FF0000,
    this & 0x0000FF00,
    this & 0x000000FF,
  ];
}