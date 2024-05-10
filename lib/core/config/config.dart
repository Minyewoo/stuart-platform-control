import 'package:stewart_platform_control/core/math/min_max.dart';
import 'package:stewart_platform_control/core/net_address.dart';
///
class Config {
  final NetAddress myAddress;
  final NetAddress controllerAddress;
  final double cilinderMaxHeight;
  final MinMax amplitudeConstraints;
  final MinMax periodConstraints;
  final MinMax phaseShiftConstraints;
  final Duration controlFrequency;
  ///
  const Config({
    this.myAddress = const NetAddress(
      ipv4: '192.168.15.101',
      port:8410,
    ),
    this.controllerAddress = const NetAddress(
      ipv4: '192.168.15.201',
      port: 7408,
    ),
    this.cilinderMaxHeight = 0.900,
    this.amplitudeConstraints = const MinMax(min: 0, max: 300),
    this.periodConstraints = const MinMax(min: 1, max: 15),
    this.phaseShiftConstraints = const MinMax(min: 0, max: 180),
    this.controlFrequency = const Duration(milliseconds: 100),
  });
  ///
  factory Config.fromMap(Map<String, dynamic> map) {
    final jsonFrequency =  map['controlFrequency'];
    final frequency = Duration(
      milliseconds: jsonFrequency['milliseconds']
    );
    return Config(
      myAddress: NetAddress.fromMap(map['me']),
      controllerAddress: NetAddress.fromMap(map['controller']),
      cilinderMaxHeight: double.parse('${map['cilinderMaxHeight']}'),
      amplitudeConstraints: MinMax.fromMap(map['amplitudeConstraints']),
      periodConstraints: MinMax.fromMap(map['periodConstraints']),
      phaseShiftConstraints: MinMax.fromMap(map['phaseShiftConstraints']),
      controlFrequency: frequency,
    );
  }
}