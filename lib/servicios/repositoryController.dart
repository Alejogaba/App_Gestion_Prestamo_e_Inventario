import 'dart:developer';
import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../assets/constantes.dart' as constantes;
import '../entidades/state.dart';
import '../entidades/version.dart';
import 'image_provider.dart';
class RepositoryController {
  final supabase =
      SupabaseClient(constantes.SUPABASE_URL, constantes.SUPABASE_ANNON_KEY);


  static final RepositoryController _repository = RepositoryController._private();
  RepositoryController._private();
  factory RepositoryController() => _repository;

  ImageProvider _imageProvider = ImageProvider();

  Future<State> imageData(query) => _imageProvider.getImagesByName(query);

  Future<Uint8List> getImageToShare(String url) {
    return _imageProvider.getImageFromUrl(url);
  }

  Future<Version> buscarVersion() async {
    Version activoVacio = Version(
        '',
        '',false);
    try {
      final data = (await supabase
              .from('versiones')
              .select('*').match({'es_ultima_version':true})
              .maybeSingle())
          as Map<String, dynamic>?;
      if (data == null) {
        return activoVacio;
      } else {
        return Version.fromMap(data);
      }
    } catch (e) {
      log(e.toString());
      return activoVacio;
    }
  }
}