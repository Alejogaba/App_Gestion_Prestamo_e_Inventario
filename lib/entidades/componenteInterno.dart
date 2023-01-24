import 'package:flutter/material.dart';

class ComponenteInterno {
  int id;
  String idEquipoComputo;
  String urlImagen;
  String titulo;
  String nombre;
  String marca;
  String velocidad;
  String otrasCaracteristicas;
  TextEditingController nombreTextEditingController = TextEditingController();
  final TextEditingController marcaTextEditingController =
      TextEditingController();
  final TextEditingController velocidadTextEditingController =
      TextEditingController();
  final TextEditingController otrasCaracteristicasTextEditingController =
      TextEditingController();
  FocusNode nombreFocus = FocusNode();
  FocusNode marcaFocus = FocusNode();
  FocusNode velocidadFocus = FocusNode();
  FocusNode otrasCaracteristicasFocus = FocusNode();

  ComponenteInterno(
      {this.id=0,
        this.idEquipoComputo='',
        this.urlImagen =
          'https://cdn-icons-png.flaticon.com/512/2124/2124086.png',
      this.titulo = 'Otro',
      this.nombre = '',
      this.marca = '',
      this.velocidad = '',
      this.otrasCaracteristicas = ''});

  factory ComponenteInterno.fromMap(Map<String, dynamic> map) {
    return ComponenteInterno(
      id: map['ID'] ?? 0,
      idEquipoComputo: map['ID_EQUIPO_COMPUTO'] ?? '',
      urlImagen: map['URL_IMAGEN'] ?? '',
      nombre: map['NOMBRE'] ?? '',
      marca: map['MARCA'] ?? '',
      velocidad: map['VELOCIDAD'] ?? '',
      otrasCaracteristicas: map['OTRAS_CARACTERISTICAS'] ?? '',
    );
  }
}
