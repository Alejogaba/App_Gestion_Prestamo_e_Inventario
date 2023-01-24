import 'dart:async';
import 'dart:developer';
import 'package:app_gestion_prestamo_inventario/assets/utilidades.dart';
import 'package:app_gestion_prestamo_inventario/entidades/activo_funcionario.dart';
import 'package:app_gestion_prestamo_inventario/entidades/activo.dart';
import 'package:app_gestion_prestamo_inventario/entidades/area.dart';
import 'package:app_gestion_prestamo_inventario/entidades/componenteExterno.dart';
import 'package:app_gestion_prestamo_inventario/entidades/componenteInterno.dart';
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

class ComponenteInternoController {
  Utilidades utilidades = Utilidades();
  final supabase =
      SupabaseClient(constantes.SUPABASE_URL, constantes.SUPABASE_ANNON_KEY);

  Future<String> registrar(
    BuildContext context, String idEquipoComputo, String urlImagen,
   String nombre, String marca, String velocidad,
    String otrasCaracteristicas,{bool editar=false,int id=0}) async {
      
    try { 
      if(id!=0){
        await supabase.from('COMPONENTESINTERNOS').update({
      'ID_EQUIPO_COMPUTO': idEquipoComputo,
      'URL_IMAGEN': urlImagen,
      'NOMBRE': nombre,
      'MARCA': marca,
      'VELOCIDAD': velocidad,
      'OTRAS_CARACTERISTICAS': otrasCaracteristicas
    }).eq('ID', id).then((value) async {
      log('Nuevo componente interno registrado: $value');
    });
      }else{
        await supabase.from('COMPONENTESINTERNOS').insert({
      'ID_EQUIPO_COMPUTO': idEquipoComputo,
      'URL_IMAGEN': urlImagen,
      'NOMBRE': nombre,
      'MARCA': marca,
      'VELOCIDAD': velocidad,
      'OTRAS_CARACTERISTICAS': otrasCaracteristicas
    }).then((value) async {
      log('Nuevo componente interno registrado: $value');
    });
      }
      
    return 'ok';
    } on PostgrestException catch (errorPostgres) {
       var error = Utilidades().validarErroresInsertar(
        errorPostgres.code!, 'Este componente interno');
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

  Future<List<ComponenteInterno>> getbyIdActivo(
      String? idActivo,
      ) async {
    try {
       final data = await supabase
                  .from('COMPONENTESINTERNOS')
                  .select('*')
                  .match({'ID_EQUIPO_COMPUTO': idActivo})
              as List<dynamic>;
          return (data).map((e) => ComponenteInterno.fromMap(e)).toList();
    } on PostgrestException catch (error) {
      Logger().e(error.message);
      return [];
    } catch (error) {
      Logger().e('Error al cargar ACTIVOS ASIGNADOS: $error');
      return [];
    }
  }

  Future<String> eliminarbyid(context, String id) async {
    try {
      final data =
          await supabase.from('COMPONENTESINTERNOS').delete().match({'ID': id});
      log('Eliminando:$data');
      return 'ok';
    }  on PostgrestException catch (errorPostgres) {
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
    }catch (e) {
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
