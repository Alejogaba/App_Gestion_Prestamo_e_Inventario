class Prestamo {
  int id;
  String idActivo;
  String idFuncionario;
  String? observacion;
  DateTime fechaHoraInicio = DateTime.now();
  DateTime? fechaHoraEntrega;
  bool entregado = false;

  Prestamo(this.id, this.idActivo, this.idFuncionario, this.fechaHoraInicio,this.entregado,
      {this.observacion, this.fechaHoraEntrega});

  factory Prestamo.fromMap(Map<String, dynamic> map) {
    return Prestamo(
      map['ID'] ?? 0,
      map['ID_ACTIVO'] ?? '',
      map['ID_FUNCIONARIO'] ?? '',
      DateTime.parse(map['FECHA_HORA_INICIO'].toString()),
      map['ENTREGADO'] ?? false,
      observacion: map['OBSERVACION'] ?? '',
      fechaHoraEntrega:DateTime.parse(map['FECHA_HORA_FINAL'].toString()),
    );
  }
}
