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
  factory NetAddress.fromMap(Map<String, dynamic> map) {
    return NetAddress(
      ipv4: map['ip'],
      port: map['port'],
    );
  }
}