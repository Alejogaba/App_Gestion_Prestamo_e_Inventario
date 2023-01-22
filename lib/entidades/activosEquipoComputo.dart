import 'activo.dart';

class ActivosEquipoComputo extends Activo {
  final String? placaMadre;
  final String? tipoEquipo;
  final String? equipoPropio;
  final String? fechaAdquisicion;
  final String? tiempoGarantia;
  final String? fechaVencimiento;

  ActivosEquipoComputo(
      {required String idSerial,
      String? numActivo,
      required String nombre,
      String? detalles,
      required String urlImagen,
      required int estado,
      required int idCategoria,
      required String categoria,
      required int cantidad,
      String? capacidad,
      this.placaMadre,
      this.tipoEquipo,
      this.equipoPropio,
      this.fechaAdquisicion,
      this.tiempoGarantia,
      this.fechaVencimiento,
      bool? estaAsignado})
      : super();
  factory ActivosEquipoComputo.fromMap(Map<String, dynamic> map) {
    return ActivosEquipoComputo(
      idSerial: map['ID_SERIAL'] ?? '',
      numActivo: map['NUM_ACTIVO'] ?? '',
      nombre: map['NOMBRE'] ?? '',
      detalles: map['DETALLES'] ?? '',
      urlImagen: map['URL_IMAGEN'] ?? '',
      estado: map['ESTADO'] ?? 0,
      idCategoria: map['ID_CATEGORIA'],
      categoria: map['NOMBRE_CATEGORIA'] ?? '',
      cantidad: map['CANTIDAD'] ?? 0,
      capacidad: map['CAPACIDAD'] ?? '',
      placaMadre: map['PLACA_MADRE'] ?? '',
      tipoEquipo: map['TIPO_EQUIPO'] ?? '',
      equipoPropio: map['EQUIPO_PROPIO'] ?? '',
      fechaAdquisicion: map['FECHA_ADQUISICION'] ?? '',
      tiempoGarantia: map['TIEMPO_GARANTIA'] ?? '',
      fechaVencimiento: map['FECHA_VENCIMIENTO'] ?? '',
      estaAsignado: map['ESTA_ASIGNADO'] ?? false,
    );
  }
}
