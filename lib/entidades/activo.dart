import 'dart:convert';
import 'dart:developer';

class Activo {
  String idSerial;
  String? numActivo;
  String nombre;
  String? detalles;
  String urlImagen;
  int estado;
  int idCategoria;
  String categoria;
  int cantidad;
  String? capacidad;
  bool estaAsignado;
  bool estaPrestado;

  Activo(
      {this.idSerial = '',
      this.numActivo,
      this.nombre = '',
      this.detalles,
      this.urlImagen = '',
      this.estado = 0,
      this.idCategoria = 0,
      this.categoria = '',
      this.cantidad = 1,
      this.capacidad,
      this.estaAsignado = false,
      this.estaPrestado = false});

  factory Activo.fromMap(Map<String, dynamic> map) {
    return Activo(
      idSerial: map['ID_SERIAL'] ?? '',
      numActivo: map['NUM_ACTIVO'],
      nombre: map['NOMBRE'] ?? '',
      detalles: map['DETALLES'],
      urlImagen: map['URL_IMAGEN'],
      estado: map['ESTADO'] ?? 0,
      idCategoria: map['ID_CATEGORIA'],
      categoria: map['NOMBRE_CATEGORIA'],
      cantidad: map['CANTIDAD'] ?? 0,
      capacidad: map['CAPACIDAD'],
      estaAsignado: map['ESTA_ASIGNADO'] ?? false,
      estaPrestado: map['ESTA_PRESTADO'] ?? false,
    );
  }

  static String encodeToString(Activo item) => jsonEncode({
        'idSerial': item.idSerial,
        'numActivo': item.numActivo,
        'nombre': item.nombre,
        'detalles': item.detalles,
        'urlImagen': item.urlImagen,
        'estado': item.estado,
        'idCategoria': item.idCategoria,
        'nombreCategoria': item.categoria,
        'cantidad': item.cantidad,
        'capacidad': item.capacidad,
        'estaAsignado': item.estaAsignado
      });

  static decodificarString(String placeStr) {
    final serializedData = jsonDecode(placeStr) as Map<String, dynamic>;
    final data = {
      'idSerial': serializedData['idSerial'] ?? '',
      'numActivo': serializedData['numActivo'] ?? '',
      'nombre': serializedData['nombre'] ?? '',
      'detalles': serializedData['detalles'] ?? '',
      'urlImagen': serializedData['urlImagen'] ?? '',
      'estado': serializedData['estado'] ?? '',
      'idCategoria': serializedData['idCategoria'] ?? '',
      'categoria': serializedData['categoria'] ?? 0,
      'cantidad': serializedData['cantidad'] ?? '',
      'capacidad': serializedData['capacidad'] ?? '',
      'estaAsignado': serializedData['estaAsignado'] ?? false
    };
    return Activo(
      idSerial: data['idSerial'] as String,
      numActivo: data['numActivo'] as String,
      nombre: data['nombre'] as String,
      detalles: data['detalles'] as String,
      urlImagen: data['urlImagen'] as String,
      estado: data['estado'] as int,
      idCategoria: data['idCategoria'] as int,
      categoria: data['categoria'] as String,
      cantidad: data['cantidad'] as int,
      capacidad: data['capacidad'] as String,
      estaAsignado: data['estaAsignado'] as bool,
    );
  }
}
