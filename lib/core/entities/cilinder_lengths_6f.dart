///
class CilinderLengths6f {
  final double cilinder1;
  final double cilinder2;
  final double cilinder3;
  final double cilinder4;
  final double cilinder5;
  final double cilinder6;
  ///
  const CilinderLengths6f({
    this.cilinder1 = 0.0,
    this.cilinder2 = 0.0,
    this.cilinder3 = 0.0,
    this.cilinder4 = 0.0,
    this.cilinder5 = 0.0,
    this.cilinder6 = 0.0,
  });
  ///
  CilinderLengths6f addValue(num value) => CilinderLengths6f(
    cilinder1: cilinder1+value,
    cilinder2: cilinder2+value,
    cilinder3: cilinder3+value,
    cilinder4: cilinder4+value,
    cilinder5: cilinder5+value,
    cilinder6: cilinder6+value,
  );
  ///
  CilinderLengths6f addLengths(CilinderLengths6f lengths) => CilinderLengths6f(
    cilinder1: cilinder1+lengths.cilinder1,
    cilinder2: cilinder2+lengths.cilinder2,
    cilinder3: cilinder3+lengths.cilinder3,
    cilinder4: cilinder4+lengths.cilinder4,
    cilinder5: cilinder5+lengths.cilinder5,
    cilinder6: cilinder6+lengths.cilinder6,
  );
}