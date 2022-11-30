class EstadoActivo {
  int? id;
  String? descripcion;
 

  EstadoActivo(this.id,this.descripcion);

  factory EstadoActivo.fromMap(Map<String, dynamic> map) {
    return EstadoActivo(
      map['ID'] ?? '',
      map['DESCRIPCION'] ?? '',
    );
  }
}
