import 'dart:developer';
import 'package:app_gestion_prestamo_inventario/assets/utilidades.dart';
import 'package:app_gestion_prestamo_inventario/entidades/categoria.dart';
import 'package:app_gestion_prestamo_inventario/servicios/storageController.dart';

import 'package:app_gestion_prestamo_inventario/entidades/usuario.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase/supabase.dart';
import '../../assets/constantes.dart' as constantes;
import '../flutter_flow/flutter_flow_theme.dart';

const _redirectUri = 'https://accounts.google.com/o/oauth2/auth';
const _googleClientId =
    '199131897060-0p2gu71h9ap9avuecpp6bj7bspo4icqp.apps.googleusercontent.com';

class CategoriaController {
  Utilidades utilidades = Utilidades();
  final client =
      SupabaseClient(constantes.SUPABASE_URL, constantes.SUPABASE_ANNON_KEY);

  Future<List<Categoria>> getCategorias(String? nombre) async {
    if (nombre == null || nombre.trim() == '') {
      try {
        List<Categoria> listaCategoria = [];
        final data = await client
            .from('CATEGORIAS')
            .select('*')
            .order('ORDEN', ascending: true) as List<dynamic>;
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
        final data = await client
            .from('CATEGORIAS')
            .select('*')
            .textSearch('NOMBRE',
                "'${Utilidades().mayusculaPrimeraLetraFrase(nombre)}'")
            .order('ORDEN', ascending: true) as List<dynamic>;
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

  Future<List<Categoria>> getCategoriasOrderById(String? nombre) async {
    if (nombre == null || nombre.trim() == '') {
      try {
        List<Categoria> listaCategoria = [];
        final data = await client
            .from('CATEGORIAS')
            .select('*')
            .order('ID', ascending: true) as List<dynamic>;
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
        final data = await client
            .from('CATEGORIAS')
            .select('*')
            .textSearch('NOMBRE',
                "'${Utilidades().mayusculaPrimeraLetraFrase(nombre)}'")
            .order('ORDEN', ascending: true) as List<dynamic>;
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

  Future<Categoria> buscarCategoriaID(int id) async {
    Categoria vacio = Categoria('', '', '');
    try {
      final data = (await client
          .from('CATEGORIAS')
          .select()
          .match({'ID': id}).maybeSingle()) as Map<String, dynamic>?;
      if (data == null) {
        return vacio;
      } else {
        return Categoria.fromMap(data);
      }
    } catch (e) {
      log(e.toString());
      return vacio;
    }
  }

  Future<void> addCategoria(
      context, String nombre, String urlImagen, String? descripcion,
      {int idCategoria = 0}) async {
    try {
      
      Utilidades utilidades = Utilidades();
      if (idCategoria>0) {
        log('Editando categoria...');
        await client
            .from('CATEGORIAS')
            .update({
              'NOMBRE': utilidades.mayusculaTodasPrimerasLetras(nombre),
              'URL_IMAGEN': urlImagen,
              'DESCRIPCION': (descripcion == null)
                  ? null
                  : utilidades.mayusculaPrimeraLetraFrase(descripcion),
            })
            .eq('ID', idCategoria)
            .then((value) {
              log('categoria registrada: $value');
            
            log("Editado con exito");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Categoria registrada con exitó",
          style: FlutterFlowTheme.of(context).bodyText2.override(
                fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                color: FlutterFlowTheme.of(context).tertiaryColor,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).bodyText2Family),
              ),
        ),
        backgroundColor: FlutterFlowTheme.of(context).primaryColor,
      ));});
      } else {
        log('Registrando categoria...');
        await client.from('CATEGORIAS').insert({
          'NOMBRE': utilidades.mayusculaTodasPrimerasLetras(nombre),
          'URL_IMAGEN': urlImagen,
          'DESCRIPCION': (descripcion == null)
              ? null
              : utilidades.mayusculaPrimeraLetraFrase(descripcion),
        }).then((value){
              log('Nueva categoria registrada: $value');
            
            log("Registrado con exito");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Categoria registrada con exitó",
          style: FlutterFlowTheme.of(context).bodyText2.override(
                fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                color: FlutterFlowTheme.of(context).tertiaryColor,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).bodyText2Family),
              ),
        ),
        backgroundColor: FlutterFlowTheme.of(context).primaryColor,
      ));});
      }
    } on PostgrestException catch (errorPostgres) {
      StorageController storageController = StorageController();
      var error = Utilidades().validarErroresInsertar(
          errorPostgres.code!, 'Esta categoria',
          error: errorPostgres.message);
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
    } catch (e) {
      log(e.toString());
    }
  }

  Future<String> eliminar(context, String id) async {
    try {
      final data = (await client.from('CATEGORIAS').delete().eq('ID', id));
      log('Eliminando:$data');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Eliminado con exitó',
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
    } on PostgrestException catch (errorPostgres) {
      var error = Utilidades().validarErroresEliminar(
          errorPostgres.code!, 'esta categoria',
          objetoLlaveForaneo:
              'activos asignados, debe estar vacio para poder ser eliminado');
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
          'Ha ocurrido un error inesperado al intentar eliminar, verifique su conexión a internet',
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

  Categoria toNote(Map<dynamic, dynamic> result) {
    return Categoria(
      result['NOMBRE'],
      result['URL_IMAGEN'],
      result['DESCRIPCION'],
    );
  }
}
