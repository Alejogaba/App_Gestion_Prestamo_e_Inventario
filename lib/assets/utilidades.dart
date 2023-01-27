import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';

import '../flutter_flow/flutter_flow_theme.dart';

class Utilidades {
  String mayusculaPrimeraLetra(String value) {
    value = value.trim().toLowerCase();
    var result = value[0].toUpperCase();
    bool cap = true;
    for (int i = 1; i < value.length; i++) {
      if (value[i - 1] == " " && cap == true) {
        result = result + value[i].toUpperCase();
      } else {
        result = result + value[i];
        cap = false;
      }
    }
    return result;
  }

  mensajeAdvertencia(BuildContext context,{String msj = 'No disponible aún: Función en desarrollo' }) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              msj,
              style: FlutterFlowTheme.of(context).bodyText2.override(
                    fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    useGoogleFonts: GoogleFonts.asMap().containsKey(
                        FlutterFlowTheme.of(context).bodyText2Family),
                  ),
            ),
            backgroundColor: Colors.yellow,
          ));
  }

  String mayusculaTodasPrimerasLetras(String value) {
    value = value.trim().toLowerCase();
    var result = value[0].toUpperCase();
    for (int i = 1; i < value.length; i++) {
      if (value[i - 1] == " ") {
        result = result + value[i].toUpperCase();
      } else {
        result = result + value[i];
      }
    }
    return result;
  }

  String mayusculaPrimeraLetraFrase(String value) {
    value = value.trim().toLowerCase();
    var result = value[0].toUpperCase();
    bool caps = false;
    bool start = true;

    for (int i = 1; i < value.length; i++) {
      if (start == true) {
        if (value[i - 1] == " " && value[i] != " ") {
          result = result + value[i].toUpperCase();
          start = false;
        } else {
          result = result + value[i];
        }
      } else {
        if (value[i - 1] == " " && caps == true) {
          result = result + value[i].toUpperCase();
          caps = false;
        } else {
          if (caps && value[i] != " ") {
            result = result + value[i].toUpperCase();
            caps = false;
          } else {
            result = result + value[i];
          }
        }

        if (value[i] == ".") {
          caps = true;
        }
      }
    }
    return result;
  }

  Color defColorCalendario(BuildContext context, String text) {
    if (text.contains('Programado')) {
      return const Color.fromARGB(255, 6, 113, 122);
    } else if (text.contains('Debia')) {
      return Colors.red;
    } else {
      return FlutterFlowTheme.of(context).grayicon;
    }
  }

  static String definirDias(DateTime inicio, DateTime fin) {
    DateTimeRange rango;
    bool progamadoaFuturo = false;
    bool atrasado = false;
    DateTime now = DateTime.now();
    int duracion;
    if (inicio.isAfter(now)) {
      progamadoaFuturo = true;
    } else if (fin.isBefore(now)) {
      atrasado = true;
    }
    if (progamadoaFuturo) {
      rango = DateTimeRange(start: now, end: inicio);
      duracion = rango.duration.inDays;
      if (duracion < 8) {
        switch (duracion) {
          case 1:
            return 'Programado para mañana';
          case 2:
            return 'programado para pasado manñana';
          default:
            return 'Progamado para el ${definirDiaSemana(inicio.weekday)}';
        }
      } else {
        return 'Progamado para dentro de $duracion días';
      }
    } else if (atrasado) {
      rango = DateTimeRange(start: fin, end: now);
      duracion = rango.duration.inDays;
      if (duracion < 7) {
        switch (duracion) {
          case 0:
            return 'Debe entregarse hoy';
          case 1:
            return 'Debia entregarse ayer';
          case 2:
            return 'Debia entregarse antier';
          default:
            return 'Debia entregarse el ${definirDiaSemana(fin.weekday)}';
        }
      } else if (duracion < 14) {
        return 'Debia entregarse la semana pasada';
      } else {
        return 'Debia entregarse hace $duracion días';
      }
    } else {
      rango = DateTimeRange(start: now, end: fin);
      duracion = rango.duration.inDays+1;
      if (duracion < 8) {
        switch (duracion) {
          case 0:
            return 'Para entregar hoy';
          case 1:
            return 'Para entregar mañana';
          case 2:
            return 'Para entregar pasado mañana';
          default:
            return 'Para entregar el ${definirDiaSemana(fin.weekday)}';
        }
      } else {
        return 'Para entregar dentro de $duracion días';
      }
    }
  }

  static String definirDiaSemana(int numeroSemana) {
    switch (numeroSemana) {
      case 1:
        return "Lunes";
        break;
      case 2:
        return "Martes";
        break;
      case 3:
        return "Miercoles";
      case 4:
        return "Jueves";
        break;
      case 5:
        return "Viernes";
        break;
      case 6:
        return "Sábado";
        break;
      case 7:
        return "Domingo";
        break;
      default:
        return "Indefinido";
    }
  }

  static String definirMes(int numMes) {
    switch (numMes) {
      case 1:
        return "Enero";
        break;
      case 2:
        return "Febrero";
        break;
      case 3:
        return "Marzo";
      case 4:
        return "Abril";
        break;
      case 5:
        return "Mayo";
        break;
      case 6:
        return "Junio";
        break;
      case 7:
        return "Julio";
        break;
      case 8:
        return "Agosto";
        break;
      case 9:
        return "Septiembre";
        break;
      case 10:
        return "Octubre";
        break;
      case 11:
        return "Noviembre";
        break;
      case 12:
        return "Diciembre";
        break;
      default:
        return "Indefinido";
    }
  }

  validarErroresInsertar(String codigo,String obejetoaGuardar, {String objetoLlaveForaneo='el item a asignar',String error=''}) {
    switch (codigo) {
      case '42P01':
        Logger().e('Error: la tabla no existe');
        return 'Error: La tabla no existe';
      case '42P02':
        Logger().e('Error: Error en uno o más parametros a guardar');
        return 'Error: Error en uno o más parametros a guardar';
      case '23505':
        Logger().e('Error: $obejetoaGuardar ya existe en la base de datos');
        return 'Error: $obejetoaGuardar ya existe en la base de datos';
      case '23503':
        Logger().e('Error: No existe $objetoLlaveForaneo');
        return 'Error: No existe $objetoLlaveForaneo';
      case '23502':
        Logger().e('Error: No se debe dejar el número de identificación vacio');
        return 'Error: No se debe dejar el número de identificación vacio';
      case '22000':
        Logger().e('Error: Hay uno o varios campos vacios sin rellenar');
        return 'Error: Hay uno o más campos vacios';
      case '2D000':
        Logger().e('Error: Ocurrio un error a mitad de la operación');
        return 'Error: Ocurrio un error a mitad de la operación';
      
      default:
        Logger().e('Error desconocido: Código $codigo');
        Logger().e('Error desconocido: Código $codigo');
        return 'Error desconocido: Código $codigo';
    }
  }

  validarErroresEliminar(String codigo,String obejetoaEliminar, {String objetoLlaveForaneo='otros items asignados',String error=''}) {
    switch (codigo) {
      case '42P01':
        Logger().e('Error: la tabla no existe');
        return 'Error: La tabla no existe';
      case '42P02':
        Logger().e('Error: Error en uno o más parametros');
        return 'Error: Error en uno o más parametros';
      case '23503':
        Logger().e('Error: no se puede eliminar $obejetoaEliminar porque tiene $objetoLlaveForaneo');
        return 'Error: No se puede eliminar $obejetoaEliminar porque tiene $objetoLlaveForaneo';
      case '23502':
        Logger().e('Error: No se debe dejar el campos vacios');
        return 'Error: No se debe dejar campos vacios';
      case '22000':
        Logger().e('Error: Hay uno o más campos vacios');
        return 'Error: Hay uno o más campos vacios';
      case '2D000':
        Logger().e('Error: Ocurrio un error a mitad de la operación');
        return 'Error: Ocurrio un error a mitad de la operación';
      
      default:
        Logger().e('Error: $error \n\n Error desconocido: Código $codigo');
        return 'Error desconocido: Código $codigo';
    }
  }

  validarErrorStorage(String codigo,String obejetoaGuardar, {String objetoLlaveForaneo='el item a asignar'}) {
    switch (codigo) {
      case '42P01':
        Logger().e('Error: la tabla no existe');
        return 'Error: La tabla no existe';
      case '42P02':
        Logger().e('Error: Error en uno o más parametros a guardar');
        return 'Error: Error en uno o más parametros a guardar';
      case '23505':
        Logger().e('Error: $obejetoaGuardar ya existe en la base de datos');
        return 'Error: $obejetoaGuardar ya existe en la base de datos';
      case '23503':
        Logger().e('Error: No existe $objetoLlaveForaneo');
        return 'Error: No existe $objetoLlaveForaneo';
      case '23502':
        Logger().e('Error: No se debe dejar el número de identificación vacio');
        return 'Error: No se debe dejar el número de identificación vacio';
      case '22000':
        Logger().e('Error: Hay uno o varios campos vacios sin rellenar');
        return 'Error: Hay uno o más campos vacios';
      case '2D000':
        Logger().e('Error: Ocurrio un error a mitad de la operación');
        return 'Error: Ocurrio un error a mitad de la operación';
      
      default:
        Logger().e('Error desconocido: Código $codigo');
        return 'Error desconocido: Código $codigo';
    }
  }
}
