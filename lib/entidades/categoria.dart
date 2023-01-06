import 'dart:convert';

class Categoria {
  int id;
  String? urlImagen;
  String? nombre;
  String? descripcion;

  Categoria(this.nombre, this.urlImagen, this.descripcion,{this.id=0});

  factory Categoria.fromMap(Map<String, dynamic> map) {
    return Categoria(
      map['NOMBRE'] ?? '',
      map['URL_IMAGEN'] ?? '',
      map['DESCRIPCION'] ?? '',
      id:map['ID']??0,
    );
  }

  factory Categoria.fromJson(Map<String, dynamic> jsonData) {
    return Categoria(
      jsonData['nombre'],
      jsonData['urlImagen'],
      jsonData['descripcion'],
      id:jsonData['id']??0,
    );
  }

  static Map<String, dynamic> toMap(Categoria categoria) => {
    'id': categoria.id,
        'nombre': categoria.nombre,
        'urlImagen': categoria.urlImagen,
        'descripcion': categoria.urlImagen,
      };

  static List<Categoria> decode(String categorias) =>
      (json.decode(categorias) as List<dynamic>)
          .map<Categoria>((item) => Categoria.fromJson(item))
          .toList();
}
