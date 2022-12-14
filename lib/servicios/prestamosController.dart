import 'dart:async';
import 'dart:developer';
import 'package:app_gestion_prestamo_inventario/assets/utilidades.dart';
import 'package:app_gestion_prestamo_inventario/entidades/activo_funcionario.dart';
import 'package:app_gestion_prestamo_inventario/entidades/activo.dart';
import 'package:app_gestion_prestamo_inventario/entidades/area.dart';
import 'package:app_gestion_prestamo_inventario/entidades/funcionario.dart';
import 'package:app_gestion_prestamo_inventario/entidades/hoja_salida.dart';
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
        'FECHA_HORA_INICIO': (fechaHoraInicio == null)
            ? DateTime.now().toString()
            : fechaHoraInicio,
        'ENTREGADO': entregado,
        'OBSERVACION': observacion,
        'FECHA_HORA_FINAL': (fechaHoraFinal == null)
            ? DateTime.now().toString()
            : fechaHoraFinal.toString(),
      }).then((value) async {
        log('Nuevo activo prestado: $value');
        await supabase
            .from('ACTIVOS')
            .update({'ESTA_PRESTADO': true}).match({'ID_SERIAL': idActivo});
      });
      log("Prestado con exito");

      return 'ok';
    } on PostgrestException catch (errorPostgres) {
      var error = Utilidades().validarErroresInsertar(
          errorPostgres.code!, 'Este prestamo');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          error,
          style: FlutterFlowTheme.of(context).bodyText2.override(
                fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                color: FlutterFlowTheme.of(context).tertiaryColor,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).bodyText2Family),
              ),
        ),
        backgroundColor: Colors.redAccent,
      ));
      log(errorPostgres.toString());
      return 'error';
    }catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Ha ocurrido un error, revise su conexi??n a internet',
          style: FlutterFlowTheme.of(context).bodyText2.override(
                fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                color: FlutterFlowTheme.of(context).tertiaryColor,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).bodyText2Family),
              ),
        ),
        backgroundColor: Colors.redAccent,
      ));
      Logger().e(e);
      return 'error';
    }
  }

  Future<String> registrarHojaSalida(context, String descripcion) async {
    try {
      final data = await supabase
          .from('hojas_salidas')
          .select('*')
          .order('consecutivo', ascending: false).limit(1)
          .maybeSingle() as Map<String, dynamic>;
      final HojaSalida ultimahojaSalida = HojaSalida.fromMap(data);
      final int consecutivo = ultimahojaSalida.id + 1;
      await supabase.from('hojas_salidas').insert({
        'consecutivo': consecutivo,
        'descripcion': descripcion,
      });
      log("Hoja de salida registrada con exito");
      if (consecutivo>99) {
         return 'GTI-$consecutivo';
      } else if(consecutivo>9){
         return 'GTI-0$consecutivo';
      }else{
        return 'GTI-00$consecutivo';
      }
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
      Logger().e(e);
      return 'error';
    }
  }

  Future<String> entregarPrestamo(
      context, String idFuncionario, String idActivo) async {
    try {
      final data = (await supabase
          .from('PRESTAMOS')
          .update({'ENTREGADO': true}).match({
        'ID_FUNCIONARIO': idFuncionario,
        'ID_ACTIVO': idActivo
      }).then((value) async {
        await supabase
            .from('ACTIVOS')
            .update({'ESTA_PRESTADO': false}).match({'ID_SERIAL': idActivo});
      }));
      log('Entregado:$data');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Marcado como entregado',
            style: FlutterFlowTheme.of(context).bodyText2.override(
                  fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                  color: FlutterFlowTheme.of(context).tertiaryColor,
                  useGoogleFonts: GoogleFonts.asMap().containsKey(
                      FlutterFlowTheme.of(context).bodyText2Family),
                ),
          ),
          backgroundColor: FlutterFlowTheme.of(context).primaryColor));
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
      log(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Ha ocurrido un error inesperado',
          style: FlutterFlowTheme.of(context).bodyText2.override(
                fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                color: FlutterFlowTheme.of(context).tertiaryColor,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).bodyText2Family),
              ),
        ),
        backgroundColor: Colors.redAccent,
      ));
      return 'error';
    }
  }

  Future<List<Prestamo>> getActivosPrestados(
      {String? idFuncionario,
      String? idActivo,
      bool? soloMostarSinEntregar}) async {
    try {
      if (soloMostarSinEntregar != null && soloMostarSinEntregar) {
        if (idFuncionario != null) {
          final data = await supabase
                  .from('PRESTAMOS')
                  .select('*')
                  .match({'ID_FUNCIONARIO': idFuncionario, 'ENTREGADO': false}).order('FECHA_HORA_FINAL',ascending:true)
              as List<dynamic>;
          return (data).map((e) => Prestamo.fromMap(e)).toList();
        } else if (idActivo != null) {
          final data = await supabase
                  .from('PRESTAMOS')
                  .select('*')
                  .match({'ID_ACTIVO': idActivo, 'ENTREGADO': false}).order('FECHA_HORA_FINAL',ascending:true)
              as List<dynamic>;
          return (data).map((e) => Prestamo.fromMap(e)).toList();
        } else {
          final data = await supabase
              .from('PRESTAMOS')
              .select('*')
              .match({'ENTREGADO': false}).order('ENTREGADO',ascending: true).order('FECHA_HORA_FINAL',ascending:true) as List<dynamic>;
          return (data).map((e) => Prestamo.fromMap(e)).toList();
        }
      } else {
        if (idFuncionario != null) {
          final data = await supabase
              .from('PRESTAMOS')
              .select('*')
              .eq('ID_FUNCIONARIO', idFuncionario).order('ENTREGADO',ascending: true).order('FECHA_HORA_FINAL',ascending:true) as List<dynamic>;
          return (data).map((e) => Prestamo.fromMap(e)).toList();
        } else if (idActivo != null) {
          final data = await supabase
              .from('PRESTAMOS')
              .select('*')
              .eq('ID_ACTIVO', idActivo).order('ENTREGADO',ascending: true).order('FECHA_HORA_FINAL',ascending:true) as List<dynamic>;
          return (data).map((e) => Prestamo.fromMap(e)).toList();
        } else {
          final data =
              await supabase.from('PRESTAMOS').select('*').order('ENTREGADO',ascending: true).order('FECHA_HORA_FINAL',ascending:true) as List<dynamic>;
          return (data).map((e) => Prestamo.fromMap(e)).toList();
        }
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
