class Activo {
  String numSerial;
  int? numActivo;
  String? nombre;
  String? urlImagen;
  int? estado;
  String? categoria;

  Activo(this.numSerial, this.numActivo, this.nombre, this.urlImagen,this.estado, this.categoria);

  factory Activo.fromMap(Map<String, dynamic> map) {
    return Activo(
      map['ID_SERIAL'] ?? '',
      map['NUM_ACTIVO'] ?? '',
      map['NOMBRE'] ?? '',
      map['URL_IMAGEN'] ?? '',
      map['ESTADO']?? '',
      map['NOMBRE_CATEGORIA']?? ''
    );
  }
}
