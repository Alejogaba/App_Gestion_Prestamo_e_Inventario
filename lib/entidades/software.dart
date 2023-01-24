import 'package:flutter/material.dart';

class Software {
  int id;
  String urlImagen;
  String titulo;
  String idEquipoComputo;
  String nombre;
  String fabricante;
  String version;
  String tipoLicencia;
  String licenciaClave;
  String? dropdownvalue;

  TextEditingController nombreController = TextEditingController();
  FocusNode nombreFocus = FocusNode();
  TextEditingController fabricanteController = TextEditingController();
  FocusNode fabricanteFocus = FocusNode();
  TextEditingController versionController = TextEditingController();
  FocusNode versionFocus = FocusNode();
  TextEditingController tipoLicenciaController = TextEditingController();
  FocusNode tipoLicenciaFocus = FocusNode();
  TextEditingController licenciaClaveController = TextEditingController();
  FocusNode licenciaClaveFocus = FocusNode();

  Software({
    this.titulo = 'Software',
    this.urlImagen = 'https://cdn-icons-png.flaticon.com/512/2828/2828879.png',
    this.id = 0,
    this.idEquipoComputo = '',
    this.nombre = '',
    this.fabricante = '',
    this.version = '',
    this.tipoLicencia = 'Mono Usuario',
    this.licenciaClave = '',
    this.dropdownvalue='Mono Usuario'
  });

  factory Software.fromMap(Map<String, dynamic> map) {
    return Software(
      id: map['ID']?? 0,
      idEquipoComputo: map['ID_EQUIPO_COMPUTO']??'',
      nombre: map['NOMBRE']??'',
      fabricante: map['FABRICANTE']??'',
      version: map['VERSION_SOFTWARE']??'',
      tipoLicencia: map['TIPO_LICENCIA']??'',
      licenciaClave: map['LICENCIA_CLAVE']??'',
    );
  }
}
