class ActivoFuncionario {
  String idSerial;
  String idFuncionaro;
  String? nombre;

  ActivoFuncionario(this.idSerial, this.idFuncionaro,{this.nombre});

  factory ActivoFuncionario.fromMap(Map<String, dynamic> map) {
    return ActivoFuncionario(
      map['ID_SERIAL'] ?? '',
      map['ID_FUNCIONARIO'] ?? '',
      nombre: map['NOMBRE'] ?? '',
    );
  }
}
