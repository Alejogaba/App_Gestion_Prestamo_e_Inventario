class Usuario {
  final String uid;
  int? index;
  String? urlImagen;
  String nombre;
  String apellido;
  String? profesion;


  Usuario(this.nombre, this.apellido,this.uid,[ this.profesion,
      this.index,this.urlImagen]);
}
