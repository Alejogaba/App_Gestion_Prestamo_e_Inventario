class Activo {
  String idSerial;
  String? numActivo;
  String nombre;
  String? detalles;
  String urlImagen;
  int estado = 0;
  String categoria;
  int cantidad = 1;
  String? capacidad;

  Activo(
    this.idSerial,
    this.numActivo,
    this.nombre,
    this.detalles,
    this.urlImagen,
    this.estado,
    this.categoria,
    this.cantidad,
    this.capacidad,
  );

  factory Activo.fromMap(Map<String, dynamic> map) {
    return Activo(
      map['ID_SERIAL'] ?? '',
      map['NUM_ACTIVO'] ?? '',
      map['NOMBRE'] ?? '',
      map['DETALLES'] ?? '',
      map['URL_IMAGEN'] ?? '',
      map['ESTADO'] ?? 0,
      map['NOMBRE_CATEGORIA'] ?? '',
      map['CANTIDAD'] ?? '',
      map['CAPACIDAD'] ?? '',
    );
  }
}
