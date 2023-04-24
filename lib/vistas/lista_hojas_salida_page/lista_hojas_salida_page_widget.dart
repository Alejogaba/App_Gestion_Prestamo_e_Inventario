import 'dart:developer';
import 'dart:io';

import 'package:app_gestion_prestamo_inventario/entidades/area.dart';
import 'package:app_gestion_prestamo_inventario/entidades/funcionario.dart';
import 'package:app_gestion_prestamo_inventario/entidades/hoja_salida.dart';
import 'package:app_gestion_prestamo_inventario/servicios/funcionariosController.dart';
import 'package:app_gestion_prestamo_inventario/servicios/prestamosController.dart';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:path_provider/path_provider.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart' as OpenFile;

class ListaHojaSalidaPageWidget extends StatefulWidget {
  const ListaHojaSalidaPageWidget({Key? key}) : super(key: key);

  @override
  _ListaHojaSalidaPageWidgetState createState() =>
      _ListaHojaSalidaPageWidgetState();
}

class _ListaHojaSalidaPageWidgetState extends State<ListaHojaSalidaPageWidget> {
  TextEditingController? textControllerBusqueda;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String textDial = 'Buscar por código de barras';
  List<Funcionario> listFuncionariosLocal = [];
  FuncionariosController funcionariosController = FuncionariosController();
  bool _downloading = false;
  late final storageLocation = rutaArchivostemporales();
  @override
  void initState() {
    super.initState();
    textControllerBusqueda = TextEditingController();
  }

  @override
  void dispose() {
    textControllerBusqueda?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            pinned: true,
            floating: false,
            backgroundColor: FlutterFlowTheme.of(context).primaryColor,
            iconTheme:
                IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
            automaticallyImplyLeading: true,
            title: AutoSizeText(
              'Lista de hojas de salida',
              style: FlutterFlowTheme.of(context).bodyText1.override(
                    fontFamily: FlutterFlowTheme.of(context).bodyText1Family,
                    color: FlutterFlowTheme.of(context).whiteColor,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    useGoogleFonts: GoogleFonts.asMap().containsKey(
                        FlutterFlowTheme.of(context).bodyText1Family),
                  ),
            ),
            centerTitle: false,
            elevation: 4,
          )
        ],
        body: Builder(
          builder: (context) {
            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                                child: FutureBuilder<List<HojaSalida>>(
                                  future:
                                      PrestamosController().getHojaSalida(''),
                                  builder: ((context, snapshot) {
                                    int i = 0;
                                    List<Widget> temp = [];

                                    log('Estado de conexion connctionState:$snapshot.connectionState');

                                    if (snapshot.connectionState ==
                                            ConnectionState.done &&
                                        snapshot.data!.length > 0) {
                                      return ListView.builder(
                                        padding: EdgeInsets.zero,
                                        primary: false,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: snapshot.data!.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return tarjetaFuncionario(
                                              snapshot.data![index]);
                                        },
                                      );
                                    } else if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return loading(context);
                                    } else if (snapshot.hasError) {
                                      log('Error: ${snapshot.error}');
                                      return Container();
                                    } else {
                                      log('Error de conexion: ${snapshot.error}');
                                    }

                                    return Container();
                                  }),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

/*
  Future<void> scanCnic(ImageSource imageSource) async {
    /// you will need to pass one argument of "ImageSource" as shown here
    CnicModel cnicModel =
        await CnicScanner().scanImage(imageSource: imageSource);
    if (cnicModel == null) return;
    setState(() {
      textDial = cnicModel.cnicHolderName;
      log(cnicModel.cnicHolderName);
    });
  }
*/
  static Future<String> rutaArchivostemporales() async {
    var _tempDirectory = await getTemporaryDirectory();
    return _tempDirectory.path;
  }

  Future<void> _downloadFile(String numConsecutivo) async {
    setState(() {
      _downloading = true;
    });

    // Obtener el directorio temporal donde se guardará el archivo
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/$numConsecutivo.pdf';
    String? _localPath;

    // Descargar el archivo desde la URL utilizando Dio
    final dio = Dio();
    await dio.download(
        'https://ujftfjxhobllfwadrwqj.supabase.co/storage/v1/object/public/hojas-salida/$numConsecutivo.pdf',
        filePath);
    // Abrir el archivo descargado
    setState(() {
      _downloading = false;
      _localPath = filePath;
    });
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      final Uri uri = Uri.file(_localPath!);
      if (!File(uri.toFilePath()).existsSync()) {
        throw '$uri does not exist!';
      }
      if (!await launchUrl(uri)) {
        throw 'Could not launch $uri';
      }
    } else {
      await OpenFile.OpenFilex.open(_localPath);
    }
  }
}

