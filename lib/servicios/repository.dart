import 'dart:typed_data';

import '../entidades/state.dart';
import 'image_provider.dart';
class Repository {
  static final Repository _repository = Repository._private();
  Repository._private();
  factory Repository() => _repository;

  ImageProvider _imageProvider = ImageProvider();

  Future<State> imageData(query) => _imageProvider.getImagesByName(query);

  Future<Uint8List> getImageToShare(String url) {
    return _imageProvider.getImageFromUrl(url);
  }
}