import 'dart:convert';

class Categoria {
  String? urlImagen;
  String? nombre;
 

  Categoria(this.nombre, this.urlImagen);

  factory Categoria.fromMap(Map<String, dynamic> map) {
    return Categoria(
      map['NOMBRE'] ?? '',
      map['URL_IMAGEN'] ?? '',
    );
  }

   factory Categoria.fromJson(Map<String, dynamic> jsonData) {
    return Categoria(
      jsonData['nombre'],
      jsonData['urlImagen'],
    );
    }

    static Map<String, dynamic> toMap(Categoria categoria) => {
        'nombre': categoria.nombre,
        'urlImagen': categoria.urlImagen,
      };

    static List<Categoria> decode(String categorias) =>
      (json.decode(categorias) as List<dynamic>)
          .map<Categoria>((item) => Categoria.fromJson(item))
          .toList();
}