Widget loading(context) {
  return Padding(
    padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 24),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(
            color: FlutterFlowTheme.of(context).primaryColor,
            strokeWidth: 10.0,
          ),
        ),
      ],
    ),
  );
}

class tarjetaFuncionario extends StatelessWidget {
  final HojaSalida hojaSalida;
  const tarjetaFuncionario(
    this.hojaSalida, {
    Key? key,
  }) : super(key: key);

  @override
  void initState() {}
  @override
  Widget build(BuildContext context) {
    Area area = Area(id: 1, nombre: 'Área', urlImagen: '');
    return GestureDetector(
      onTap: () async {
        log('ontap');
        
    // Obtener el directorio temporal donde se guardará el archivo
    final directory = await getTemporaryDirectory();
    
    final filePath = '${directory.path}/${definirConsecutivo(hojaSalida.id)}.pdf';
    String? _localPath;

    // Descargar el archivo desde la URL utilizando Dio
    final dio = Dio();
    await dio.download(
        'https://ujftfjxhobllfwadrwqj.supabase.co/storage/v1/object/public/hojas-salida/${definirConsecutivo(hojaSalida.id)}.pdf',
        filePath);
    // Abrir el archivo descargado
    
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      final Uri uri = Uri.file(filePath);
      if (!File(uri.toFilePath()).existsSync()) {
        throw '$uri does not exist!';
      }
      if (!await launchUrl(uri)) {
        throw 'Could not launch $uri';
      }
    } else {
      await OpenFile.OpenFilex.open(filePath);
    }
      },
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            boxShadow: [
              BoxShadow(
                blurRadius: 3,
                color: FlutterFlowTheme.of(context).boxShadow,
                spreadRadius: 1,
              )
            ],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 1, 1, 1),
                  child: ClipRRect(
                    borderRadius: BorderRadius.zero,
                    child: FastCachedImage(
                      width: 80,
                      height: 80,
                      url:
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/8/87/PDF_file_icon.svg/625px-PDF_file_icon.svg.png',
                      fit: BoxFit.fitHeight,
                      fadeInDuration: const Duration(seconds: 1),
                      errorBuilder: (context, exception, stacktrace) {
                        log(stacktrace.toString());
                        return Text('ERROR');
                      },
                      loadingBuilder: (context, progress) {
                        return Container(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if (progress.isDownloading &&
                                  progress.totalBytes != null)
                                Text(
                                    '${progress.downloadedBytes ~/ 1024} / ${progress.totalBytes! ~/ 1024} kb',
                                    style: const TextStyle(
                                        color: Color(0xFF006D38))),
                              SizedBox(
                                  width: 70,
                                  height: 70,
                                  child: CircularProgressIndicator(
                                      color: const Color(0xFF006D38),
                                      value:
                                          progress.progressPercentage.value)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8, 2, 4, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          definirConsecutivo(hojaSalida.id),
                          style: FlutterFlowTheme.of(context).title3.override(
                                fontFamily: 'Poppins',
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context).title3Family),
                              ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 3, 8, 0),
                          child: AutoSizeText(
                            'Funcionario: ${hojaSalida.funcionario}',
                            textAlign: TextAlign.start,
                            style: FlutterFlowTheme.of(context)
                                .bodyText2
                                .override(
                                  fontFamily: 'Poppins',
                                  color: FlutterFlowTheme.of(context).grayicon,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .bodyText2Family),
                                ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 3, 8, 0),
                          child: AutoSizeText(
                            'Fecha: '+hojaSalida.fecha,
                            textAlign: TextAlign.start,
                            style: FlutterFlowTheme.of(context)
                                .bodyText2
                                .override(
                                  fontFamily: 'Poppins',
                                  color: FlutterFlowTheme.of(context).grayicon,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .bodyText2Family),
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFF57636C),
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String definirConsecutivo(int con) {
  String nombreConsecutivo;
  if (con < 10) {
    return 'GTI-00$con';
  } else if (con < 100) {
    return 'GTI-0$con';
  } else {
    return 'GTI-$con';
  }
}

Future<Area> cargarArea(id) async {
  FuncionariosController funcionariosController = FuncionariosController();
  Area area = await funcionariosController.buscarArea(id.toString());
  return area;
}
