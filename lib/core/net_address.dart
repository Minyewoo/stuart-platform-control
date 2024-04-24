///
class NetAddress {
  final String ipv4;
  final int port;
  ///
  const NetAddress({
    required this.ipv4,
    required this.port,
  });
  ///
  const NetAddress.localhost(int port) : this(
    ipv4: '127.0.0.1',
    port: port,
  );
}