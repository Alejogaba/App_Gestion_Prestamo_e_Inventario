import 'dart:developer';
import 'dart:ui';

import 'package:app_gestion_prestamo_inventario/entidades/activo_funcionario.dart';
import 'package:app_gestion_prestamo_inventario/entidades/funcionario.dart';
import 'package:app_gestion_prestamo_inventario/entidades/prestamo.dart';
import 'package:app_gestion_prestamo_inventario/servicios/activoController.dart';
import 'package:app_gestion_prestamo_inventario/servicios/funcionariosController.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../entidades/activo.dart';
import '../../entidades/area.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../../flutter_flow/nav/serialization_util.dart';
import '../../servicios/prestamosController.dart';
import '../flutter_flow/flutter_flow_animations.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../custom_code/actions/index.dart' as actions;
import '../flutter_flow/custom_functions.dart' as functions;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class FuncionarioPerfilPageWidget extends StatefulWidget {
  final Funcionario funcionario;
  final Area area;
  final bool? selectMode;
  const FuncionarioPerfilPageWidget(
      {Key? key,
      required this.funcionario,
      required this.area,
      this.selectMode})
      : super(key: key);

  @override
  _FuncionarioPerfilPageWidgetState createState() =>
      _FuncionarioPerfilPageWidgetState(
          this.funcionario, this.area, this.selectMode);
}

