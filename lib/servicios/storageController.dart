import 'dart:developer';
import 'package:app_gestion_prestamo_inventario/entidades/usuario.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase/supabase.dart';
import '../../assets/constantes.dart' as constantes;
import 'package:universal_io/io.dart';
import 'package:translator/translator.dart';
import 'package:path/path.dart' as p;

import '../flutter_flow/flutter_flow_theme.dart';

class StorageController {
  final supabase =
      SupabaseClient(constantes.SUPABASE_URL, constantes.SUPABASE_ANNON_KEY);
  Future<String> subirImagen(BuildContext context, String? filePath,
      File imageFile, String? id,String bucketName) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final fileExt = imageFile.path.split('.').last;
      final fileName = '$id.$fileExt';
      final filePath = fileName;
      final fileType = "${filePath.split('.').last}/";
      await supabase.storage.from(bucketName).uploadBinary(
            filePath,
            bytes,
            fileOptions: FileOptions(),
          );

      final imageUrlResponse = await supabase.storage
          .from('activos')
          .createSignedUrl(filePath, 60 * 60 * 24 * 365 * 10);
      log('resultado imagen: $imageUrlResponse');
      log('Filename: $fileName');
      return imageUrlResponse;
    } on StorageException catch (error) {
      var errorTraducido = await traducir(error.message);
      log(error.message);
      if (!errorTraducido.contains('existe')) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Error al subir imagen:$errorTraducido',
            style: FlutterFlowTheme.of(context).bodyText2.override(
                  fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                  color: FlutterFlowTheme.of(context).tertiaryColor,
                  useGoogleFonts: GoogleFonts.asMap().containsKey(
                      FlutterFlowTheme.of(context).bodyText2Family),
                ),
          ),
          backgroundColor: Colors.redAccent,
        ));
        final fileExt = imageFile.path.split('.').last;
        final fileName = '$id.$fileExt';
        return 'https://ujftfjxhobllfwadrwqj.supabase.co/storage/v1/object/public/$bucketName/$fileName';
      } else {
        final fileExt = imageFile.path.split('.').last;
        final fileName = '$id.$fileExt';
        return 'https://ujftfjxhobllfwadrwqj.supabase.co/storage/v1/object/public/$bucketName/$fileName';
      }
      
    } catch (error) {
      log(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Ha ocurrido un error inesperado al momento de subir la imagen",
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
    }
    return 'https://www.giulianisgrupo.com/wp-content/uploads/2018/05/nodisponible.png';
  }

  Future<String> traducir(String input) async {
    try {
      final translator = GoogleTranslator();
      var translation = await translator.translate(input, from: 'en', to: 'es');
      return translation.toString();
    } catch (e) {
      log(e.toString());
      return "Ha ocurrido un error inesperado, revise su conexión a internet";
    }
  }
}
