import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:app_gestion_prestamo_inventario/entidades/activo.dart';
import 'package:app_gestion_prestamo_inventario/entidades/funcionario.dart';
import 'package:app_gestion_prestamo_inventario/servicios/prestamosController.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../entidades/area.dart';
import '../../servicios/funcionariosController.dart';
import '../components/rango_fechas_widget.dart';
import '../flutter_flow/flutter_flow_count_controller.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class RegistrarPrestamoPageWidget extends StatefulWidget {
  const RegistrarPrestamoPageWidget({Key? key}) : super(key: key);

  @override
  _RegistrarPrestamoPageWidgetState createState() =>
      _RegistrarPrestamoPageWidgetState();
}

class _RegistrarPrestamoPageWidgetState
    extends State<RegistrarPrestamoPageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int? countControllerValue;
  List<Activo> listActivos = [];
  List<TextEditingController> listaControladores = [];
  TextEditingController controladorObservacion = TextEditingController();
  Funcionario? funcionario;
  Area area = Area(id: 1, nombre: 'Área', urlImagen: '');
  bool _errorColor = false;
  bool blur = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('FloatingActionButton pressed ...');
        },
        backgroundColor: _errorColor
            ? Colors.redAccent
            : FlutterFlowTheme.of(context).primaryColor,
        elevation: 8,
        child: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30,
          borderWidth: 1,
          buttonSize: 60,
          icon: FaIcon(
            _errorColor ? Icons.error : FontAwesomeIcons.solidFloppyDisk,
            color: FlutterFlowTheme.of(context).whiteColor,
            size: 30,
          ),
          onPressed: () async {
            if (funcionario != null && listActivos.isNotEmpty) {
              setState(() {
                blur = true;
              });
              SharedPreferences prefs = await SharedPreferences.getInstance();
              String? fecha_inicio = prefs.getString('fecha_incio');
              String? fecha_fin = prefs.getString('fecha_fin');

              PrestamosController prestamosController = PrestamosController();
              List<String> listaRespuesta = [];

              listActivos.forEach((activo) async {
                String result = await prestamosController.registrarPrestamo(
                    context, activo.idSerial, funcionario!.cedula, fecha_inicio,
                    fechaHoraFinal: fecha_fin);
                listaRespuesta.add(result);
              });

              String res = '';

              if (listaRespuesta.every((element) => element == 'ok')) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    "Prestamos registrados con exitó",
                    style: FlutterFlowTheme.of(context).bodyText2.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).bodyText2Family,
                          color: FlutterFlowTheme.of(context).whiteColor,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).bodyText2Family),
                        ),
                  ),
                  backgroundColor: FlutterFlowTheme.of(context).primaryColor,
                ));
                setState(() {
                  blur = false;
                });
                Timer(Duration(seconds: 3), () {
                  context.pop();
                });
              }
            } else if (funcionario == null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  "Seleccione la persona a la que se prestara el activo",
                  style: FlutterFlowTheme.of(context).bodyText2.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).bodyText2Family,
                        color: FlutterFlowTheme.of(context).whiteColor,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                            FlutterFlowTheme.of(context).bodyText2Family),
                      ),
                ),
                backgroundColor: Colors.redAccent,
              ));
              setState(() {
                _errorColor = true;
                blur = false;
              });
              Future.delayed(const Duration(milliseconds: 6000), () {
                setState(() {
                  _errorColor = false;
                });
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  "Seleccioner por lo menos un activo",
                  style: FlutterFlowTheme.of(context).bodyText2.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).bodyText2Family,
                        color: FlutterFlowTheme.of(context).whiteColor,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                            FlutterFlowTheme.of(context).bodyText2Family),
                      ),
                ),
                backgroundColor: Colors.redAccent,
              ));
              log('rojo');
              setState(() {
                _errorColor = true;
                blur = false;
              });
              Future.delayed(const Duration(milliseconds: 6000), () {
                setState(() {
                  _errorColor = false;
                });
              });
            }
          },
        ),
      ),
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryColor,
        iconTheme:
            IconThemeData(color: FlutterFlowTheme.of(context).whiteColor),
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () async {
            context.pop();
          },
          child: Icon(
            Icons.chevron_left_rounded,
            color: FlutterFlowTheme.of(context).primaryText,
            size: 30,
          ),
        ),
        title: Text(
          'Nuevo préstamo',
          textAlign: TextAlign.start,
          style: FlutterFlowTheme.of(context).subtitle1.override(
                fontFamily: FlutterFlowTheme.of(context).subtitle1Family,
                color: FlutterFlowTheme.of(context).primaryText,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).subtitle1Family),
              ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 5, 10, 5),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Activos a prestar',
                          style: FlutterFlowTheme.of(context)
                              .bodyText1
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyText1Family,
                                fontSize: 18,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyText1Family),
                              ),
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: listActivos.length,
                    itemBuilder: (BuildContext context, int index) {
                      listaControladores.add(TextEditingController());
                      return _tarjetaActivo(
                          listActivos[index], listaControladores[index]);
                    },
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 25, 0, 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final Activo? result =
                                  await context.pushNamed<Activo>(
                                'listaActivosPage',
                                queryParams: {
                                  'nombreCategoria': serializeParam(
                                    'Todos los activos',
                                    ParamType.String,
                                  ),
                                  'selectMode': serializeParam(
                                    true,
                                    ParamType.bool,
                                  ),
                                  'esPrestamo': serializeParam(
                                    true,
                                    ParamType.bool,
                                  ),
                                },
                              );
                              if (result != null) {
                                Logger().i('Activo devuelto:${result.nombre}');
                                var contain = listActivos.where((element) =>
                                    element.idSerial == result.idSerial);
                                if (contain.isEmpty) {
                                  setState(() {
                                    listActivos.add(result);
                                  });
                                }
                              }
                            },
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 3,
                                      color: FlutterFlowTheme.of(context)
                                          .boxShadow,
                                      spreadRadius: 1,
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      8, 8, 8, 8),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 1, 1, 1),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: Image.network(
                                            'https://www.iconsdb.com/icons/preview/light-gray/plus-4-xxl.png',
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  8, 2, 4, 0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Añadir activo',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .title3
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .title3Family),
                                                        ),
                                              ),
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  6, 0, 0, 6),
                                                      child: Icon(
                                                        Icons.touch_app,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        size: 30,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  5, 8, 8, 0),
                                                      child: AutoSizeText(
                                                        'Toca para seleccionar',
                                                        textAlign:
                                                            TextAlign.start,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyText2
                                                                .override(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyText2Family),
                                                                ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 4, 0, 0),
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
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0x94ABB3BA),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 16, 10, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'A quien se le prestará',
                          style: FlutterFlowTheme.of(context)
                              .bodyText1
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyText1Family,
                                fontSize: 18,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyText1Family),
                              ),
                        ),
                      ],
                    ),
                  ),
                  (funcionario != null)
                      ? GestureDetector(
                          onTap: () async {
                            final Funcionario? result =
                                await context.pushNamed<Funcionario>(
                              'listaSeleccionFuncionariosPage',
                            );
                            if (result != null) {
                              Logger().i('Activo devuelto:${result.nombres}');
                              await FastCachedImageConfig.deleteCachedImage(
                                  imageUrl: funcionario!.urlImagen);
                              setState(() {
                                funcionario = result;
                              });
                              await Future.delayed(const Duration(seconds: 2),
                                  () => setState(() {}));
                            }
                          },
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 5, 0, 12),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        5, 5, 5, 5),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 3,
                                            color: FlutterFlowTheme.of(context)
                                                .boxShadow,
                                            spreadRadius: 1,
                                          )
                                        ],
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            8, 8, 8, 8),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 1, 1, 1),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                child: FastCachedImage(
                                                  cacheHeight: 80,
                                                  cacheWidth: 80,
                                                  width: 80,
                                                  height: 80,
                                                  url: funcionario!.urlImagen,
                                                  fit: BoxFit.cover,
                                                  fadeInDuration:
                                                      const Duration(
                                                          seconds: 1),
                                                  errorBuilder: (context,
                                                      exception, stacktrace) {
                                                    log(stacktrace.toString());
                                                    return Image.asset(
                                                      'assets/images/nodisponible.png',
                                                      width: 80,
                                                      height: 80,
                                                      fit: BoxFit.cover,
                                                    );
                                                  },
                                                  loadingBuilder:
                                                      (context, progress) {
                                                    return Container(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      child: Stack(
                                                        alignment:
                                                            Alignment.center,
                                                        children: [
                                                          if (progress
                                                                  .isDownloading &&
                                                              progress.totalBytes !=
                                                                  null)
                                                            Text(
                                                                '${progress.downloadedBytes ~/ 1024} / ${progress.totalBytes! ~/ 1024} kb',
                                                                style: const TextStyle(
                                                                    color: Color(
                                                                        0xFF006D38))),
                                                          SizedBox(
                                                              width: 70,
                                                              height: 70,
                                                              child: CircularProgressIndicator(
                                                                  color: const Color(
                                                                      0xFF006D38),
                                                                  value: progress
                                                                      .progressPercentage
                                                                      .value)),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(8, 2, 4, 0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      (funcionario!.apellidos !=
                                                                  null &&
                                                              funcionario!
                                                                  .apellidos!
                                                                  .isNotEmpty)
                                                          ? '${funcionario!.nombres.split(' ')[0]} ${funcionario!.apellidos!.split(' ')[0]}'
                                                          : funcionario!
                                                              .nombres,
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .title3
                                                              .override(
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                useGoogleFonts: GoogleFonts
                                                                        .asMap()
                                                                    .containsKey(
                                                                        FlutterFlowTheme.of(context)
                                                                            .title3Family),
                                                              ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0, 3, 8, 0),
                                                      child: AutoSizeText(
                                                        funcionario!.cargo,
                                                        textAlign:
                                                            TextAlign.start,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyText2
                                                                .override(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .grayicon,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyText2Family),
                                                                ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0, 4, 8, 0),
                                                      child:
                                                          FutureBuilder<Area>(
                                                        future: cargarArea(
                                                            funcionario!
                                                                .idArea),
                                                        initialData: area,
                                                        builder: ((context,
                                                            snapshot) {
                                                          area = snapshot.data!;
                                                          return AutoSizeText(
                                                            snapshot
                                                                .data!.nombre,
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyText2
                                                                .override(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .grayicon,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyText2Family),
                                                                ),
                                                          );
                                                        }),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 4, 0, 0),
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
                                ),
                              ],
                            ),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 25, 0, 12),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    final Funcionario? result =
                                        await context.pushNamed<Funcionario>(
                                      'listaSeleccionFuncionariosPage',
                                    );
                                    if (result != null) {
                                      Logger().i(
                                          'Activo devuelto:${result.nombres}');

                                      setState(() {
                                        funcionario = result;
                                      });
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        5, 5, 5, 5),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 3,
                                            color: FlutterFlowTheme.of(context)
                                                .boxShadow,
                                            spreadRadius: 1,
                                          )
                                        ],
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            8, 8, 8, 8),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 1, 1, 1),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                child: Image.network(
                                                  'https://www.iconsdb.com/icons/preview/light-gray/plus-4-xxl.png',
                                                  width: 80,
                                                  height: 80,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(8, 2, 4, 0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Seleccionar funcionario',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .title3
                                                              .override(
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                useGoogleFonts: GoogleFonts
                                                                        .asMap()
                                                                    .containsKey(
                                                                        FlutterFlowTheme.of(context)
                                                                            .title3Family),
                                                              ),
                                                    ),
                                                    FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        6,
                                                                        0,
                                                                        0,
                                                                        6),
                                                            child: Icon(
                                                              Icons.touch_app,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryText,
                                                              size: 30,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        5,
                                                                        8,
                                                                        8,
                                                                        0),
                                                            child: AutoSizeText(
                                                              'Toca para seleccionar',
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyText2
                                                                  .override(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primaryText,
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    useGoogleFonts: GoogleFonts
                                                                            .asMap()
                                                                        .containsKey(
                                                                            FlutterFlowTheme.of(context).bodyText2Family),
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 4, 0, 0),
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
                                ),
                              ),
                            ],
                          ),
                        ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0x94ABB3BA),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                    child: Text(
                      'Duración',
                      style: FlutterFlowTheme.of(context).bodyText1.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyText1Family,
                            fontSize: 18,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context).bodyText1Family),
                          ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: RangoFechasWidget(),
                        ),
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(25)),
                  Divider(
                    height: 2,
                    thickness: 1,
                    color: FlutterFlowTheme.of(context).lineColor,
                  ),
                ],
              ),
            ),
          ),
          if (blur)
            ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 4,
                  sigmaY: 4,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: CircularProgressIndicator(
                          color: FlutterFlowTheme.of(context).primaryColor,
                          strokeWidth: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _tarjetaActivo(
      Activo activo, TextEditingController controladorObservacion) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
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
                      borderRadius: BorderRadius.circular(6),
                      child: FastCachedImage(
                        width: 80,
                        height: 80,
                        url: activo.urlImagen,
                        fit: BoxFit.cover,
                        fadeInDuration: const Duration(seconds: 1),
                        errorBuilder: (context, exception, stacktrace) {
                          log(stacktrace.toString());
                          return Image.asset(
                            'assets/images/nodisponible.png',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          );
                        },
                        loadingBuilder: (context, progress) {
                          return Container(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
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
                            activo.nombre,
                            overflow: TextOverflow.ellipsis,
                            style: FlutterFlowTheme.of(context).title3.override(
                                  fontFamily: 'Poppins',
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .title3Family),
                                ),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      6, 0, 0, 0),
                                  child: FaIcon(
                                    FontAwesomeIcons.barcode,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    size: 18,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      5, 3, 8, 1),
                                  child: AutoSizeText(
                                    'S/N: ${activo.idSerial}',
                                    textAlign: TextAlign.start,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText2
                                        .override(
                                          fontFamily: 'Poppins',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyText2Family),
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 0, 0),
                                  child: FaIcon(
                                    FontAwesomeIcons.boxOpen,
                                    color: Color(0xFFAD8762),
                                    size: 18,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      5, 3, 8, 1),
                                  child: AutoSizeText(
                                    'N° inventario: ${(activo.numActivo!.isEmpty) ? 'No registrado' : activo.numActivo}',
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText2
                                        .override(
                                          fontFamily: 'Poppins',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyText2Family),
                                        ),
                                  ),
                                ),
                              ],
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
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16, 9, 16, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Observación: ',
                    style: FlutterFlowTheme.of(context).bodyText1.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).bodyText1Family,
                          fontSize: 18,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).bodyText1Family),
                        ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: TextFormField(
                        controller: controladorObservacion,
                        autofocus: true,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelStyle: FlutterFlowTheme.of(context)
                              .bodyText2
                              .override(
                                fontFamily: 'Poppins',
                                color: Color(0xFF57636C),
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyText2Family),
                              ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).grayicon,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primaryText,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        style: FlutterFlowTheme.of(context).bodyText1,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Future<Area> cargarArea(id) async {
  FuncionariosController funcionariosController = FuncionariosController();
  Area area = await funcionariosController.buscarArea(id.toString());
  return area;
}
