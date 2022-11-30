import 'dart:developer';
import 'package:desktop_webview_auth/desktop_webview_auth.dart';
import 'package:desktop_webview_auth/google.dart';
import 'package:app_gestion_prestamo_inventario/entidades/usuario.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase/supabase.dart';
import '../../assets/constantes.dart' as constantes;
import 'package:universal_io/io.dart';
import 'package:translator/translator.dart';

const _redirectUri = 'https://accounts.google.com/o/oauth2/auth';
const _googleClientId =
    '199131897060-0p2gu71h9ap9avuecpp6bj7bspo4icqp.apps.googleusercontent.com';

class StorageController {
  final client =
      SupabaseClient(constantes.SUPABASE_URL, constantes.SUPABASE_ANNON_KEY);

  Future<void> subirImagen(filePath) async {
    final file = File('path/to/file');
    final fileBytes = await file.readAsBytes();
    await client.storage.from('categorias').uploadBinary(filePath, fileBytes);
  }

  Future<String> traducir(String input) async {
    final translator = GoogleTranslator();
    var translation = await translator
        .translate(input, from: 'es', to: 'en');
    return translation.toString();
  }

 
}

