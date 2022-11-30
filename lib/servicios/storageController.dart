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


class StorageController {
  final supabase =
      SupabaseClient(constantes.SUPABASE_URL, constantes.SUPABASE_ANNON_KEY);
  Future<String?> subirImagen(BuildContext context,filePath,imageFile,String? id_serial) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final fileExt = imageFile.path.split('.').last;
      final fileName = '$id_serial.$fileExt';
      final filePath = fileName;
      await supabase.storage.from('ACTIVOS').uploadBinary(
            filePath,
            bytes,
            fileOptions: FileOptions(contentType: imageFile.mimeType),
          );
      final imageUrlResponse = await supabase.storage
          .from('ACTIVOS')
          .createSignedUrl(filePath, 60 * 60 * 24 * 365 * 10);
      return imageUrlResponse;
    } on StorageException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message)));
    } catch (error) {
        ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: 
        Text("Ha ocurrido un error inesperado al momento de subir la imageFile")));
    }
    return null;
  }

  Future<String> traducir(String input) async {
    final translator = GoogleTranslator();
    var translation = await translator
        .translate(input, from: 'es', to: 'en');
    return translation.toString();
  }

 
}

