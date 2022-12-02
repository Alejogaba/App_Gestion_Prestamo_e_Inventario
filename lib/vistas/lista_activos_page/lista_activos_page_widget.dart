import 'dart:developer';

import 'package:app_gestion_prestamo_inventario/entidades/activo.dart';
import 'package:app_gestion_prestamo_inventario/entidades/categoria.dart';
import 'package:app_gestion_prestamo_inventario/servicios/activoController.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

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
  final String nombreCategoria;
  const ListaActivosPageWidget({Key? key, required this.nombreCategoria})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ListaActivosPageWidgetState createState() =>
      _ListaActivosPageWidgetState(this.nombreCategoria);
}

class _ListaActivosPageWidgetState extends State<ListaActivosPageWidget> {
  TextEditingController? textController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final String nombreCategoria;
  var id = '';
  var a;
  ActivoController activoController = ActivoController();
  List<Activo> listaActivos = [];

  _ListaActivosPageWidgetState(this.nombreCategoria);

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    log('CATEGORIA DE LA LISTA:$nombreCategoria');
  }

  @override
  void dispose() {
    textController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: activoController.getActivosStream(nombreCategoria),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
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
                foregroundColor:
                    Colors.white, //font color, icon color in button
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
                          .then((value) {
                        if (value != null) {
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
            body: NestedScrollView(
              headerSliverBuilder: (context, _) => [
                SliverAppBar(
                  pinned: true,
                  floating: false,
                  leading: InkWell(
                    onTap: () async {
                      context.pop();
                    },
                    child: Icon(
                      Icons.chevron_left_rounded,
                      color: FlutterFlowTheme.of(context).whiteColor,
                      size: 30,
                    ),
                  ),
                  backgroundColor: FlutterFlowTheme.of(context).primaryColor,
                  iconTheme: IconThemeData(
                      color: FlutterFlowTheme.of(context).primaryText),
                  automaticallyImplyLeading: false,
                  title: AutoSizeText(
                    nombreCategoria,
                    style: FlutterFlowTheme.of(context).bodyText1.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).bodyText1Family,
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
              body: Builder(
                builder: (context) {
                  return SafeArea(
                    child: GestureDetector(
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
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 12, 0, 0),
                                                child: TextFormField(
                                                  controller: textController,
                                                  onChanged: (_) =>
                                                      EasyDebounce.debounce(
                                                    'textController',
                                                    Duration(
                                                        milliseconds: 2000),
                                                    () => setState(() {}),
                                                  ),
                                                  obscureText: false,
                                                  decoration: InputDecoration(
                                                    labelText:
                                                        'Buscar funcionario...',
                                                    labelStyle: FlutterFlowTheme
                                                            .of(context)
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
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            Color(0x00000000),
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    focusedErrorBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            Color(0x00000000),
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    filled: true,
                                                    fillColor: FlutterFlowTheme
                                                            .of(context)
                                                        .secondaryBackground,
                                                    prefixIcon: Icon(
                                                      Icons.search_rounded,
                                                      color: Color(0xFF57636C),
                                                    ),
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
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
                                        child: StreamBuilder(
                                            stream: activoController
                                                .getActivosStream(
                                                    nombreCategoria),
                                            builder: (context,
                                                AsyncSnapshot<
                                                        List<
                                                            Map<String,
                                                                dynamic>>>
                                                    snapshot) {
                                              if (!snapshot.hasData ||
                                                  snapshot.hasError ||
                                                  snapshot.data!.isEmpty)
                                                return Container();
                                              snapshot.data!.forEach((data) {
                                                listaActivos
                                                    .add(Activo.fromMap(data));
                                                log('Añadiendo activo: ${Activo.fromMap(data).nombre}');
                                                Text(Activo.fromMap(data)
                                                    .nombre
                                                    .toString());
                                              });
                                              return Wrap(
                                                spacing: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.05,
                                                runSpacing: 10,
                                                alignment: WrapAlignment.start,
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.start,
                                                direction: Axis.horizontal,
                                                runAlignment:
                                                    WrapAlignment.start,
                                                verticalDirection:
                                                    VerticalDirection.down,
                                                clipBehavior: Clip.none,
                                                children: List.generate(
                                                    snapshot.data!.length,
                                                    (index) {
                                                  return tarjetaActivo(
                                                      context, Activo.fromMap(snapshot
                                                              .data![index])
                                                          .idSerial,
                                                      Activo.fromMap(snapshot
                                                              .data![index])
                                                          .nombre,Activo.fromMap(snapshot
                                                              .data![index])
                                                          .urlImagen,Activo.fromMap(snapshot
                                                              .data![index])
                                                          .estado);
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
                    ),
                  );
                },
              ),
            ),
          );
        });
  }
}

Widget tarjetaActivo(context,String idSerial, String? nombre, String? urlImagen, int? estadoActivo) {
  return Container(
    width: 210,
    height: 215,
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
                  urlImagen!,
                  width: double.infinity,
                  height: 125,
                  fit: BoxFit.cover,
                ),
      ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(5, 6, 0, 0),
            child: Text(
              nombre.toString(),
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
                  idSerial,
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
                  color: definirColorEstado(estadoActivo),
                  size: 10,
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(3, 3, 0, 5),
                child: Text(
                  definirEstadoActivo(estadoActivo).toString(),
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

Color? definirColorEstado(int? estado) {
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

String? definirEstadoActivo(int? estado) {
  switch (estado) {
    case 0:
      return 'Bueno';

    case 1:
      return 'Regular';

    case 2:
      return 'Malo';

    default:
      return 'No definido';
  }
}
