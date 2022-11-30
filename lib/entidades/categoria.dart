class Categoria {
  String? urlImagen;
  String? nombre;
 int? idCategoria;

  Categoria(this.nombre, this.urlImagen,[this.idCategoria]);

  factory Categoria.fromMap(Map<String, dynamic> map) {
    return Categoria(
      map['NOMBRE'] ?? '',
      map['URL_IMAGEN'] ?? '',
      map['ID_CATEGORIA'] ?? '',
    );
  }
}
