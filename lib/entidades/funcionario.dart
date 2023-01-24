import 'dart:convert';
import 'dart:developer';

class Funcionario{
  String cedula;
  String apellidos;
  String nombres;
  String cargo;
  String? correo;
  String urlImagen;
  String telefono1;
  String? telefono2;
  String? enlaceSIGEP;
  int idArea = 0;
  bool tieneActivos;

  Funcionario(
      {this.cedula = '',
      this.nombres = '',
      this.apellidos='',
      this.cargo = '',
      this.urlImagen = '',
      this.correo,
      this.telefono1 = '',
      this.telefono2,
      this.idArea = 0,
      this.enlaceSIGEP = '',
      required this.tieneActivos});

  factory Funcionario.fromMap(Map<String, dynamic> map) {
    return Funcionario(
      cedula: map['CEDULA'] ?? '',
      nombres: map['NOMBRES'] ?? '',
      apellidos: map['APELLIDOS'] ?? '',
      urlImagen: map['URL_IMAGEN'] ?? '',
      correo: map['CORREO'] ?? '',
      telefono1: map['TELEFONO_1'] ?? '',
      telefono2: map['TELEFONO_2'] ?? '',
      idArea: map['ID_AREA'] ?? 0,
      enlaceSIGEP: map['ENLACE_SIGEP'] ?? '',
      cargo: map['CARGO'] ?? '',
      tieneActivos: map['TIENE_ACTIVOS'],
    );
  }

  static bool parseBool(String text) {
    log(text);
    return text.toLowerCase().trim() == 'true';
  }

  static decodificarString(String placeStr) {
    final serializedData = jsonDecode(placeStr) as Map<String, dynamic>;
    final data = {
      'cedula': serializedData['cedula'] ?? '',
      'nombres': serializedData['nombres'] ?? '',
      'apellidos': serializedData['apellidos'] ?? '',
      'urlImagen': serializedData['urlImagen'] ?? '',
      'correo': serializedData['correo'] ?? '',
      'telefono1': serializedData['telefono1'] ?? '',
      'telefono2': serializedData['telefono2'] ?? '',
      'idArea': serializedData['idArea'] ?? 0,
      'enlaceSIGEP': serializedData['enlaceSIGEP'] ?? '',
      'cargo': serializedData['cargo'] ?? '',
      'tieneActivos' :serializedData['tieneActivos']
    };
    return Funcionario(
      cedula: data['cedula'] as String,
      nombres: data['nombres'] as String,
      apellidos: data['apellidos'] as String,
      urlImagen: data['urlImagen'] as String,
      correo: data['correo'] as String,
      telefono1: data['telefono1'] as String,
      telefono2: data['telefono2'] as String,
      idArea: data['idArea'] as int,
      enlaceSIGEP: data['enlaceSIGEP'] as String,
      cargo: data['cargo'] as String,
      tieneActivos: data['tieneActivos'] as bool,
    );
  }

  static String encodeToString(Funcionario item) => jsonEncode({
        'cedula': item.cedula,
        'nombres': item.nombres,
        'apellidos': item.apellidos,
        'urlImagen': item.urlImagen,
        'correo': item.correo,
        'telefono1': item.telefono1,
        'telefono2': item.telefono2,
        'idArea': item.idArea,
        'enlaceSIGEP': item.enlaceSIGEP,
        'cargo': item.cargo,
        'tieneActivos': item.tieneActivos,
      });
}
