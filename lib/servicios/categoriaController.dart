import 'dart:developer';
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



class CategoriaController {
  final client = SupabaseClient(constantes.SUPABASE_URL, constantes.SUPABASE_ANNON_KEY);

  Future<void> addCategoria(nombre,urlImagen) async {
    final data = await client
    .from('categorias')
    .insert({'nombre': nombre, 'url_imagen': urlImagen});

  }
}
