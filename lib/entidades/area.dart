import 'dart:convert';

class Area {
  int id;
  String nombre;
  String urlImagen;

  Area({
    this.id = 1,
    this.nombre = '',
    this.urlImagen = '',
  });

  factory Area.fromMap(Map<String, dynamic> map) {
    return Area(
      id: map['ID'] ?? 1,
      nombre: map['NOMBRE'] ?? '',
      urlImagen: map['URL_IMAGEN'] ?? '',
    );
  }

  static decodificarString(String placeStr) {
  final serializedData = jsonDecode(placeStr) as Map<String, dynamic>;
  final data = {
    'id': serializedData['id'] ?? 1,
      'nombre': serializedData['nombre'] ?? '',
      'urlImagen': serializedData['urlImagen'] ?? '',
  };
  return Area(
      id: data['id'] as int,
      nombre: data['nombre'] as String,
      urlImagen: data['urlImagen']  as String,
  );
}

static String encodeToString(Area item) => jsonEncode({
      'id': item.id,
      'nombre': item.nombre,
      'urlImagen': item.urlImagen,
    });

}

