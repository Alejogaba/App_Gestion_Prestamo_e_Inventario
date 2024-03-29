import 'dart:developer';

import 'dart:io';

import 'package:app_gestion_prestamo_inventario/entidades/activo.dart';
import 'package:app_gestion_prestamo_inventario/entidades/categoria.dart';
import 'package:app_gestion_prestamo_inventario/index.dart';
import 'package:app_gestion_prestamo_inventario/servicios/activoController.dart';
import 'package:app_gestion_prestamo_inventario/servicios/categoriaController.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:logger/logger.dart';

import '../../servicios/pdfApi.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ListaActivosPageWidget extends StatefulWidget {
  final int idCategoria;
  final bool selectMode;
  final bool esPrestamo;
  final bool escogerComponente;
  const ListaActivosPageWidget(
      {Key? key,
      required this.idCategoria,
      this.selectMode = false,
      this.esPrestamo = false,
      this.escogerComponente = false})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ListaActivosPageWidgetState createState() => _ListaActivosPageWidgetState(
      this.idCategoria,
      this.selectMode,
      this.esPrestamo,
      this.escogerComponente);
}

class _ListaActivosPageWidgetState extends State<ListaActivosPageWidget> {
  TextEditingController? textControllerBusqueda;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final int idCategoria;
  var id = '';
  var a;
  ActivoController activoController = ActivoController();
  List<Activo> listaActivos = [];
  bool selectMode;
  bool esPrestamo;
  Categoria categoria = Categoria('Activos', '', '');
  bool escogerComponente;
  _ListaActivosPageWidgetState(this.idCategoria, this.selectMode,
      this.esPrestamo, this.escogerComponente);

