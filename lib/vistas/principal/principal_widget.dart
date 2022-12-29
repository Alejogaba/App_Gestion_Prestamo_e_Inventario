import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:app_gestion_prestamo_inventario/entidades/version.dart';
import 'package:app_gestion_prestamo_inventario/servicios/activoController.dart';
import 'package:app_gestion_prestamo_inventario/servicios/repositoryController.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../entidades/categoria.dart';
import '../../servicios/categoriaController.dart';

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
import 'package:package_info_plus/package_info_plus.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:logger/logger.dart';

class PrincipalWidget extends StatefulWidget {
  final bool selectMode;

  const PrincipalWidget({
    Key? key,
    this.selectMode = false,
  }) : super(key: key);

  @override
  _PrincipalWidgetState createState() => _PrincipalWidgetState(this.selectMode);
}

class _PrincipalWidgetState extends State<PrincipalWidget> {
  var logger = Logger(
    printer: PrettyPrinter(),
  );
  TextEditingController? textControllerBusqueda;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  CategoriaController categoriaController = CategoriaController();
  List<Categoria> listCategoriasLocal = [];
  String busquedaCategoria = '';
  Version version = Version();
  late final listaCategoriasOnline = cargarCategorias();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final prefs = SharedPreferences.getInstance();
  bool local = false;
  bool selectMode;

  _PrincipalWidgetState(this.selectMode);

