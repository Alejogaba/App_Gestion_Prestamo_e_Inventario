import 'dart:convert';

class HojaSalida {
  int id;
  String descripcion;
 
  HojaSalida({
    this.id = 1,
    this.descripcion = '',

  });

  factory HojaSalida.fromMap(Map<String, dynamic> map) {
    return HojaSalida(
      id: map['consecutivo'] ?? 1,
      descripcion: map['descripcion'] ?? '',
    );
  }

  static decodificarString(String placeStr) {
    final serializedData = jsonDecode(placeStr) as Map<String, dynamic>;
    final data = {
      'id': serializedData['id'] ?? 1,
      'descripcion': serializedData['nombre'] ?? '',
    };
    return HojaSalida(
      id: data['id'] as int,
      descripcion: data['nombre'] as String,

    );
  }

  static String encodeToString(HojaSalida item) => jsonEncode({
        'id': item.id,
        'descripcion': item.descripcion,
      });
}
