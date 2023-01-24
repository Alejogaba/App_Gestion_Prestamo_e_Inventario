import 'dart:async';
import 'dart:developer';
import 'package:app_gestion_prestamo_inventario/assets/utilidades.dart';
import 'package:app_gestion_prestamo_inventario/entidades/activo_funcionario.dart';
import 'package:app_gestion_prestamo_inventario/entidades/activo.dart';
import 'package:app_gestion_prestamo_inventario/entidades/area.dart';
import 'package:app_gestion_prestamo_inventario/entidades/componenteExterno.dart';
import 'package:app_gestion_prestamo_inventario/entidades/funcionario.dart';
import 'package:app_gestion_prestamo_inventario/entidades/hoja_salida.dart';
import 'package:app_gestion_prestamo_inventario/entidades/prestamo.dart';
import 'package:app_gestion_prestamo_inventario/servicios/activoController.dart';
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

class ComponenteExternoController {
  Utilidades utilidades = Utilidades();
  final supabase =
      SupabaseClient(constantes.SUPABASE_URL, constantes.SUPABASE_ANNON_KEY);

  Future<String> registrar(context, String idEquipoComputo, String idComponente,
      {bool editar = false, int? id}) async {
    try {
      if (id != null) {
        await supabase.from('COMPONENTESEXTERNOS').update({
          'ID_EQUIPO_COMPUTO': idEquipoComputo,
          'ID_COMPONENTE': idComponente,
        }).match({'ID': id}).then((value) async {
          log('Nuevo activo registrado: $value');
        });
      } else {
        await supabase.from('COMPONENTESEXTERNOS').insert({
          'ID_EQUIPO_COMPUTO': idEquipoComputo,
          'ID_COMPONENTE': idComponente,
        }).then((value) async {
          log('Nuevo activo registrado: $value');
        });
      }

      return 'ok';
    } on PostgrestException catch (errorPostgres) {
      var error = Utilidades().validarErroresInsertar(
          errorPostgres.code!, 'Este Componente externo');
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Ha ocurrido un error, revise su conexión a internet',
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

  Future<List<Activo>> getbyIdActivo(
    String? idActivo,
  ) async {
    List<Activo> listActivos = [];
    try {
      final data = await supabase
          .from('COMPONENTESEXTERNOS')
          .select('*')
          .match({'ID_EQUIPO_COMPUTO': idActivo}) as List<dynamic>;
      var listaComponentes =
          (data).map((e) => ComponenteExterno.fromMap(e)).toList();
      for (var element in listaComponentes) {
        Activo activo =
            await ActivoController().buscarActivo(element.idComponente);
        listActivos.add(activo);
      }
      return listActivos;
    } on PostgrestException catch (error) {
      Logger().e(error.message);
      return [];
    } catch (error) {
      Logger().e('Error al cargar COMPONETES EXTERNOS: $error');
      return [];
    }
  }

  Future<String> eliminarbyidComponente(
      context, String idActivo, String idComponente) async {
    try {
      final data = await supabase.from('COMPONENTESEXTERNOS').delete().match(
          {'ID_EQUIPO_COMPUTO': idActivo, 'ID_COMPONENTE': idComponente});
      log('Eliminando:$data');
      return 'ok';
    } on PostgrestException catch (errorPostgres) {
      var error = Utilidades().validarErroresEliminar(
          errorPostgres.code!, 'Este activos',
          objetoLlaveForaneo: 'funcionario asignados');
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
    } catch (e) {
      log(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Ha ocurrido un error inesperado al intentar eliminar el activo, verfique su conexión a internet',
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
}