class _FuncionarioPerfilPageWidgetState
    extends State<FuncionarioPerfilPageWidget> with TickerProviderStateMixin {
  final animationsMap = {
    'containerOnPageLoadAnimation1': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 1500.ms,
          begin: Offset(-2000, 0),
          end: Offset(0, 0),
        ),
      ],
    ),
    'containerOnPageLoadAnimation2': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        MoveEffect(
          curve: Curves.easeOut,
          delay: 1500.ms,
          duration: 2000.ms,
          begin: Offset(0, 1000),
          end: Offset(0, 0),
        ),
      ],
    ),
  };
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Funcionario funcionario;
  Area area;
  bool blur = false;
  ActivoController activoController = ActivoController();
  bool? selectMode;

  _FuncionarioPerfilPageWidgetState(
      this.funcionario, this.area, this.selectMode);

  @override
  void initState() {
    super.initState();
    Logger().i('FUNCIONARIO TIENE ACTIVOS: ${funcionario.tieneActivos}');
    cargarActivosAsignados(funcionario.cedula);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // ignore: use_build_context_synchronously
          if (selectMode != null && selectMode == true) {
            try {
              context.pop(funcionario);
            } catch (e) {
              Logger().e('Error en context.pop');
            }
            
          } else {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('id_funcionario', funcionario.cedula);
            Logger().i('Antes del push');
            // ignore: use_build_context_synchronously
            context.pushNamed(
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
              }.withoutNulls,
            );
          }
        },
        backgroundColor: FlutterFlowTheme.of(context).primaryColor,
        icon: Icon(
          Icons.add_rounded,
          color: FlutterFlowTheme.of(context).whiteColor,
          size: 24,
        ),
        elevation: 8,
        label: Text(
          (selectMode != null && selectMode!)
              ? 'Seleccionar funcionario'
              : 'Asignar activo',
          style: FlutterFlowTheme.of(context).bodyText1.override(
                fontFamily: FlutterFlowTheme.of(context).bodyText1Family,
                color: FlutterFlowTheme.of(context).whiteColor,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).bodyText1Family),
              ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: GestureDetector(
                    onTap: (() {
                      setState(() {
                        blur = false;
                      });
                    }),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 260,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryColor,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        24, 0, 0, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment: AlignmentDirectional(0, 0),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 25, 0, 10),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 24, 0),
                                                  child: Container(
                                                    width: 40,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .primaryBackground,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      border: Border.all(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child:
                                                        FlutterFlowIconButton(
                                                      borderColor:
                                                          Colors.transparent,
                                                      borderRadius: 30,
                                                      buttonSize: 46,
                                                      fillColor:
                                                          Color(0x00F1F4F8),
                                                      icon: Icon(
                                                        Icons.delete_outlined,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        size: 22,
                                                      ),
                                                      onPressed: () {},
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0, 0, 24, 0),
                                                      child: InkWell(
                                                        onTap: () async {
                                                          (selectMode != null &&
                                                                  selectMode!)
                                                              ? log(
                                                                  'asignar button')
                                                              : context
                                                                  .pushNamed(
                                                                  'RegistrarFuncionarioPage',
                                                                  queryParams: {
                                                                    'editMode':
                                                                        serializeParam(
                                                                      true,
                                                                      ParamType
                                                                          .bool,
                                                                    ),
                                                                  }.withoutNulls,
                                                                  extra: <
                                                                      String,
                                                                      dynamic>{
                                                                    kTransitionInfoKey:
                                                                        TransitionInfo(
                                                                      hasTransition:
                                                                          true,
                                                                      transitionType:
                                                                          PageTransitionType
                                                                              .fade,
                                                                      duration: Duration(
                                                                          milliseconds:
                                                                              1000),
                                                                    ),
                                                                  },
                                                                );
                                                        },
                                                        child: Container(
                                                          width: 40,
                                                          height: 40,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryBackground,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryText,
                                                              width: 1,
                                                            ),
                                                          ),
                                                          child:
                                                              FlutterFlowIconButton(
                                                            borderColor: Colors
                                                                .transparent,
                                                            borderRadius: 30,
                                                            buttonSize: 46,
                                                            fillColor: Color(
                                                                0x00F1F4F8),
                                                            icon: Icon(
                                                              Icons.edit,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryText,
                                                              size: 16,
                                                            ),
                                                            onPressed: () {
                                                              print(
                                                                  'IconButton pressed ...');
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0, 0, 24, 0),
                                                      child: InkWell(
                                                        onTap: () async {
                                                          context.pop();
                                                        },
                                                        child: Container(
                                                          width: 40,
                                                          height: 40,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryBackground,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryText,
                                                              width: 1,
                                                            ),
                                                          ),
                                                          child:
                                                              FlutterFlowIconButton(
                                                            borderColor: Colors
                                                                .transparent,
                                                            borderRadius: 30,
                                                            buttonSize: 46,
                                                            icon: Icon(
                                                              Icons
                                                                  .close_rounded,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryText,
                                                              size: 20,
                                                            ),
                                                            onPressed: () {
                                                              context.pop();
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 0, 20),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Align(
                                                alignment: AlignmentDirectional(
                                                    0, 0.05),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: (funcionario
                                                          .urlImagen.isEmpty)
                                                      ? Text(
                                                          'Imagen no disponible')
                                                      : FastCachedImage(
                                                          width: 150,
                                                          height: 150,
                                                          url: funcionario
                                                              .urlImagen,
                                                          fit: BoxFit.cover,
                                                          fadeInDuration:
                                                              const Duration(
                                                                  seconds: 1),
                                                          errorBuilder:
                                                              (context,
                                                                  exception,
                                                                  stacktrace) {
                                                            log(stacktrace
                                                                .toString());
                                                            return Text(
                                                                'ERROR');
                                                          },
                                                          loadingBuilder:
                                                              (context,
                                                                  progress) {
                                                            return Container(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryBackground,
                                                              child: Stack(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                children: [
                                                                  if (progress
                                                                          .isDownloading &&
                                                                      progress.totalBytes !=
                                                                          null)
                                                                    Text(
                                                                        '${progress.downloadedBytes ~/ 1024} / ${progress.totalBytes! ~/ 1024} kb',
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Color(0xFF006D38))),
                                                                  SizedBox(
                                                                      width:
                                                                          140,
                                                                      height:
                                                                          140,
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
                                                      .fromSTEB(12, 0, 0, 0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0, 2, 0, 0),
                                                        child: AutoSizeText(
                                                          (funcionario.apellidos ==
                                                                  null)
                                                              ? funcionario
                                                                  .nombres
                                                              : '${funcionario.nombres} ${funcionario.apellidos}',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .subtitle1
                                                              .override(
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .whiteColor,
                                                                fontSize: 22,
                                                                useGoogleFonts: GoogleFonts
                                                                        .asMap()
                                                                    .containsKey(
                                                                        FlutterFlowTheme.of(context)
                                                                            .subtitle1Family),
                                                                lineHeight: 1.4,
                                                              ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(0, 10,
                                                                    0, 0),
                                                        child: Text(
                                                          funcionario.cargo,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyText1
                                                              .override(
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                                fontSize: 16,
                                                                useGoogleFonts: GoogleFonts
                                                                        .asMap()
                                                                    .containsKey(
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyText1Family),
                                                              ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(0, 10,
                                                                    0, 0),
                                                        child: Text(
                                                          area.nombre,
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyText1
                                                              .override(
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                                fontSize: 16,
                                                                useGoogleFonts: GoogleFonts
                                                                        .asMap()
                                                                    .containsKey(
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyText1Family),
                                                              ),
                                                        ),
                                                      ),
                                                    ],
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
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          24, 12, 0, 8),
                                      child: Text(
                                        'NÚMERO DE CEDULA',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyText2
                                            .override(
                                              fontFamily: 'Poppins',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              useGoogleFonts:
                                                  GoogleFonts.asMap()
                                                      .containsKey(
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyText2Family),
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      25, 0, 0, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 24, 0),
                                          child: Text(
                                            funcionario.cedula,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyText1
                                                .override(
                                                  fontFamily: 'Poppins',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .grayicon,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.normal,
                                                  useGoogleFonts: GoogleFonts
                                                          .asMap()
                                                      .containsKey(
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyText1Family),
                                                ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            (funcionario.correo == null ||
                                    funcionario.correo!.isEmpty)
                                ? Container()
                                : Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    24, 12, 0, 8),
                                            child: Text(
                                              'CORREO ELÉCTRONICO',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyText2
                                                  .override(
                                                    fontFamily: 'Poppins',
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    useGoogleFonts: GoogleFonts
                                                            .asMap()
                                                        .containsKey(
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyText2Family),
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      (funcionario.correo == null &&
                                              funcionario.correo!.isEmpty)
                                          ? Container()
                                          : Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 0, 20, 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  24, 0, 24, 0),
                                                      child: Text(
                                                        funcionario.correo!,
                                                        maxLines: 2,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyText1
                                                                .override(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .grayicon,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyText1Family),
                                                                ),
                                                      ),
                                                    ),
                                                  ),
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0, 0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0,
                                                                          0,
                                                                          5,
                                                                          0),
                                                              child: InkWell(
                                                                onTap:
                                                                    () async {
                                                                  await launchUrl(Uri(
                                                                      scheme: 'mailto',
                                                                      path: funcionario.correo,
                                                                      query: {
                                                                        'subject':
                                                                            'Asunto',
                                                                        'body':
                                                                            ' ',
                                                                      }.entries.map((MapEntry<String, String> e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&')));
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: 40,
                                                                  height: 40,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primaryBackground,
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        blurRadius:
                                                                            3,
                                                                        color: Color(
                                                                            0x33000000),
                                                                        offset: Offset(
                                                                            0,
                                                                            2),
                                                                      )
                                                                    ],
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryText,
                                                                      width: 1,
                                                                    ),
                                                                  ),
                                                                  child:
                                                                      FlutterFlowIconButton(
                                                                    borderColor:
                                                                        Colors
                                                                            .transparent,
                                                                    borderRadius:
                                                                        30,
                                                                    buttonSize:
                                                                        46,
                                                                    icon: Icon(
                                                                      Icons
                                                                          .mail_outlined,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
                                                                      size: 22,
                                                                    ),
                                                                    onPressed:
                                                                        () async {
                                                                      await launchUrl(Uri(
                                                                          scheme: 'mailto',
                                                                          path: funcionario.correo,
                                                                          query: {
                                                                            'subject':
                                                                                'Asunto',
                                                                            'body':
                                                                                ' ',
                                                                          }.entries.map((MapEntry<String, String> e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&')));
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                    ],
                                  ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          24, 12, 0, 8),
                                      child: Text(
                                        'TELÉFONO',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyText2
                                            .override(
                                              fontFamily: 'Poppins',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              useGoogleFonts:
                                                  GoogleFonts.asMap()
                                                      .containsKey(
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyText2Family),
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24, 0, 20, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            funcionario.telefono1,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyText1
                                                .override(
                                                  fontFamily: 'Poppins',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .grayicon,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.normal,
                                                  useGoogleFonts: GoogleFonts
                                                          .asMap()
                                                      .containsKey(
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyText1Family),
                                                ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Align(
                                            alignment:
                                                AlignmentDirectional(0, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 20, 0),
                                                  child: Container(
                                                    width: 40,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .primaryBackground,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          blurRadius: 3,
                                                          color:
                                                              Color(0x33000000),
                                                          offset: Offset(0, 2),
                                                        )
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      border: Border.all(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0, 0.15),
                                                      child:
                                                          FlutterFlowIconButton(
                                                        borderColor:
                                                            Colors.transparent,
                                                        borderRadius: 30,
                                                        buttonSize: 40,
                                                        fillColor:
                                                            Color(0x00F1F4F8),
                                                        icon: FaIcon(
                                                          FontAwesomeIcons
                                                              .whatsapp,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          size: 22,
                                                        ),
                                                        onPressed: () async {
                                                          await launchURL(
                                                              'https://wa.me/${funcionario.telefono1}');
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 5, 0),
                                                  child: InkWell(
                                                    onTap: () async {
                                                      await launchUrl(Uri(
                                                        scheme: 'tel',
                                                        path: funcionario
                                                            .telefono1,
                                                      ));
                                                    },
                                                    child: Container(
                                                      width: 40,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .primaryBackground,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            blurRadius: 3,
                                                            color: Color(
                                                                0x33000000),
                                                            offset:
                                                                Offset(0, 2),
                                                          )
                                                        ],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        border: Border.all(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          width: 1,
                                                        ),
                                                      ),
                                                      child:
                                                          FlutterFlowIconButton(
                                                        borderColor:
                                                            Colors.transparent,
                                                        borderRadius: 30,
                                                        buttonSize: 46,
                                                        icon: Icon(
                                                          Icons.call,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          size: 22,
                                                        ),
                                                        onPressed: () async {
                                                          await launchUrl(Uri(
                                                            scheme: 'tel',
                                                            path: funcionario
                                                                .telefono1,
                                                          ));
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (funcionario.telefono2 != null &&
                                funcionario.telefono2!.isNotEmpty)
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            24, 12, 0, 8),
                                        child: Text(
                                          'TELÉFONO ALTERNATIVO',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText2
                                              .override(
                                                fontFamily: 'Poppins',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                useGoogleFonts: GoogleFonts
                                                        .asMap()
                                                    .containsKey(
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyText2Family),
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        24, 0, 20, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              funcionario.telefono2!,
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyText1
                                                      .override(
                                                        fontFamily: 'Poppins',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .grayicon,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        useGoogleFonts: GoogleFonts
                                                                .asMap()
                                                            .containsKey(
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyText1Family),
                                                      ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Align(
                                              alignment:
                                                  AlignmentDirectional(0, 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 0, 20, 0),
                                                    child: Container(
                                                      width: 40,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .primaryBackground,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            blurRadius: 3,
                                                            color: Color(
                                                                0x33000000),
                                                            offset:
                                                                Offset(0, 2),
                                                          )
                                                        ],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        border: Border.all(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          width: 1,
                                                        ),
                                                      ),
                                                      child: Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0, 0.15),
                                                        child:
                                                            FlutterFlowIconButton(
                                                          borderColor: Colors
                                                              .transparent,
                                                          borderRadius: 30,
                                                          buttonSize: 40,
                                                          fillColor:
                                                              Color(0x00F1F4F8),
                                                          icon: FaIcon(
                                                            FontAwesomeIcons
                                                                .whatsapp,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryText,
                                                            size: 22,
                                                          ),
                                                          onPressed: () async {
                                                            await launchURL(
                                                                'https://wa.me/${funcionario.telefono2}');
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 0, 5, 0),
                                                    child: InkWell(
                                                      onTap: () async {
                                                        await launchUrl(Uri(
                                                          scheme: 'tel',
                                                          path: funcionario
                                                              .telefono2,
                                                        ));
                                                      },
                                                      child: Container(
                                                        width: 40,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBackground,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              blurRadius: 3,
                                                              color: Color(
                                                                  0x33000000),
                                                              offset:
                                                                  Offset(0, 2),
                                                            )
                                                          ],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          border: Border.all(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryText,
                                                            width: 1,
                                                          ),
                                                        ),
                                                        child:
                                                            FlutterFlowIconButton(
                                                          borderColor: Colors
                                                              .transparent,
                                                          borderRadius: 30,
                                                          buttonSize: 46,
                                                          icon: Icon(
                                                            Icons.call,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryText,
                                                            size: 22,
                                                          ),
                                                          onPressed: () async {
                                                            await launchUrl(Uri(
                                                              scheme: 'tel',
                                                              path: funcionario
                                                                  .telefono2,
                                                            ));
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            (funcionario.enlaceSIGEP != null &&
                                    funcionario.enlaceSIGEP!.isNotEmpty)
                                ? Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    24, 12, 0, 8),
                                            child: Text(
                                              'ENLACE AL SIGEP',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyText2
                                                      .override(
                                                        fontFamily: 'Poppins',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        fontSize: 12,
                                                        useGoogleFonts: GoogleFonts
                                                                .asMap()
                                                            .containsKey(
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyText2Family),
                                                      ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            20, 4, 20, 0),
                                        child: InkWell(
                                          onTap: () async {
                                            await launchURL(
                                                funcionario.enlaceSIGEP!);
                                          },
                                          onLongPress: () async {
                                            HapticFeedback.mediumImpact();
                                            await actions.copyToClipboard(
                                                context,
                                                funcionario.enlaceSIGEP);
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBackground,
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 2,
                                                  color: Color(0x3E000000),
                                                  offset: Offset(0, 1),
                                                )
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                width: 1,
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 8, 0, 8),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(12, 0,
                                                                    12, 0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0,
                                                                          0,
                                                                          8,
                                                                          0),
                                                              child: Card(
                                                                clipBehavior: Clip
                                                                    .antiAliasWithSaveLayer,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                                child: Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          2,
                                                                          2,
                                                                          2,
                                                                          2),
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/images/sigep.jpg',
                                                                      width: 86,
                                                                      height:
                                                                          50,
                                                                      fit: BoxFit
                                                                          .contain,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0,
                                                                            4,
                                                                            0,
                                                                            0),
                                                                    child: Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                0,
                                                                                4,
                                                                                0),
                                                                            child:
                                                                                Text(
                                                                              funcionario.enlaceSIGEP!,
                                                                              textAlign: TextAlign.justify,
                                                                              maxLines: 3,
                                                                              style: FlutterFlowTheme.of(context).bodyText2.override(
                                                                                    fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                                                                                    color: FlutterFlowTheme.of(context).grayicon,
                                                                                    useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyText2Family),
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .chevron_right_outlined,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  size: 24,
                                                                ),
                                                              ],
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
                                        ).animateOnPageLoad(animationsMap[
                                            'containerOnPageLoadAnimation1']!),
                                      ),
                                    ],
                                  )
                                : Container(),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(24, 12, 0, 8),
                              child: Text(
                                'ACTIVOS ASIGNADOS',
                                style: FlutterFlowTheme.of(context)
                                    .bodyText2
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyText2Family,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .bodyText2Family),
                                    ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 24),
                          child: FutureBuilder<List<Activo>>(
                            future: cargarActivosAsignados(funcionario.cedula),
                            builder: (BuildContext context, snapshot) {
                              Logger().i('Estado de conexion: ' +
                                  snapshot.connectionState.toString());
                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.data!.length > 0) {
                                return _tarjetaActivo(snapshot);
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(30),
                          child: Container(),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (blur)
            ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 4,
                  sigmaY: 4,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Align(
                      alignment: AlignmentDirectional(0, 0),

                      child: _cajaAdvertencia(
                        context,
                        '¿Esta realmente seguro que desea eliminar a este funcionario?',
                        funcionario.cedula,
                      ),
                      //. animateOnActionTrigger(animationsMap['cajaAdvertenciaOnActionTriggerAnimation']!,hasBeenTriggered: true),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _tarjetaActivo(snapshot) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: snapshot.data!.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsetsDirectional.fromSTEB(20, 5, 20, 4),
          child: InkWell(
            onTap: () async {
              Logger().w('inkWell onTap');
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 88,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 2,
                    color: Color(0x3E000000),
                    offset: Offset(0, 1),
                  )
                ],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: FlutterFlowTheme.of(context).secondaryText,
                  width: 1,
                ),
              ),
              child: InkWell(
                onTap: () async {
                  context.pushNamed(
                    'activoPerfilPage',
                    queryParams: {
                      'idActivo': serializeParam(
                        snapshot.data![index].idSerial,
                        ParamType.String,
                      ),
                      'selectMode': serializeParam(
                        false,
                        ParamType.bool,
                      ),
                    }.withoutNulls,
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(8, 0, 12, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 8, 2),
                            child: Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              color: FlutterFlowTheme.of(context).whiteColor,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: FastCachedImage(
                                  width: 73,
                                  height: 70,
                                  url: snapshot.data![index].urlImagen,
                                  fit: BoxFit.cover,
                                  fadeInDuration: const Duration(seconds: 1),
                                  errorBuilder:
                                      (context, exception, stacktrace) {
                                    log(stacktrace.toString());
                                    return Image.asset(
                                      'assets/images/nodisponible.png',
                                      width: 73,
                                      height: 70,
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
                                              width: 65,
                                              height: 65,
                                              child: CircularProgressIndicator(
                                                  color:
                                                      const Color(0xFF006D38),
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
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data![index].nombre.toString(),
                                  style: FlutterFlowTheme.of(context)
                                      .subtitle1
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .subtitle1Family,
                                        fontSize: 15,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .subtitle1Family),
                                      ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.barcode,
                                      color:
                                          FlutterFlowTheme.of(context).grayicon,
                                      size: 15,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              3, 1.4, 0, 1),
                                      child: Text(
                                        'S/N: ${snapshot.data![index].idSerial}',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyText2
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyText2Family,
                                              fontSize: 13,
                                              useGoogleFonts:
                                                  GoogleFonts.asMap()
                                                      .containsKey(
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyText2Family),
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 1),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const FaIcon(
                                        FontAwesomeIcons.boxOpen,
                                        color: Color(0xFFAD8762),
                                        size: 9,
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(3, 0, 0, 1),
                                        child: Text(
                                          (snapshot.data![index].numActivo!
                                                  .isEmpty)
                                              ? 'No registrado'
                                              : snapshot
                                                  .data![index].numActivo!,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText2
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyText2Family,
                                                fontSize: 13,
                                                useGoogleFonts: GoogleFonts
                                                        .asMap()
                                                    .containsKey(
                                                        FlutterFlowTheme.of(
                                                                context)
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
                          FlutterFlowIconButton(
                            borderColor: Colors.transparent,
                            borderRadius: 30,
                            buttonSize: 46,
                            icon: Icon(
                              Icons.delete_outline,
                              color: Color(0xFFE62424),
                              size: 24,
                            ),
                            onPressed: () async {
                              var res = await activoController
                                  .quitarActivoFuncionario(
                                      context, snapshot.data![index].idSerial);
                              if (res == 'ok') {
                                setState(() {});
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation2']!),
        );
      },
    );
  }

  Widget _cajaAdvertencia(context, mensaje, id) {
    return Align(
      alignment: AlignmentDirectional(0, 0),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16, 24, 16, 5),
        child: Container(
          width: 450,
          constraints: BoxConstraints(
            maxWidth: 500,
            maxHeight: 300,
          ),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            boxShadow: [
              BoxShadow(
                blurRadius: 7,
                color: Color(0x4D000000),
                offset: Offset(0, 3),
              )
            ],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Text(
                    'Advertencia',
                    style: FlutterFlowTheme.of(context).title2.override(
                          fontFamily: 'Poppins',
                          color: FlutterFlowTheme.of(context).primaryText,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).title2Family),
                        ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Text(
                    mensaje,
                    style: FlutterFlowTheme.of(context).bodyText1.override(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).bodyText1Family),
                        ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                  child: FFButtonWidget(
                    onPressed: () {
                      FuncionariosController funcionarioController =
                          FuncionariosController();
                      var res = funcionarioController.eliminarFuncionario(
                          context, id);
                      if (res == 'ok') {
                        context.pop();
                      }
                    },
                    text: 'Sí, deseo eliminar a este funcionario',
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 50,
                      color: Color(0xFFFC4253),
                      textStyle: FlutterFlowTheme.of(context)
                          .subtitle2
                          .override(
                            fontFamily: 'Poppins',
                            color: FlutterFlowTheme.of(context).whiteColor,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context).subtitle2Family),
                          ),
                      elevation: 2,
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    showLoadingIndicator: false,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                      child: FFButtonWidget(
                        onPressed: () {
                          setState(() {
                            blur = false;
                          });
                        },
                        text: 'No, cancelar',
                        options: FFButtonOptions(
                          width: 170,
                          height: 50,
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          textStyle: FlutterFlowTheme.of(context)
                              .subtitle2
                              .override(
                                fontFamily: 'Poppins',
                                color: FlutterFlowTheme.of(context).primaryText,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .subtitle2Family),
                              ),
                          elevation: 0,
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        showLoadingIndicator: false,
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

Future<List<Activo>> cargarActivosAsignados(String cedula) async {
  List<Activo> listActivosAsignados = [];
  FuncionariosController funcionariosController = FuncionariosController();
  ActivoController activoController = ActivoController();
  List<ActivoFuncionario> listFuncionariosActvos =
      await funcionariosController.getActivosAsignados(cedula);
  Logger().i('Cantidad de activos asignados:${listFuncionariosActvos.length}');
  await Future.forEach(listFuncionariosActvos, (ActivoFuncionario value) async {
    listActivosAsignados
        .add(await activoController.buscarActivo(value.idSerial));
  });
  return Future.value(listActivosAsignados);
}

Future<List<Activo>> cargarActivosPrestados(String cedula) async {
  List<Activo> listActivos = [];
  PrestamosController prestamosController = PrestamosController();
  ActivoController activoController = ActivoController();
  List<Prestamo> listFuncionariosActvos =
      await prestamosController.getActivosPrestados(idFuncionario: cedula);
  Logger().i('Cantidad de activos asignados:${listFuncionariosActvos.length}');
  await Future.forEach(listFuncionariosActvos, (Prestamo value) async {
    listActivos.add(await activoController.buscarActivo(value.idActivo));
  });
  Logger().i('Cantidad de activos asignados devueltos:' +
      listActivos.length.toString());
  return Future.value(listActivos);
}
