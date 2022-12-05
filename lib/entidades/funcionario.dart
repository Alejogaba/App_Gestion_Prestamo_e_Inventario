class Funcionario {
  String cedula;
  String? apellidos;
  String nombres;
  String? correo;
  String urlImagen;
  String telefono1;
  String? telefono2;
  String enlaceSIGEP;
  int idArea = 0;


  Funcionario(
    this.cedula,
    this.nombres,
    this.apellidos,
    this.urlImagen,
    this.correo,
    this.telefono1,
    this.telefono2,
    this.idArea,
    this.enlaceSIGEP,
  );

  factory Funcionario.fromMap(Map<String, dynamic> map) {
    return Funcionario(
      map['CEDULA'] ?? '',
      map['NOMBRES'] ?? '',
      map['APELLIDOS'] ?? '',
      map['URL_IMAGEN'] ?? '',
      map['CORREO'] ?? '',
      map['TELEFONO_1'] ?? '',
      map['TELEFONO_2'] ?? '',
      map['ID_AREA'] ?? 0,
      map['ENLACE_SIGEP'] ?? '',
    );
  }
}
