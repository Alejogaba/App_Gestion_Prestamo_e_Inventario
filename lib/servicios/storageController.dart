import 'dart:async';
import 'dart:developer';
import 'package:app_gestion_prestamo_inventario/entidades/usuario.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:supabase/supabase.dart';
import '../../assets/constantes.dart' as constantes;
import 'package:universal_io/io.dart';
import 'package:translator/translator.dart';
import 'package:path/path.dart' as p;
import 'package:image_compression/image_compression.dart';

import '../flutter_flow/flutter_flow_theme.dart';

class StorageController {
  final supabase =
      SupabaseClient(constantes.SUPABASE_URL, constantes.SUPABASE_ANNON_KEY);
  Future<String> subirImagen(BuildContext context, String? filePath,
      File imageFile, String? id, String bucketName) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Subiendo imagen....",
          style: FlutterFlowTheme.of(context).bodyText2.override(
                fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                color: FlutterFlowTheme.of(context).tertiaryColor,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).bodyText2Family),
              ),
        ),
        backgroundColor: FlutterFlowTheme.of(context).primaryColor,
      ));
      final input = ImageFile(
        rawBytes: imageFile.readAsBytesSync(),
        filePath: imageFile.path,
      );
      final output;
      if (input.sizeInBytes > 300000) {
        output = await compressInQueue(ImageFileConfiguration(
            input: input,
            config: const Configuration(
                pngCompression: PngCompression.noCompression, jpgQuality: 90)));
      } else if (input.sizeInBytes > 500000) {
        output = await compressInQueue(ImageFileConfiguration(
            input: input,
            config: const Configuration(
                pngCompression: PngCompression.bestSpeed, jpgQuality: 80)));
      } else if (input.sizeInBytes > 700000) {
        output = await compressInQueue(ImageFileConfiguration(
            input: input,
            config: const Configuration(
                pngCompression: PngCompression.defaultCompression,
                jpgQuality: 70)));
      } else if (input.sizeInBytes > 1000000) {
        output = await compressInQueue(ImageFileConfiguration(
            input: input,
            config: const Configuration(
                pngCompression: PngCompression.bestCompression,
                jpgQuality: 50)));
      } else if (input.sizeInBytes > 1500000) {
        output = await compressInQueue(ImageFileConfiguration(
            input: input,
            config: const Configuration(
                pngCompression: PngCompression.bestCompression,
                jpgQuality: 30)));
      } else if (input.sizeInBytes > 2000000) {
        output = await compressInQueue(ImageFileConfiguration(
            input: input,
            config: const Configuration(
                pngCompression: PngCompression.bestCompression,
                jpgQuality: 10)));
      } else if (input.sizeInBytes > 3000000) {
        output = await compressInQueue(ImageFileConfiguration(
            input: input,
            config: const Configuration(
                pngCompression: PngCompression.bestCompression,
                jpgQuality: 5)));
      } else {
        output = await compressInQueue(ImageFileConfiguration(
            input: input,
            config: const Configuration(
                pngCompression: PngCompression.noCompression, jpgQuality: 95)));
      }

      log('FileName: ${output.fileName}');
      log('FilePath: ${output.filePath}');
      final bytes = output.rawBytes;
      const fileExt = 'jpg'; //output.filePath.split('.').last;
      final fileName = '$id.$fileExt';
      final filePath = fileName;
      final storageResponse = await supabase.storage
          .from(bucketName)
          .uploadBinary(
            filePath,
            bytes,
            fileOptions: const FileOptions(
              cacheControl: '4000',
              upsert: true,
            ),
          )
          .then((value) => {});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(milliseconds: 800),
        content: Text(
          "Imagen subida con exitó",
          style: FlutterFlowTheme.of(context).bodyText2.override(
                fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                color: FlutterFlowTheme.of(context).tertiaryColor,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).bodyText2Family),
              ),
        ),
        backgroundColor: FlutterFlowTheme.of(context).primaryColor,
      ));
      log('Resultado subida imagen: $storageResponse');

      final imageUrlResponse = await supabase.storage
          .from(bucketName)
          .createSignedUrl(filePath, 60 * 60 * 24 * 365 * 10);
      log('resultado imagen: $imageUrlResponse');
      log('Filename: $fileName');

      return 'https://ujftfjxhobllfwadrwqj.supabase.co/storage/v1/object/public/$bucketName/$fileName';
    } on StorageException catch (error) {
      var errorTraducido = 'Código ${error.statusCode}';
      log(error.message);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Error al subir imagen:$errorTraducido',
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
    } catch (error) {
      log(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 10),
        content: Text(
          "Ha ocurrido un error inesperado al momento de subir la imagen, verifique su conexión a internet",
          style: FlutterFlowTheme.of(context).bodyText2.override(
                fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                color: FlutterFlowTheme.of(context).tertiaryColor,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).bodyText2Family),
              ),
        ),
        backgroundColor: Colors.redAccent,
      ));
      Logger().e(error);
      return 'error';
    }
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