  @override
  void initState() {
    super.initState();
    cargarCategoria(idCategoria);
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
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
            if (Platform.isAndroid || Platform.isIOS)
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
                    if (value.length > 3) {
                      ActivoController activoController = ActivoController();
                      var res = await activoController.buscarActivo(value);
                      if (res.idSerial.length < 4) {
                        // ignore: use_build_context_synchronously
                        final e = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResgistrarActivoPageWidget(
                              idSerial: value.trim().replaceAll(".", ""),
                              idCategoria: 2,
                            ),
                          ),
                        ).then((value) {
                          Future.delayed(Duration(milliseconds: 500), () {
                            setState(() {});
                          });
                        });
                      } else {
                        // ignore: use_build_context_synchronously
                        final e = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ActivoPerfilPageWidget(
                              activo: res,
                              selectMode: selectMode,
                              esPrestamo: esPrestamo,
                              escogerComponente: escogerComponente,
                            ),
                          ),
                        ).then((value) {
                          Future.delayed(Duration(milliseconds: 500), () {
                            setState(() {});
                          });
                        });
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
                onTap: () async {
                  final e = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResgistrarActivoPageWidget(idCategoria: idCategoria),
                    ),
                  ).then((value) {
                    Future.delayed(Duration(milliseconds: 500), () {
                      setState(() {});
                    });
                  });
                }),
            SpeedDialChild(
              child: Icon(Icons.category_rounded),
              foregroundColor: Colors.white,
              backgroundColor: Color.fromARGB(255, 6, 113, 122),
              label: 'Crear nueva categoria',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () async => await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegistrarCategoriaPageWidget(
                        ),
                      ),
                    ).then((value) {
                          Future.delayed(Duration(milliseconds: 500), () {
                            setState(() {});
                          });
                        }),
            ),

            //add more menu item childs here
          ],
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            pinned: true,
            floating: false,
            leading: InkWell(
              onTap: () async {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.chevron_left_rounded,
                color: FlutterFlowTheme.of(context).whiteColor,
                size: 30,
              ),
            ),
            backgroundColor: FlutterFlowTheme.of(context).primaryColor,
            iconTheme:
                IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
            automaticallyImplyLeading: false,
            title: AutoSizeText(
              categoria.nombre.toString(),
              style: FlutterFlowTheme.of(context).bodyText1.override(
                    fontFamily: FlutterFlowTheme.of(context).bodyText1Family,
                    color: FlutterFlowTheme.of(context).whiteColor,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    useGoogleFonts: GoogleFonts.asMap().containsKey(
                        FlutterFlowTheme.of(context).bodyText1Family),
                  ),
            ),
            actions: [
              FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 30,
                borderWidth: 1,
                buttonSize: 60,
                icon: FaIcon(
                  FontAwesomeIcons.filePdf,
                  color: FlutterFlowTheme.of(context).whiteColor,
                  size: 30,
                ),
                onPressed: () async {
                  await PdfApi().generarTablaActivo(listaActivos,
                      tipoActivo: categoria.nombre
                          .toString()); // PdfApi.generarTablaActivo(listaActivos, tipoActivo: nombreCategoria);
                },
              ),
              if (idCategoria > 9 && listaActivos.length == 0)
                FlutterFlowIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 30,
                  borderWidth: 1,
                  buttonSize: 60,
                  icon: FaIcon(
                    FontAwesomeIcons.penToSquare,
                    color: FlutterFlowTheme.of(context).whiteColor,
                    size: 30,
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegistrarCategoriaPageWidget(
                          categoriaEditar: categoria,
                        ),
                      ),
                    ).then((value) {
                          Future.delayed(Duration(milliseconds: 500), () {
                            setState(() {});
                          });
                        }); // PdfApi.generarTablaActivo(listaActivos, tipoActivo: nombreCategoria);
                  },
                ),
            ],
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
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16, 0, 16, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 12, 0, 0),
                                        child: TextFormField(
                                          controller: textControllerBusqueda,
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
                                                      color: Color(0xFF57636C),
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
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context)
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
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText1
                                              .override(
                                                fontFamily: 'Poppins',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                fontSize: 18,
                                                fontWeight: FontWeight.normal,
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
                                child: FutureBuilder<List<Activo>>(
                                    future: activoController.getActivosList(
                                        textControllerBusqueda!.text,
                                        idCategoria),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData ||
                                          snapshot.hasError ||
                                          snapshot.data!.isEmpty)
                                        return Container();

                                      listaActivos.clear();
                                      snapshot.data!.forEach((data) {
                                        listaActivos.add(data);
                                        log('Añadiendo activo: ${data.nombre}');
                                        Text(data.nombre.toString());
                                      });

                                      return Wrap(
                                        spacing:
                                            MediaQuery.of(context).size.width *
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
                                            snapshot.data!.length, (index) {
                                          return GestureDetector(
                                            onTap: () async {
                                              if (selectMode) {
                                                if (esPrestamo == false &&
                                                    snapshot.data![index]
                                                            .estaAsignado ==
                                                        false) {
                                                  context.replaceNamed(
                                                    'activoPerfilPage',
                                                    queryParams: {
                                                      'activo': serializeParam(
                                                        snapshot.data![index],
                                                        ParamType.Activo,
                                                      ),
                                                      'selectMode':
                                                          serializeParam(
                                                        selectMode,
                                                        ParamType.bool,
                                                      ),
                                                      'esPrestamo':
                                                          serializeParam(
                                                        esPrestamo,
                                                        ParamType.bool,
                                                      ),
                                                    },
                                                  );
                                                } else if (esPrestamo == true &&
                                                    snapshot.data![index]
                                                            .estaPrestado ==
                                                        false) {
                                                  final Activo? result =
                                                      await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ActivoPerfilPageWidget(
                                                        activo: snapshot
                                                            .data![index],
                                                        selectMode: selectMode,
                                                        esPrestamo: selectMode,
                                                        escogerComponente:
                                                            escogerComponente,
                                                      ),
                                                    ),
                                                  );

                                                  if (result != null) {
                                                    // ignore: use_build_context_synchronously
                                                    Navigator.pop(
                                                        context, result);
                                                  }
                                                }
                                              } else {
                                                final Activo? result =
                                                    await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ActivoPerfilPageWidget(
                                                      activo:
                                                          snapshot.data![index],
                                                      selectMode: selectMode,
                                                      esPrestamo: esPrestamo,
                                                      escogerComponente:
                                                          escogerComponente,
                                                    ),
                                                  ),
                                                );
                                                if (result != null) {
                                                  // ignore: use_build_context_synchronously
                                                  Navigator.pop(
                                                      context, result);
                                                } else {
                                                  setState(() {});
                                                }
                                              }
                                            },
                                            child: Opacity(
                                              opacity: ((esPrestamo &&
                                                          selectMode &&
                                                          snapshot.data![index]
                                                              .estaPrestado) ||
                                                      (selectMode &&
                                                          !esPrestamo &&
                                                          snapshot.data![index]
                                                              .estaAsignado))
                                                  ? 0.4
                                                  : 1.0,
                                              child: tarjetaActivo(context,
                                                  snapshot.data![index],
                                                  selectMode: selectMode,
                                                  esPrestamos: esPrestamo,
                                                  estaAsignado: snapshot
                                                      .data![index]
                                                      .estaAsignado,
                                                  estaPrestado: snapshot
                                                      .data![index]
                                                      .estaPrestado),
                                            ),
                                          );
                                        }),
                                      );
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
    );
  }

  Future<void> cargarCategoria(id) async {
    CategoriaController categoriaController = CategoriaController();
    var res = await categoriaController.buscarCategoriaID(idCategoria);
    setState(() {
      categoria = res;
    });
  }
}

