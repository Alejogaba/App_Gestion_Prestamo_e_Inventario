import 'dart:async';
import 'dart:developer';
import 'package:app_gestion_prestamo_inventario/assets/utilidades.dart';
import 'package:app_gestion_prestamo_inventario/entidades/activo.dart';
import 'package:app_gestion_prestamo_inventario/servicios/storageController.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite/sqflite.dart';
// ignore: implementation_imports
import 'package:supabase/src/supabase_stream_builder.dart';
import 'package:supabase/supabase.dart';
import '../../assets/constantes.dart' as constantes;
import '../flutter_flow/flutter_flow_theme.dart';

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
        'NOMBRE': utilidades.mayusculaTodasPrimerasLetras(nombre),
        'DETALLES': detalles,
        'URL_IMAGEN': urlImagen,
        'ESTADO': estado,
        'NOMBRE_CATEGORIA': utilidades.mayusculaTodasPrimerasLetras(categoria),
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

  Future<String> asignarActivo(
    context,
    String idFuncionario,
    String idActivo,
  ) async {
    try {
      await supabase.from('FUNCIONARIOS_ACTIVOS').insert({
        'ID_FUNCIONARIO': idFuncionario,
        'ID_ACTIVO': idActivo,
      }).then((value) async {
        log('Nuevo activo asignado: $value');
        await supabase
            .from('ACTIVOS')
            .update({'ESTA_ASIGNADO': true}).match({'ID_SERIAL': idActivo});
        await supabase
            .from('FUNCIONARIOS')
            .update({'TIENE_ACTIVOS': true}).match({'CEDULA': idFuncionario});
      });
      log("Asignado con exito");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Activo asignado con exitó",
          style: FlutterFlowTheme.of(context).bodyText2.override(
                fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                color: FlutterFlowTheme.of(context).tertiaryColor,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).bodyText2Family),
              ),
        ),
        backgroundColor: FlutterFlowTheme.of(context).primaryColor,
      ));
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
      return 'error';
    }
  }

  Stream<SupabaseStreamEvent> getActivoStream(String? categoria) {
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'errorTraducido',
          style: FlutterFlowTheme.of(context).bodyText2.override(
                fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                color: FlutterFlowTheme.of(context).tertiaryColor,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).bodyText2Family),
              ),
        ),
        backgroundColor: Colors.redAccent,
      ));
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

  Future<String> quitarActivoFuncionario(context, String idActivo) async {
    try {
      final data = (await supabase
          .from('FUNCIONARIOS_ACTIVOS')
          .delete()
          .match({ 'ID_ACTIVO': idActivo}).then((value) async{
             await supabase
            .from('ACTIVOS')
            .update({'ESTA_ASIGNADO': false}).match({'ID_SERIAL': idActivo});
          }));
      log('Eliminando:$data');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Se ha quitado con exitó',
          style: FlutterFlowTheme.of(context).bodyText2.override(
                fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                color: FlutterFlowTheme.of(context).tertiaryColor,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).bodyText2Family),
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

  Future<String> quitarFuncionarioActivo(context, String idFuncionario,int cantidadActivos) async {
    try {
      final data = (await supabase
          .from('FUNCIONARIOS_ACTIVOS')
          .delete()
          .match({ 'ID_FUNCIONARIO': idFuncionario}).then((value) async{
            if(cantidadActivos<2){
              await supabase
            .from('FUNCIONARIOS')
            .update({'TIENE_ACTIVOS': false}).match({'CEDULA': idFuncionario});
            }
            
          }));
      log('Eliminando:$data');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Se ha quitado con exitó',
          style: FlutterFlowTheme.of(context).bodyText2.override(
                fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                color: FlutterFlowTheme.of(context).tertiaryColor,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).bodyText2Family),
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
}
