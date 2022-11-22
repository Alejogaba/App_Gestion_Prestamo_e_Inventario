import 'dart:async';
import 'dart:typed_data';
import 'package:app_gestion_prestamo_inventario/entidades/photos.dart';
import 'package:app_gestion_prestamo_inventario/entidades/state.dart';
import 'package:modern_form_esys_flutter_share/modern_form_esys_flutter_share.dart';
import 'package:observable/observable.dart';
import '../servicios/repository.dart';
import 'bloc_base.dart';

import 'package:rxdart/rxdart.dart';

class HomeScreenBloc extends BlocBase {
  static Repository _repository = Repository();
  late final PublishSubject<String> _query;

  init() {
    _query = PublishSubject<String>();
  }

  Stream<Photos> get photosList => _query.stream
      .debounceTime(Duration(milliseconds: 300))
      .where((String value) => value.isNotEmpty)
      .distinct()
      .transform(streamTransformer);

  final streamTransformer = StreamTransformer<String, Photos>.fromHandlers(
      handleData: (query, sink) async {
    State state = await _repository.imageData(query);
    if (state is SuccessState) {
      sink.add(state.value);
    } else {
      sink.addError((state as ErrorState).msg);
    }
  });

  Function(String) get changeQuery => _query.sink.add;

  @override
  void dispose() {
    _query.close();
  }

  String? getDescription(Result result) {
    return (result.description == null || result.description!.isEmpty)
        ? result.altDescription
        : result.description;
  }

  void shareImage(String url) {
    Uri myUri = Uri.parse(url);
    _repository.getImageToShare(url).then((Uint8List value) async {
      Share.text('Titulo','Nombre','s');
    });
  }
}

final bloc = HomeScreenBloc();