Widget tarjetaActivo(context, Activo activo,
    {bool selectMode = false,
    bool esPrestamos = false,
    bool estaPrestado = false,
    bool estaAsignado = false}) {
  return Container(
    width: 185,
    height: 213,
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
            child: Image.network(
              activo.urlImagen,
              width: double.infinity,
              height: 125,
              fit: BoxFit.cover,
              errorBuilder: (context, exception, stacktrace) {
                log(stacktrace.toString());
                return Image.asset(
                  'assets/images/nodisponible.png',
                  width: double.infinity,
                  height: 125,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(5, 6, 0, 0),
            child: Text(
              overflow: TextOverflow.ellipsis,
              activo.nombre.toString(),
              style: FlutterFlowTheme.of(context).subtitle1,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                child: FaIcon(
                  FontAwesomeIcons.barcode,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 15,
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(3, 3, 0, 1),
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  activo.idSerial,
                  style: FlutterFlowTheme.of(context).bodyText2.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).bodyText2Family,
                        color: FlutterFlowTheme.of(context).grayicon,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                            FlutterFlowTheme.of(context).bodyText2Family),
                      ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                child: FaIcon(
                  FontAwesomeIcons.solidCircle,
                  color: definirColorEstado(activo.estado,
                      selectMode: selectMode,
                      esPrestamos: esPrestamos,
                      estaAsignado: estaAsignado,
                      estaPrestado: estaPrestado),
                  size: 10,
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(3, 3, 0, 5),
                child: Text(
                  definirEstadoActivo(activo.estado,
                          selectMode: selectMode,
                          esPrestamos: esPrestamos,
                          estaAsignado: estaAsignado,
                          estaPrestado: estaPrestado)
                      .toString(),
                  style: FlutterFlowTheme.of(context).bodyText2.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).bodyText2Family,
                        color: FlutterFlowTheme.of(context).grayicon,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                            FlutterFlowTheme.of(context).bodyText2Family),
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

double? defTamanoImagen(screenSize) {
  if (screenSize > 440 && screenSize < 640) {
    return 82;
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

Color? definirColorEstado(int? estado,
    {bool selectMode = false,
    bool esPrestamos = false,
    bool estaPrestado = false,
    bool estaAsignado = false}) {
  if ((selectMode && !esPrestamos && !estaAsignado) ||
      (selectMode && esPrestamos && !estaPrestado)) {
    estado = 0;
  } else if ((selectMode && !esPrestamos && estaAsignado) ||
      (selectMode && esPrestamos && estaPrestado)) {
    estado = 2;
  }
  switch (estado) {
    case 0:
      return Colors.green;

    case 1:
      return Colors.yellow;

    case 2:
      return Colors.red;

    default:
      return Colors.grey;
  }
}

String? definirEstadoActivo(int? estado,
    {bool selectMode = false,
    bool esPrestamos = false,
    bool estaPrestado = false,
    bool estaAsignado = false}) {
  if ((selectMode && !esPrestamos && !estaAsignado) ||
      (selectMode && esPrestamos && !estaPrestado)) {
    estado = 3;
  } else if ((selectMode && !esPrestamos && estaAsignado) ||
      (selectMode && esPrestamos && estaPrestado)) {
    estado = 4;
  }
  switch (estado) {
    case 0:
      return 'Bueno';

    case 1:
      return 'Regular';

    case 2:
      return 'Malo';

    case 3:
      return 'Disponible';

    case 4:
      return 'Ocupado';

    default:
      return 'No definido';
  }
}
