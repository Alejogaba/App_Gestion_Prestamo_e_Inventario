class Software {
   String id;
  String idEquipoComputo;
  String idFuncionario;
  String nombreSoftware;
  String version;
  String tipoLicencia;
  String claveActivacion;

  Software({
    this.id = '',
    this.idEquipoComputo = '',
    this.idFuncionario = '',
    this.nombreSoftware = '',
    this.version = '',
    this.tipoLicencia = '',
    this.claveActivacion = '',
  });

  factory Software.fromMap(Map<String, dynamic> map) {
    return Software(
      id: map['ID'] ?? '',
      idEquipoComputo: map['ID_EQUIPO_COMPUTO'] ?? '',
      idFuncionario: map['ID_FUNCIONARIO'] ?? '',
      nombreSoftware: map['NOMBRE_SOFTWARE'] ?? '',
      version: map['VERSION'] ?? '',
      tipoLicencia: map['TIPO_LICENCIA'] ?? '',
      claveActivacion: map['CLAVE_ACTIVACION'] ?? '',
    );
  }
}