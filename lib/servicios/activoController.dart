import 'dart:developer';
import 'package:app_gestion_prestamo_inventario/assets/utilidades.dart';
import 'package:app_gestion_prestamo_inventario/entidades/categoria.dart';
import 'package:desktop_webview_auth/desktop_webview_auth.dart';
import 'package:desktop_webview_auth/google.dart';
import 'package:app_gestion_prestamo_inventario/entidades/usuario.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import '../../assets/constantes.dart' as constantes;

const _redirectUri = 'https://accounts.google.com/o/oauth2/auth';
const _googleClientId =
    '199131897060-0p2gu71h9ap9avuecpp6bj7bspo4icqp.apps.googleusercontent.com';

class ActivoController {
  Utilidades utilidades = Utilidades();
  final client =
      SupabaseClient(constantes.SUPABASE_URL, constantes.SUPABASE_ANNON_KEY);

  Future<void> addActivo(
      idSerial, numInventario, nombre, urlImagen, estado, categoria) async {
    try {
      await client.from('ACTIVOS').insert({
        'ID_SERIAL': idSerial,
        'NUM_ACTIVO': numInventario,
        'NOMBRE': nombre,
        'URL_IMAGEN': urlImagen,
        'ESTADO': estado,
        'NOMBRE_CATEGORIA': categoria,
      }).then((value) => log('Nueva categoria registrada: $value'));
      log("Registrado con exito");
    } on Exception catch (e) {
      log(e.toString());
    }catch(e){
      log(e.toString());
    }
  }

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
