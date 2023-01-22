import '../entidades/activo.dart';

class Activo_Impresora extends Activo {
  Activo_Impresora(
    String idSerial,
    numActivo,
    nombre,
    detalles,
    urlImagen,
    estado,
    idCategoria,  
    categoria,
    cantidad,
    capacidad,
  ) : super(
        );

  factory Activo_Impresora.fromMap(Map<String, dynamic> map) {
    return Activo_Impresora(
      map['ID_SERIAL'] ?? '',
      map['NUM_ACTIVO'] ?? '',
      map['NOMBRE'] ?? '',
      map['DETALLES'] ?? '',
      map['URL_IMAGEN'] ?? '',
      map['ESTADO'] ?? 0,
      map['ID_CATEGORIA'],
      map['NOMBRE_CATEGORIA'] ?? '',
      map['CANTIDAD'] ?? '',
      map['CAPACIDAD'] ?? '',
    );
  }
}
