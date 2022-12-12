import 'dart:developer';
import 'package:app_gestion_prestamo_inventario/assets/utilidades.dart';
import 'package:app_gestion_prestamo_inventario/entidades/categoria.dart';
import 'package:app_gestion_prestamo_inventario/servicios/storageController.dart';

import 'package:app_gestion_prestamo_inventario/entidades/usuario.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
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
        final data =
            await client.from('CATEGORIAS').select('*') as List<dynamic>;
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
        final data = await client.from('CATEGORIAS').select('*').textSearch(
                'NOMBRE',
                "'${Utilidades().mayusculaPrimeraLetraFrase(nombre)}'")
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

  Future<void> addCategoria(
      context, String nombre, String urlImagen, String? descripcion) async {
    try {
      log('Inserando nuevo activo...');
      Utilidades utilidades = Utilidades();
      await client.from('CATEGORIAS').insert({
        'NOMBRE': utilidades.mayusculaTodasPrimerasLetras(nombre),
        'URL_IMAGEN': urlImagen,
        'DESCRIPCION': (descripcion == null)
            ? null
            : utilidades.mayusculaPrimeraLetraFrase(descripcion),
      }).then((value) => log('Nueva categoria registrada: $value'));
      log("Registrado con exito");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "CAtegoria registrada con exitó",
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

  Categoria toNote(Map<dynamic, dynamic> result) {
    return Categoria(
      result['NOMBRE'],
      result['URL_IMAGEN'],
      result['DESCRIPCION'],
    );
  }
}
