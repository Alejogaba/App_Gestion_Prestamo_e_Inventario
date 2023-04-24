import 'dart:convert';

class HojaSalida {
  int id;
  String descripcion;
  String seriales;
  String funcionario;
  String fecha;

  HojaSalida(
      {this.id = 1,
      this.descripcion = '',
      this.seriales = '',
      this.funcionario = '',
      this.fecha=''});

  factory HojaSalida.fromMap(Map<String, dynamic> map) {
    return HojaSalida(
      id: map['consecutivo'] ?? 1,
      descripcion: map['descripcion'] ?? '',
      seriales: map['seriales'] ?? '',
      funcionario: map['funcionario'] ?? '',
      fecha: map['fecha'] ?? ''
    );
  }

  static decodificarString(String placeStr) {
    final serializedData = jsonDecode(placeStr) as Map<String, dynamic>;
    final data = {
      'id': serializedData['id'] ?? 1,
      'descripcion': serializedData['nombre'] ?? '',
      'seriales': serializedData['seriales'] ?? '',
      'funcionario': serializedData['funcionario'] ?? '',
      'fecha': serializedData['fecha'] ?? '',
    };
    return HojaSalida(
      id: data['id'] as int,
      descripcion: data['nombre'] as String,
      seriales: data['seriales'] as String,
      funcionario: data['funcionario'] as String,
      fecha: data['fecha'] as String,
    );
  }

  static String encodeToString(HojaSalida item) => jsonEncode({
        'id': item.id,
        'descripcion': item.descripcion,
        'seriales': item.seriales,
        'funcionario': item.funcionario,
        'fecha':item.fecha
      });
}
