import 'dart:typed_data';
import 'package:http/http.dart';
import '../models/state.dart';
import 'dart:convert';

class ImageProvider {
  //Singleton
  static final ImageProvider _imageProvider = ImageProvider._private();
  ImageProvider._private();
  factory ImageProvider() => _imageProvider;

  Client _client = Client();
  static const String _apiKey = "api-key";
  static const String _baseUrl = "https://api.unsplash.com";

  //Get list of images based on the query
  Future<State> getImagesByName(String query) async {
    Response response;
    if (_apiKey == 'api-key') {
      return State<String>.error("Please enter your API Key");
    }
    Uri url = Uri(
    scheme: 'https',
    host: 'api.unsplash.com',
    path: '/search/photos?page=1&query=$query&client_id=$_apiKey',);
    response = await _client.get(url);
    if (response.statusCode == 200)
      return State<Photos>.success(Photos.fromJson(json.decode(response.body)));
    else
      return State<String>.error(response.statusCode.toString());
  }

  Future<Uint8List> getImageFromUrl(Uri localUrl) async {
    var response = await _client.get(localUrl);
    Uint8List bytes = response.bodyBytes;
    return bytes;
  }
}
