import 'dart:async';
import 'dart:developer';
import 'package:app_gestion_prestamo_inventario/assets/utilidades.dart';
import 'package:app_gestion_prestamo_inventario/entidades/activo.dart';
import 'package:app_gestion_prestamo_inventario/entidades/categoria.dart';
import 'package:app_gestion_prestamo_inventario/servicios/storageController.dart';
import 'package:desktop_webview_auth/desktop_webview_auth.dart';
import 'package:desktop_webview_auth/google.dart';
import 'package:app_gestion_prestamo_inventario/entidades/usuario.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supabase/src/supabase_stream_builder.dart';
import 'package:supabase/supabase.dart';
import '../../assets/constantes.dart' as constantes;
import '../flutter_flow/flutter_flow_theme.dart';

const _redirectUri = 'https://accounts.google.com/o/oauth2/auth';
const _googleClientId =
    '199131897060-0p2gu71h9ap9avuecpp6bj7bspo4icqp.apps.googleusercontent.com';

class ActivoController {
  Utilidades utilidades = Utilidades();
  final supabase =
      SupabaseClient(constantes.SUPABASE_URL, constantes.SUPABASE_ANNON_KEY);

  Future<void> addActivo(
      context,
      String idSerial,
      String? numInventario,
      String nombre,
      String? detalles,
      String? urlImagen,
      int estado,
      String categoria,
      int? cantidad,
      String? capacidad,
      String? fechaCreado) async {
    try {
      log('Inserando nuevo activo...');
      Utilidades utilidades = Utilidades();
      await supabase.from('ACTIVOS').insert({
        'ID_SERIAL': idSerial.toUpperCase(),
        'NUM_ACTIVO': numInventario,
        'NOMBRE': utilidades.capitalizeAllWord(nombre),
        'DETALLES': detalles,
        'URL_IMAGEN': urlImagen,
        'ESTADO': estado,
        'NOMBRE_CATEGORIA': utilidades.capitalizeAllWord(categoria),
        'CANTIDAD': cantidad,
        'CAPACIDAD': capacidad,
        'FECHA_CREADO': fechaCreado,
      }).then((value) => log('Nueva activo registrado: $value'));
      log("Registrado con exito");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Activo registrado con exitó",
          style: FlutterFlowTheme.of(context).bodyText2.override(
                fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                color: FlutterFlowTheme.of(context).tertiaryColor,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).bodyText2Family),
              ),
        ),
        backgroundColor: FlutterFlowTheme.of(context).primaryColor,
      ));
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
    } catch (e) {
      log(e.toString());
    }
  }

  Stream<SupabaseStreamEvent> getActivosStream(String? categoria) {
    List<Activo> activoList = [];
    final response = (categoria != null && categoria.length > 3)
        ? supabase
            .from('ACTIVOS')
            .stream(primaryKey: ['ID_SERIAL'])
            .eq('NOMBRE_CATEGORIA', categoria)
            .order('FECHA_CREADO', ascending: false)
        : supabase.from('ACTIVOS').stream(
            primaryKey: ['ID_SERIAL']).order('FECHA_CREADO', ascending: false);
    return response;
  }

  Future<Activo> buscarActivo(String idSerial) async {
    Activo activoVacio = Activo(
        '',
        '',
        '',
        '',
        'https://www.giulianisgrupo.com/wp-content/uploads/2018/05/nodisponible.png',
        3,
        '',
        0,
        '');
    try {
      final data = (await supabase
              .from('ACTIVOS')
              .select()
              .match({'ID_SERIAL': idSerial}).maybeSingle())
          as Map<String, dynamic>?;
      if (data == null) {
        return activoVacio;
      } else {
        return Activo.fromMap(data);
      }
    } on DatabaseException catch (e) {
      log(e.result.toString());
      return activoVacio;
    } catch (e) {
      log(e.toString());
      return activoVacio;
    }
  }

  Future<String> eliminarActivo(context, String idSerial) async {
    try {
      final data =
          (await supabase.from('ACTIVOS').delete().eq('ID_SERIAL', idSerial));
      log('Eliminando:$data');
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
          'Ha ocurrido un error inesperado al intentar eliminar el activo',
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

  Future<List<Categoria>> getCategorias(String? nombre) async {
    if (nombre == null || nombre.trim() == '') {
      try {
        List<Categoria> listaCategoria = [];
        final data =
            await supabase.from('CATEGORIAS').select('*') as List<dynamic>;
        log('Datos: $data');
        return (data).map((e) => Categoria.fromMap(e)).toList();
      } on PostgrestException catch (error) {
        log(error.message);
        return [];
      } catch (error) {
        log('Error al cargar categorias: $error');
        return [];
      }
    } else {
      try {
        List<Categoria> listaCategoria = [];
        final data = await supabase.from('CATEGORIAS').select('*').textSearch(
                'NOMBRE', "'${Utilidades().capitalizeAllSentence(nombre)}'")
            as List<dynamic>;
        log('Datos: $data');
        return (data).map((e) => Categoria.fromMap(e)).toList();
      } on PostgrestException catch (error) {
        log(error.message);
        return [];
      } catch (error) {
        log('Error al cargar categorias: $error');
        return [];
      }
    }
  }

  Categoria toNote(Map<dynamic, dynamic> result) {
    return Categoria(
      result['NOMBRE'],
      result['URL_IMAGEN'],
    );
  }
}
