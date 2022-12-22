import 'dart:async';
import 'dart:developer';
import 'package:app_gestion_prestamo_inventario/assets/utilidades.dart';
import 'package:app_gestion_prestamo_inventario/entidades/activo_funcionario.dart';
import 'package:app_gestion_prestamo_inventario/entidades/activo.dart';
import 'package:app_gestion_prestamo_inventario/entidades/area.dart';
import 'package:app_gestion_prestamo_inventario/entidades/funcionario.dart';
import 'package:app_gestion_prestamo_inventario/entidades/prestamo.dart';
import 'package:app_gestion_prestamo_inventario/servicios/storageController.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
//import 'package:sqflite/sqflite.dart';
// ignore: implementation_imports
import 'package:supabase/src/supabase_stream_builder.dart';
import 'package:supabase/supabase.dart';
import '../../assets/constantes.dart' as constantes;
import '../flutter_flow/flutter_flow_theme.dart';

class PrestamosController {
  Utilidades utilidades = Utilidades();
  final supabase =
      SupabaseClient(constantes.SUPABASE_URL, constantes.SUPABASE_ANNON_KEY);

  Future<String> registrarPrestamo(
      context, String idActivo, String idFuncionario, String? fechaHoraInicio,
      {bool entregado = false,
      String? observacion,
      String? fechaHoraFinal}) async {
    try {
      await supabase.from('PRESTAMOS').insert({
        'ID_FUNCIONARIO': idFuncionario,
        'ID_ACTIVO': idActivo,
        'FECHA_HORA_INICIO': (fechaHoraInicio==null) ? DateTime.now().toString() : fechaHoraInicio,
        'ENTREGADO': entregado,
        'OBSERVACION': (observacion == null)
            ? null
            : utilidades.mayusculaPrimeraLetraFrase(observacion),
        'FECHA_HORA_FINAL':
            (fechaHoraFinal == null) ? DateTime.now().add(const Duration(days: 1)).toString() : fechaHoraFinal.toString(),
      }).then((value) async {
        log('Nuevo activo prestado: $value');
        await supabase
            .from('ACTIVOS')
            .update({'ESTA_PRESTADO': true}).match({'ID_SERIAL': idActivo});
      });
      log("Prestado con exito");
    
      return 'ok';
    } on Exception catch (error) {
      StorageController storageController = StorageController();
      var errorTraducido = await storageController.traducir(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          errorTraducido,
          style: FlutterFlowTheme.of(context).bodyText2.override(
                fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                color: FlutterFlowTheme.of(context).tertiaryColor,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).bodyText2Family),
              ),
        ),
        backgroundColor: Colors.redAccent,
      ));
      log(error.toString());
      return 'error';
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Ha ocurrido un error',
          style: FlutterFlowTheme.of(context).bodyText2.override(
                fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                color: FlutterFlowTheme.of(context).tertiaryColor,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).bodyText2Family),
              ),
        ),
        backgroundColor: Colors.redAccent,
      ));
      log(e.toString());
      return 'error';
    }
  }

  Future<List<Prestamo>> getActivosPrestados({String? idFuncionario, String? idActivo}) async {
    try {
      if (idFuncionario != null) {
        final data = await supabase
          .from('PRESTAMOS')
          .select('*')
          .eq('ID_FUNCIONARIO', idFuncionario) as List<dynamic>;
      return (data).map((e) => Prestamo.fromMap(e)).toList();
      } else if(idActivo != null) {
        final data = await supabase
          .from('PRESTAMOS')
          .select('*')
          .eq('ID_ACTIVO', idActivo) as List<dynamic>;
      return (data).map((e) => Prestamo.fromMap(e)).toList();
      }else{
        final data = await supabase
          .from('PRESTAMOS')
          .select('*') as List<dynamic>;
      return (data).map((e) => Prestamo.fromMap(e)).toList();
      }
      
    } on PostgrestException catch (error) {
      Logger().e(error.message);
      return [];
    } catch (error) {
      Logger().e('Error al cargar ACTIVOS ASIGNADOS: $error');
      return [];
    }
  }
}