  @override
  void initState() {
    super.initState();
      validarVersion(context, logger);
    textControllerBusqueda = TextEditingController();
    _cargarlistaLocal();
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
      drawer: Drawer(
        elevation: 16,
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 50.0, right: 16),
        child: SpeedDial(
          //Speed dial menu
          //margin bottom
          icon: Icons.menu, //icon on Floating action button
          activeIcon: Icons.close, //icon when menu is expanded on button
          backgroundColor: FlutterFlowTheme.of(context)
              .primaryColor, //background color of button
          foregroundColor: Colors.white, //font color, icon color in button
          activeBackgroundColor: FlutterFlowTheme.of(context)
              .primaryColor, //background color when menu is expanded
          activeForegroundColor: Colors.white,
          buttonSize: const Size(56.0, 56), //button size
          visible: true,
          closeManually: false,
          curve: Curves.bounceIn,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          onOpen: () => print('OPENING DIAL'), // action when menu opens
          onClose: () => print('DIAL CLOSED'), //action when menu closes

          elevation: 8.0, //shadow elevation of button
          shape: CircleBorder(), //shape of button

          children: [
            if(Platform.isAndroid||Platform.isIOS) 
            SpeedDialChild(
              //speed dial child
              child: Icon(FontAwesomeIcons.barcode),
              backgroundColor: Color.fromARGB(255, 7, 133, 36),
              foregroundColor: Colors.white,
              label: 'Buscar por código de barras',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () async {
                await FlutterBarcodeScanner.scanBarcode(
                        '#C62828', // scanning line color
                        'Cancelar', // cancel button text
                        true, // whether to show the flash icon
                        ScanMode.BARCODE)
                    .then((value) async {
                  if (value != null && value.length > 4) {
                    ActivoController activoController = ActivoController();
                    var res = await activoController.buscarActivo(value);
                    if (res.idSerial.length < 4) {
                      // ignore: use_build_context_synchronously
                      context.pushNamed(
                        'registraractivopage',
                        queryParams: {
                          'idSerial': serializeParam(
                            value.trim().replaceAll(".", ""),
                            ParamType.String,
                          )
                        },
                      );
                    } else {
                      // ignore: use_build_context_synchronously
                      context.pushNamed(
                        'activoPerfilPage',
                        queryParams: {
                          'idActivo': serializeParam(
                            res.idSerial,
                            ParamType.String,
                          ),
                          'selectMode': serializeParam(
                            false,
                            ParamType.bool,
                          ),
                        },
                      );
                    }
                  }
                });
              },
            ),
            SpeedDialChild(
              child: Icon(Icons.add),
              backgroundColor: Color.fromARGB(255, 7, 133, 107),
              foregroundColor: Colors.white,
              label: 'Registrar nuevo activo',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => context.pushNamed(
                'registraractivopage',
                queryParams: {
                  'idSerial': serializeParam(
                    null,
                    ParamType.String,
                  )
                },
              ),
            ),
            SpeedDialChild(
              child: Icon(Icons.category_rounded),
              foregroundColor: Colors.white,
              backgroundColor: Color.fromARGB(255, 6, 113, 122),
              label: 'Crear nueva categoria',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => context.pushNamed('registrarcategoriapage'),
            ),

            //add more menu item childs here
          ],
        ),
      ),
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, _) => [
            SliverAppBar(
              pinned: true,
              floating: true,
              snap: true,
              backgroundColor: FlutterFlowTheme.of(context).primaryColor,
              iconTheme: IconThemeData(
                  color: FlutterFlowTheme.of(context).primaryText),
              automaticallyImplyLeading: false,
              title: AutoSizeText(
                'Activos',
                style: FlutterFlowTheme.of(context).bodyText1.override(
                      fontFamily: FlutterFlowTheme.of(context).bodyText1Family,
                      color: FlutterFlowTheme.of(context).whiteColor,
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      useGoogleFonts: GoogleFonts.asMap().containsKey(
                          FlutterFlowTheme.of(context).bodyText1Family),
                    ),
              ),
              actions: [],
              centerTitle: false,
              elevation: 4,
            )
          ],
          body: SafeArea(
            child: Builder(
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
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16, 0, 16, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 12, 0, 0),
                                            child: TextFormField(
                                              controller:
                                                  textControllerBusqueda,
                                              onChanged: (_) =>
                                                  EasyDebounce.debounce(
                                                'textController',
                                                Duration(milliseconds: 2000),
                                                () => setState(() {}),
                                              ),
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                labelText: 'Buscar activo...',
                                                labelStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyText2
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          color:
                                                              Color(0xFF57636C),
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyText2Family),
                                                        ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0x00000000),
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0x00000000),
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                filled: true,
                                                fillColor:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                prefixIcon: Icon(
                                                  Icons.search_rounded,
                                                  color: Color(0xFF57636C),
                                                ),
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyText1
                                                      .override(
                                                        fontFamily: 'Poppins',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        useGoogleFonts: GoogleFonts
                                                                .asMap()
                                                            .containsKey(
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyText1Family),
                                                      ),
                                              maxLines: null,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 12, 0, 44),
                                    child: FutureBuilder<List<Categoria>>(
                                        future:
                                            categoriaController.getCategorias(
                                                textControllerBusqueda!.text),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return _loading(context);
                                          } else if (snapshot.connectionState ==
                                                  ConnectionState.done &&
                                              snapshot.hasData &&
                                              snapshot.data!.isNotEmpty) {
                                            listCategoriasLocal.clear();
                                            snapshot.data!.forEach((data) {
                                              listCategoriasLocal.add(data);
                                              log('Añadiendo: ${data.nombre}');
                                              Text(data.nombre.toString());
                                            });

                                            return Wrap(
                                              spacing: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.01,
                                              runSpacing: 15,
                                              alignment: WrapAlignment.start,
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.start,
                                              direction: Axis.horizontal,
                                              runAlignment: WrapAlignment.start,
                                              verticalDirection:
                                                  VerticalDirection.down,
                                              clipBehavior: Clip.none,
                                              children: List.generate(
                                                  snapshot.data!.length,
                                                  (index) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    if (selectMode) {
                                                      context.replaceNamed(
                                                        'listaActivosPage',
                                                        queryParams: {
                                                          'nombreCategoria':
                                                              serializeParam(
                                                            snapshot
                                                                .data![index]
                                                                .nombre,
                                                            ParamType.String,
                                                          ),
                                                          'selectMode':
                                                              serializeParam(
                                                            selectMode,
                                                            ParamType.bool,
                                                          ),
                                                        }.withoutNulls,
                                                      );
                                                    } else {
                                                      context.pushNamed(
                                                        'listaActivosPage',
                                                        queryParams: {
                                                          'nombreCategoria':
                                                              serializeParam(
                                                            snapshot
                                                                .data![index]
                                                                .nombre,
                                                            ParamType.String,
                                                          ),
                                                          'selectMode':
                                                              serializeParam(
                                                            selectMode,
                                                            ParamType.bool,
                                                          ),
                                                        }.withoutNulls,
                                                      );
                                                    }
                                                  },
                                                  child: tarjetaCategoria(
                                                      context,
                                                      snapshot.data![index]),
                                                );
                                              }),
                                            );
                                          } else {
                                            return Container();
                                          }
                                        }),
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
        ),
      ),
    );
  }

  Widget tarjetaCategoria(context, Categoria categoria) {
    return Container(
      width: 350,
      height: 216,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: FlutterFlowTheme.of(context).boxShadow,
            offset: Offset(0, 2),
          )
        ],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: FlutterFlowTheme.of(context).secondaryText,
        ),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FastCachedImage(
                width: double.infinity,
                height: 125,
                url: categoria.urlImagen!,
                fit: BoxFit.cover,
                fadeInDuration: const Duration(seconds: 1),
                errorBuilder: (context, exception, stacktrace) {
                  log(stacktrace.toString());
                  return Image.asset(
                    'assets/images/nodisponible.png',
                    width: double.infinity,
                    height: 125,
                    fit: BoxFit.cover,
                  );
                },
                loadingBuilder: (context, progress) {
                  return Container(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (progress.isDownloading &&
                            progress.totalBytes != null)
                          Text(
                              '${progress.downloadedBytes ~/ 1024} / ${progress.totalBytes! ~/ 1024} kb',
                              style: const TextStyle(color: Color(0xFF006D38))),
                        SizedBox(
                            width: 120,
                            height: 120,
                            child: CircularProgressIndicator(
                                color: const Color(0xFF006D38),
                                value: progress.progressPercentage.value)),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(5, 6, 0, 0),
              child: Text(
                overflow: TextOverflow.ellipsis,
                categoria.nombre.toString(),
                style: FlutterFlowTheme.of(context).title3.override(
                                fontFamily: 'Poppins',
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context).title3Family),
                              ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(3, 2, 0, 1),
              child: Text(
                overflow: TextOverflow.clip,
                (categoria.descripcion == null) ? '' : categoria.descripcion!,
                style:  FlutterFlowTheme.of(context)
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
    );
  }

  Future<List<Categoria>> cargarCategorias() async {
    listCategoriasLocal =
        await categoriaController.getCategorias(busquedaCategoria);
    for (var element in listCategoriasLocal) {
      print('Lista categoria nombre: + ${element.nombre}');
      print('Lista categoria url: ${element.urlImagen}');
    }
    return Future.value(listCategoriasLocal);
  }

  Future<void> _guardarlistaLocal(List<Categoria>? listaOnline) async {
    final SharedPreferences prefs = await _prefs;

    if (listaOnline != null && listaOnline.isNotEmpty) {
      var listCategoriasJson = json.encode(listaOnline
          .map<Map<String, dynamic>>((categoria) => Categoria.toMap(categoria))
          .toList());
      await prefs.setString('listaCategorias', listCategoriasJson);
      log('Codificando listaCategoriasJson');
    }
  }

  Future<void> _cargarlistaLocal() async {
    final SharedPreferences prefs = await _prefs;
    final String? listaCategoriasJson = prefs.getString('listaCategorias');
    if (listaCategoriasJson != null) {
      setState(() {
        log('Decodificando listaCategoriasJson');
        listCategoriasLocal = Categoria.decode(listaCategoriasJson);
      });
    }
  }
}

Widget itemCategoria(BuildContext context, String? nombre, String? url,
    constraints, String descripcion, bool selectMode) {
  log("Dibujando item categoria");

  return GestureDetector(
    onTap: () {
      if (selectMode) {
        context.replaceNamed(
          'listaActivosPage',
          queryParams: {
            'nombreCategoria': serializeParam(
              nombre!,
              ParamType.String,
            ),
            'selectMode': serializeParam(
              selectMode,
              ParamType.bool,
            ),
          }.withoutNulls,
        );
      } else {
        context.pushNamed(
          'listaActivosPage',
          queryParams: {
            'nombreCategoria': serializeParam(
              nombre!,
              ParamType.String,
            ),
            'selectMode': serializeParam(
              selectMode,
              ParamType.bool,
            ),
          }.withoutNulls,
        );
      }
      log('Nombre Categoria: $nombre');
    },
    child: Padding(
      padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
      child: Container(
        //MediaQuery.of(context).size.width * 0.45,
        width: 10,
        height: 10,
        constraints: const BoxConstraints(
          maxWidth: 10,
          maxHeight: 10,
        ),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: FlutterFlowTheme.of(context).boxShadow,
              offset: const Offset(0, 2),
            )
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  url!,
                  width: double.infinity,
                  height: defTamanoImagen(constraints),
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8, 12, 0, 0),
                child: Text(
                  nombre!,
                  style: FlutterFlowTheme.of(context).subtitle1.override(
                        fontFamily: 'Outfit',
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                            FlutterFlowTheme.of(context).subtitle1Family),
                      ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8, 4, 0, 0),
                child: Text(
                  descripcion,
                  style: FlutterFlowTheme.of(context).bodyText2.override(
                        fontFamily: 'Outfit',
                        color: FlutterFlowTheme.of(context).grayicon,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                            FlutterFlowTheme.of(context).bodyText2Family),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

int defCantidadColumnas(screenSize) {
  if (screenSize > 440 && screenSize < 1057) {
    return 2;
  } else if (screenSize >= 1057 && screenSize < 1240) {
    return 3;
  } else if (screenSize >= 1240 && screenSize < 1500) {
    return 4;
  } else if (screenSize >= 1500 && screenSize < 1840) {
    return 5;
  } else if (screenSize >= 1840) {
    return 7;
  } else {
    return 1;
  }
}

double? defTamanoImagen(screenSize) {
  if (screenSize > 440 && screenSize < 640) {
    return 110;
  } else if (screenSize >= 640 && screenSize < 1057) {
    return 180;
  } else if (screenSize >= 1057 && screenSize < 1240) {
    return 170;
  } else if (screenSize >= 1240 && screenSize < 1370) {
    return 140;
  } else if (screenSize >= 1370 && screenSize < 1840) {
    return 135;
  } else if (screenSize >= 1840) {
    return 110;
  } else {
    return 180;
  }
}

Widget _loader(BuildContext context, String url) {
  return const Center(
    child: CircularProgressIndicator(),
  );
}

bool esEscritorio(BuildContext context) {
  return responsiveVisibility(context: context, desktop: true);
}

/*
webScraper() async {
  final webScraper = WebScraper('https://www.google.com');
  if (await webScraper.loadFullURL(
      'https://www.google.com/search?q=7709121771402&sourceid=chrome&ie=UTF-8')) {
    List<Map<String, dynamic>> elements =
        webScraper.getElement('div.yuRUbf > h3.LC20lb MBeuO DKV0Md', ['href']);
    log('SCRAPER: $elements');
  }
}
*/
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

Widget _loading(context) {
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

void validarVersion(BuildContext context, Logger logger) async {
  Version nulo = Version();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  RepositoryController repositoryController = RepositoryController();

  Version ultima_version_servidor = await repositoryController.buscarVersion();
  String version_local = packageInfo.version;
  String buildNumber = packageInfo.buildNumber;
  log('Version local: $version_local');
  log('Version servidor: ${ultima_version_servidor.version}');
  log('BuildNumber: $buildNumber');
  

  if (ultima_version_servidor.version.isNotEmpty) {
    if (ultima_version_servidor.version == '$version_local+$buildNumber') {
      log('El sistema esta actualizado');
    } else {
      log('Hay una acualizacion disponible');
      final result = await showOkAlertDialog(
      context: context,
      title: 'Actualización disponible',
      message: 'Hay una nueva versión disponible',
      okLabel: 'Actualizar',
      );
  logger.i(result.name.toString());
  if (result.name.toString() == 'ok') {
    // ignore: use_build_context_synchronously
    if(Platform.isAndroid){
      context.pushNamed(
      'actualizarPage',
      queryParams: {
        'url': serializeParam(
          ultima_version_servidor.urlAndroid,
          ParamType.String,
        ),
      },
    );
    }else{
      await launchURL(
                                                  ultima_version_servidor.urlWindows!);
    }
    
  }
    }
  } else {
    log('No se pudo determinar la version');
  }
  
}
