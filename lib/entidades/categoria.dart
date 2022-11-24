class Categoria {
  String? urlImagen;
  String? nombre;

  Categoria(this.nombre, this.urlImagen);

  factory Categoria.fromMap(Map<String, dynamic> map) {
    return Categoria(
      map['NOMBRE']??'',
      map['URL_IMAGEN'] ?? '',
    );
  }
}
