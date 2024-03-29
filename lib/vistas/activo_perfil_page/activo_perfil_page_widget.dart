import 'dart:developer';

import 'package:app_gestion_prestamo_inventario/entidades/activo.dart';
import 'package:app_gestion_prestamo_inventario/entidades/componenteExterno.dart';
import 'package:app_gestion_prestamo_inventario/entidades/componenteInterno.dart';
import 'package:app_gestion_prestamo_inventario/entidades/software.dart';
import 'package:app_gestion_prestamo_inventario/index.dart';
import 'package:app_gestion_prestamo_inventario/servicios/activoController.dart';
import 'package:app_gestion_prestamo_inventario/servicios/componenteExternoController.dart';
import 'package:app_gestion_prestamo_inventario/servicios/componenteInternoController.dart';
import 'package:app_gestion_prestamo_inventario/servicios/pdfApi.dart';
import 'package:app_gestion_prestamo_inventario/servicios/softwareController.dart';
import 'package:app_gestion_prestamo_inventario/vistas/lista_funcionarios_page/lista_funcionarios_page_widget.dart';
import 'package:app_gestion_prestamo_inventario/vistas/resgistrar_activo_page/resgistrar_activo_computo_page_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../assets/utilidades.dart';
import '../../entidades/activo_funcionario.dart';
import '../../entidades/area.dart';
import '../../entidades/area.dart';
import '../../entidades/funcionario.dart';
import '../../entidades/prestamo.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../../servicios/funcionariosController.dart';
import '../../servicios/prestamosController.dart';
import '../components/caja_advertencia_widget.dart';
import '../flutter_flow/flutter_flow_animations.dart';
import '../flutter_flow/flutter_flow_expanded_image_view.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class ActivoPerfilPageWidget extends StatefulWidget {
  final Activo activo;
  final bool selectMode;
  final bool esPrestamo;
  final bool escogerComponente;
  const ActivoPerfilPageWidget(
      {Key? key,
      required this.activo,
      this.selectMode = false,
      this.esPrestamo = false,
      this.escogerComponente = false})
      : super(key: key);

  @override
  _ActivoPerfilPageWidgetState createState() => _ActivoPerfilPageWidgetState(
      this.activo, this.selectMode, this.esPrestamo, this.escogerComponente);
}

class _ActivoPerfilPageWidgetState extends State<ActivoPerfilPageWidget>
    with TickerProviderStateMixin {
  final animationsMap = {
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
    'floatingActionButtonOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        VisibilityEffect(duration: 1500.ms),
        MoveEffect(
          curve: Curves.easeOut,
          delay: 200.ms,
          duration: 1400.ms,
          begin: Offset(0, 1000),
          end: Offset(0, 0),
        ),
      ],
    ),
    'textOnPageLoadAnimation1': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0, 50),
          end: Offset(0, 0),
        ),
      ],
    ),
    'rowOnPageLoadAnimation1': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0, 70),
          end: Offset(0, 0),
        ),
      ],
    ),
    'rowOnPageLoadAnimation2': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0, 70),
          end: Offset(0, 0),
        ),
      ],
    ),
    'rowOnPageLoadAnimation3': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0, 80),
          end: Offset(0, 0),
        ),
      ],
    ),
    'textOnPageLoadAnimation2': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0, 90),
          end: Offset(0, 0),
        ),
      ],
    ),
    'rowOnPageLoadAnimation4': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0, 100),
          end: Offset(0, 0),
        ),
      ],
    ),
    'rowOnPageLoadAnimation5': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0, 100),
          end: Offset(0, 0),
        ),
      ],
    ),
    'rowOnPageLoadAnimation6': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0, 100),
          end: Offset(0, 0),
        ),
      ],
    ),
    'rowOnPageLoadAnimation7': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0, 80),
          end: Offset(0, 0),
        ),
      ],
    ),
    'containerOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        MoveEffect(
          curve: Curves.easeOut,
          delay: 0.ms,
          duration: 2000.ms,
          begin: Offset(0, 1000),
          end: Offset(0, 0),
        ),
      ],
    ),
    'cajaAdvertenciaOnActionTriggerAnimation': AnimationInfo(
      trigger: AnimationTrigger.onActionTrigger,
      applyInitialState: true,
      effects: [
        MoveEffect(
          curve: Curves.elasticOut,
          delay: 0.ms,
          duration: 1800.ms,
          begin: Offset(-1000, 0),
          end: Offset(0, 0),
        ),
      ],
    ),
  };
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Activo activo;
  bool blur = false;
  ActivoController activoController = ActivoController();
  bool selectMode;
  bool esPrestamo;
  List<Activo> listaComponenteExterno = [];
  List<ComponenteInterno> listaComponenteInterno = [];
  List<Software> listaSoftware = [];

  PrestamosController prestamosController = PrestamosController();

  bool tienePrestamos = false;
  List<String> listaFechasEntrega = [];
  bool escogerComponente;

  _ActivoPerfilPageWidgetState(
      this.activo, this.selectMode, this.esPrestamo, this.escogerComponente);

  @override
  void initState() {
    super.initState();
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: false,
      right: false,
      bottom: false,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        floatingActionButton: (!selectMode &&
                !esPrestamo &&
                !escogerComponente &&
                activo.idCategoria == 8)
            ? Padding(
                padding: EdgeInsets.only(bottom: 50.0, right: 16),
                child: SpeedDial(
                  //Speed dial menu
                  //margin bottom
                  icon: Icons.menu, //icon on Floating action button
                  activeIcon:
                      Icons.close, //icon when menu is expanded on button
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
                        child: Icon(
                          Icons.picture_as_pdf_outlined,
                          color: FlutterFlowTheme.of(context).whiteColor,
                          size: 24,
                        ),
                        backgroundColor: Color.fromARGB(255, 7, 133, 107),
                        foregroundColor: Colors.white,
                        label: 'Generar Hoja de vida',
                        labelStyle: TextStyle(fontSize: 18.0),
                        onTap: () async {
                          PdfApi().generarHojadeVidaComputo(
                              activo,
                              listaSoftware,
                              listaComponenteExterno,
                              listaComponenteInterno);
                        }),
                    if (!activo.estaAsignado)
                      SpeedDialChild(
                        child: Icon(
                          Icons.add_rounded,
                          color: FlutterFlowTheme.of(context).whiteColor,
                          size: 24,
                        ),
                        foregroundColor: Colors.white,
                        backgroundColor: Color.fromARGB(255, 6, 113, 122),
                        label: 'Asignar Funcionario',
                        labelStyle: TextStyle(fontSize: 18.0),
                        onTap: () async {
                          final Funcionario? result =
                              await context.pushNamed<Funcionario>(
                            'listaSeleccionFuncionariosPage',
                          );
                          if (result != null) {
                            // ignore: use_build_context_synchronously
                            ActivoController().asignarActivo(
                                context, result.cedula, activo.idSerial);
                            activo = await ActivoController()
                                .buscarActivo(activo.idSerial);
                            Future.delayed(const Duration(milliseconds: 2000),
                                () {
// Here you can write your code

                              setState(() {
                                // Here you can write your code for open new view
                              });
                            });
                          }
                        },
                      ),

                    //add more menu item childs here
                  ],
                ),
              )
            : myFloatingButton(
                selectMode: selectMode,
                idActivo: activo.idSerial,
                contextPadre: context,
                activo: activo,
                esPrestamo: esPrestamo,
                escogerComponente: escogerComponente,
              ).animateOnPageLoad(
                animationsMap['floatingActionButtonOnPageLoadAnimation']!),
        body: GestureDetector(
          onTap: () => {FocusScope.of(context).unfocus()},
          child: Stack(
            children: [
              Stack(
                children: [
                  GestureDetector(
                    onTap: () => setState(() {
                      blur = false;
                    }),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Align(
                                  alignment: AlignmentDirectional(0, 0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        20, 15, 0, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 24, 0),
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBackground,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                width: 1,
                                              ),
                                            ),
                                            child: FlutterFlowIconButton(
                                              borderColor: Colors.transparent,
                                              borderRadius: 30,
                                              buttonSize: 46,
                                              icon: Icon(
                                                Icons.close_rounded,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                size: 20,
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 0, 24, 0),
                                              child: Container(
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    width: 1,
                                                  ),
                                                ),
                                                child: FlutterFlowIconButton(
                                                  borderColor:
                                                      Colors.transparent,
                                                  borderRadius: 30,
                                                  buttonSize: 46,
                                                  fillColor: Color(0x00F1F4F8),
                                                  icon: Icon(
                                                    Icons.edit,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    size: 16,
                                                  ),
                                                  onPressed: () async {
                                                    final value =
                                                        await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ResgistrarActivoPageWidget(
                                                          idCategoria: activo
                                                              .idCategoria,
                                                          activoEditar: activo,
                                                          listComponentesExActivos:
                                                              listaComponenteExterno,
                                                          listComponentesInternos:
                                                              listaComponenteInterno,
                                                          listSoftware:
                                                              listaSoftware,
                                                        ),
                                                      ),
                                                    ).then((_) async {
                                                      activo =
                                                          await ActivoController()
                                                              .buscarActivo(
                                                                  activo
                                                                      .idSerial);
                                                      Future.delayed(
                                                          const Duration(
                                                              milliseconds:
                                                                  500), () {
// Here you can write your code

                                                        setState(() {
                                                          // Here you can write your code for open new view
                                                        });
                                                      });
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 0, 24, 0),
                                              child: Container(
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    width: 1,
                                                  ),
                                                ),
                                                child: FlutterFlowIconButton(
                                                  borderColor:
                                                      Colors.transparent,
                                                  borderRadius: 30,
                                                  buttonSize: 46,
                                                  fillColor: Color(0x00F1F4F8),
                                                  icon: Icon(
                                                    Icons.delete_outlined,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    size: 20,
                                                  ),
                                                  onPressed: () async {
                                                    setState(() {
                                                      blur = true;
                                                    });
                                                  },
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
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 20, 0, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        height: 320,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFDBE2E7),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Stack(
                                          children: [
                                            Align(
                                              alignment:
                                                  AlignmentDirectional(0, 0),
                                              child: InkWell(
                                                onTap: () async {
                                                  await Navigator.push(
                                                    context,
                                                    PageTransition(
                                                      type: PageTransitionType
                                                          .fade,
                                                      child:
                                                          FlutterFlowExpandedImageView(
                                                        image:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              activo.urlImagen,
                                                          fit: BoxFit.contain,
                                                        ),
                                                        allowRotation: false,
                                                        tag: 'mainImage',
                                                        useHeroAnimation: true,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Hero(
                                                  tag: 'mainImage',
                                                  transitionOnUserGestures:
                                                      true,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          activo.urlImagen,
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                      fit: BoxFit.cover,
                                                    ),
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
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24, 12, 24, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          activo.nombre,
                                          style: FlutterFlowTheme.of(context)
                                              .title1
                                              .override(
                                                fontFamily: 'Poppins',
                                                useGoogleFonts:
                                                    GoogleFonts.asMap()
                                                        .containsKey(
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .title1Family),
                                              ),
                                        ).animateOnPageLoad(animationsMap[
                                            'textOnPageLoadAnimation1']!),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24, 10, 24, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            2, 0, 0, 0),
                                        child: FaIcon(
                                          FontAwesomeIcons.barcode,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          size: 24,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            8, 0, 0, 0),
                                        child: Text(
                                          'S/N: ${activo.idSerial}',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText2
                                              .override(
                                                fontFamily: 'Poppins',
                                                color: Color(0xFF8B97A2),
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
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
                                  ).animateOnPageLoad(animationsMap[
                                      'rowOnPageLoadAnimation1']!),
                                ),
                                (activo.numActivo != null)
                                    ? Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            24, 8, 24, 0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            FaIcon(
                                              FontAwesomeIcons.boxOpen,
                                              color: Color(0xFFAD8762),
                                              size: 24,
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(8, 0, 0, 0),
                                              child: Text(
                                                (activo.numActivo == null ||
                                                        activo
                                                            .numActivo.isEmpty)
                                                    ? 'Nro inventario: No disponible'
                                                    : 'Nro inventario: ${activo.numActivo}',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyText2
                                                    .override(
                                                      fontFamily: 'Lexend Deca',
                                                      color: Color(0xFF8B97A2),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.normal,
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
                                        ).animateOnPageLoad(animationsMap[
                                            'rowOnPageLoadAnimation2']!),
                                      )
                                    : Row(),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24, 12, 24, 12),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        'MARCA:',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyText2
                                            .override(
                                              fontFamily: 'Lexend Deca',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              useGoogleFonts:
                                                  GoogleFonts.asMap()
                                                      .containsKey(
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyText2Family),
                                            ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16, 0, 24, 0),
                                        child: Expanded(
                                          child: Text(
                                            (activo.detalles != null)
                                                ? activo.detalles
                                                : '',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyText2
                                                .override(
                                                  fontFamily: 'Poppins',
                                                  color: Color(0xFF8B97A2),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal,
                                                  useGoogleFonts: GoogleFonts
                                                          .asMap()
                                                      .containsKey(
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyText2Family),
                                                ),
                                          ).animateOnPageLoad(animationsMap[
                                              'textOnPageLoadAnimation2']!),
                                        ),
                                      ),
                                    ],
                                  ).animateOnPageLoad(animationsMap[
                                      'rowOnPageLoadAnimation3']!),
                                ),

                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24, 0, 24, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        'CATEGORIA: ',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyText2
                                            .override(
                                              fontFamily: 'Poppins',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              useGoogleFonts:
                                                  GoogleFonts.asMap()
                                                      .containsKey(
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyText2Family),
                                            ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            2, 0, 0, 0),
                                        child: Text(
                                          activo.categoria,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText2
                                              .override(
                                                fontFamily: 'Lexend Deca',
                                                color: Color(0xFF8B97A2),
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
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
                                  ).animateOnPageLoad(animationsMap[
                                      'rowOnPageLoadAnimation4']!),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24, 16, 24, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 1),
                                        child: Text(
                                          'ESTADO: ',
                                          textAlign: TextAlign.center,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText2
                                              .override(
                                                fontFamily: 'Poppins',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                fontSize: 16,
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
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            4, 0, 0, 2.4),
                                        child: FaIcon(
                                          FontAwesomeIcons.solidCircle,
                                          color:
                                              definirColorEstado(activo.estado),
                                          size: 10,
                                        ),
                                      ),
                                      Align(
                                        alignment: AlignmentDirectional(0, 0),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  2, 0, 0, 3),
                                          child: Text(
                                            definirEstadoActivo(activo.estado),
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyText2
                                                .override(
                                                  fontFamily: 'Poppins',
                                                  color: Color(0xFF8B97A2),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal,
                                                  useGoogleFonts: GoogleFonts
                                                          .asMap()
                                                      .containsKey(
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyText2Family),
                                                ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ).animateOnPageLoad(animationsMap[
                                      'rowOnPageLoadAnimation5']!),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24, 16, 0, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'UNIDADES DISPONIBLES:',
                                        textAlign: TextAlign.center,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyText2
                                            .override(
                                              fontFamily: 'Lexend Deca',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              useGoogleFonts:
                                                  GoogleFonts.asMap()
                                                      .containsKey(
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyText2Family),
                                            ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            6, 0, 0, 0),
                                        child: Text(
                                          activo.cantidad.toString(),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText2
                                              .override(
                                                fontFamily: 'Poppins',
                                                color: Color(0xFF8B97A2),
                                                fontSize: 20,
                                                fontWeight: FontWeight.normal,
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
                                  ).animateOnPageLoad(animationsMap[
                                      'rowOnPageLoadAnimation6']!),
                                ),
                                //TituloListafFuncionariosAsignados(animationsMap: animationsMap),
                                //ListaFuncionariosAsignados(animationsMap: animationsMap),

                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 24),
                                  child: FutureBuilder<List<Funcionario>>(
                                    future: cargarFuncionariosAsignados(
                                        activo.idSerial),
                                    builder: (BuildContext context, snapshot) {
                                      Logger().i('Estado de conexion: ' +
                                          snapshot.connectionState.toString());
                                      if (snapshot.connectionState ==
                                              ConnectionState.done &&
                                          snapshot.data!.length > 0) {
                                        return _tarjetaFuncionario(
                                            snapshot, false, []);
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                ),
                                if (activo.estaPrestado)
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 24),
                                    child: FutureBuilder<List<Funcionario>>(
                                      future: cargarFuncionariosPrestamos(
                                          activo.idSerial),
                                      builder:
                                          (BuildContext context, snapshot) {
                                        Logger().i('Estado de conexion: ' +
                                            snapshot.connectionState
                                                .toString());
                                        if (snapshot.connectionState ==
                                                ConnectionState.done &&
                                            snapshot.data!.length > 0) {
                                          if (tienePrestamos == false) {
                                            setState() {
                                              tienePrestamos = true;
                                            }
                                          }

                                          return _tarjetaFuncionario(snapshot,
                                              true, listaFechasEntrega);
                                        } else {
                                          if (tienePrestamos) {
                                            setState() {
                                              tienePrestamos = false;
                                            }
                                          }
                                          return Container();
                                        }
                                      },
                                    ),
                                  ),
                                if (activo.idCategoria == 8)
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 24),
                                    child: FutureBuilder<List<Software>>(
                                      future: SoftwareController()
                                          .getbyIdActivo(activo.idSerial),
                                      builder:
                                          (BuildContext context, snapshot) {
                                        Logger().i('Estado de conexion: ' +
                                            snapshot.connectionState
                                                .toString());
                                        if (snapshot.connectionState ==
                                                ConnectionState.done &&
                                            snapshot.data!.length > 0) {
                                          listaSoftware = snapshot.data!;
                                          return _tarjetaSoftware(
                                              snapshot, false, []);
                                        } else {
                                          return Container();
                                        }
                                      },
                                    ),
                                  ),

                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 24),
                                  child: FutureBuilder<List<Activo>>(
                                    future: ComponenteExternoController()
                                        .getbyIdActivo(activo.idSerial),
                                    builder: (BuildContext context, snapshot) {
                                      Logger().i('Estado de conexion: ' +
                                          snapshot.connectionState.toString());
                                      if (snapshot.connectionState ==
                                              ConnectionState.done &&
                                          snapshot.data!.length > 0) {
                                        listaComponenteExterno = snapshot.data!;
                                        return _tarjetaActivo(
                                            snapshot, false, []);
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                ),
                                if (activo.idCategoria == 8)
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 24),
                                    child:
                                        FutureBuilder<List<ComponenteInterno>>(
                                      future: ComponenteInternoController()
                                          .getbyIdActivo(activo.idSerial),
                                      builder:
                                          (BuildContext context, snapshot) {
                                        Logger().i('Estado de conexion: ' +
                                            snapshot.connectionState
                                                .toString());
                                        if (snapshot.connectionState ==
                                                ConnectionState.done &&
                                            snapshot.data!.length > 0) {
                                          listaComponenteInterno =
                                              snapshot.data!;
                                          return _tarjetaComponentesInternos(
                                              snapshot, false, []);
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
                      ],
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
                            '¿Esta seguro que desea eliminar este activo?',
                            'activo',
                            activo.idSerial.toString(),
                          ),
                          //. animateOnActionTrigger(animationsMap['cajaAdvertenciaOnActionTriggerAnimation']!,hasBeenTriggered: true),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tarjetaFuncionario(AsyncSnapshot<List<Funcionario>> snapshot,
      bool prestamo, List<String> fechaEntrega) {
    Utilidades utilidades = Utilidades();
    Area area = Area();
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(24, 12, 0, 8),
              child: Text(
                (prestamo) ? 'ESTE ACTIVO SE PRESTÓ A' : 'ACTIVO ASIGNADO A',
                style: FlutterFlowTheme.of(context).bodyText2.override(
                      fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      useGoogleFonts: GoogleFonts.asMap().containsKey(
                          FlutterFlowTheme.of(context).bodyText2Family),
                    ),
              ),
            ),
          ],
        ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation1']!),
        if (prestamo)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(24, 4, 0, 8),
            child: Row(
              children: [
                const Icon(
                  FontAwesomeIcons.check,
                  color: Color.fromARGB(255, 7, 133, 36),
                  size: 15,
                ),
                Text(
                  ':  Marcar este activo como entregado',
                  style: FlutterFlowTheme.of(context).bodyText2.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).bodyText2Family,
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                            FlutterFlowTheme.of(context).bodyText2Family),
                      ),
                ),
              ],
            ),
          ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation1']!),
        SingleChildScrollView(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
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
                          'funcionarioPerfilPage',
                          queryParams: {
                            'funcionario': serializeParam(
                              snapshot.data![index],
                              ParamType.Funcionario,
                            ),
                            'area': serializeParam(
                              Area(
                                  id: 1,
                                  nombre: 'Oficina de las TICs',
                                  urlImagen: ''),
                              ParamType.Area,
                            )
                          },
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(8, 0, 12, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 8, 2),
                                  child: Card(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    color:
                                        FlutterFlowTheme.of(context).whiteColor,
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
                                        fadeInDuration:
                                            const Duration(seconds: 1),
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
                                                          color: Color(
                                                              0xFF006D38))),
                                                SizedBox(
                                                    width: 65,
                                                    height: 65,
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
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data![index].nombres
                                            .toString(),
                                        style: FlutterFlowTheme.of(context)
                                            .subtitle1
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .subtitle1Family,
                                              fontSize: 15,
                                              useGoogleFonts:
                                                  GoogleFonts.asMap()
                                                      .containsKey(
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .subtitle1Family),
                                            ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.barcode,
                                            color: FlutterFlowTheme.of(context)
                                                .grayicon,
                                            size: 15,
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(3, 1.4, 0, 1),
                                            child: Text(
                                              snapshot.data![index].cargo,
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyText2
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
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
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 0, 0, 1),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            const FaIcon(
                                              FontAwesomeIcons.boxOpen,
                                              color: Color(0xFFAD8762),
                                              size: 9,
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 4, 8, 0),
                                              child: FutureBuilder<Area>(
                                                future: cargarArea(snapshot
                                                    .data![index].idArea),
                                                initialData: area,
                                                builder: ((context, snapshot) {
                                                  area = snapshot.data!;
                                                  return AutoSizeText(
                                                    snapshot.data!.nombre,
                                                    textAlign: TextAlign.start,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyText2
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .grayicon,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyText2Family),
                                                        ),
                                                  );
                                                }),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (fechaEntrega.isNotEmpty && prestamo)
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 1),
                                              child: FaIcon(
                                                FontAwesomeIcons.calendar,
                                                color: utilidades
                                                    .defColorCalendario(context,
                                                        fechaEntrega[index]),
                                                size: 10,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(3, 0, 0, 1),
                                              child: AutoSizeText(
                                                fechaEntrega[index],
                                                textAlign: TextAlign.start,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyText2
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          color: utilidades
                                                              .defColorCalendario(
                                                                  context,
                                                                  fechaEntrega[
                                                                      index]),
                                                          fontSize: 9,
                                                          fontWeight:
                                                              FontWeight.w500,
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
                                    ],
                                  ),
                                ),
                                (fechaEntrega.isNotEmpty && prestamo)
                                    ? _iconoEliminarEntregar(
                                        fechaEntrega[index],
                                        prestamo,
                                        activo.idSerial,
                                        snapshot.data![index].cedula)
                                    : _iconoEliminarEntregar(
                                        '',
                                        prestamo,
                                        activo.idSerial,
                                        snapshot.data![index].cedula)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ).animateOnPageLoad(
                    animationsMap['containerOnPageLoadAnimation2']!),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _tarjetaActivo(AsyncSnapshot<List<Activo>> snapshot, bool prestamo,
      List<String> fechaEntrega) {
    Utilidades utilidades = Utilidades();
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(24, 12, 0, 8),
              child: Text(
                'COMPONENTES EXTERNOS',
                style: FlutterFlowTheme.of(context).bodyText2.override(
                      fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      useGoogleFonts: GoogleFonts.asMap().containsKey(
                          FlutterFlowTheme.of(context).bodyText2Family),
                    ),
              ),
            ),
          ],
        ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation1']!),
        SingleChildScrollView(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
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
                        Activo activoBuscado = await ActivoController()
                            .buscarActivo(snapshot.data![index].idSerial);
                        // ignore: use_build_context_synchronously
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ActivoPerfilPageWidget(
                              activo: activoBuscado,
                              selectMode: false,
                              esPrestamo: false,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(8, 0, 12, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 8, 2),
                                  child: Card(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    color:
                                        FlutterFlowTheme.of(context).whiteColor,
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
                                        fadeInDuration:
                                            const Duration(seconds: 1),
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
                                                          color: Color(
                                                              0xFF006D38))),
                                                SizedBox(
                                                    width: 65,
                                                    height: 65,
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
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data![index].nombre.toString(),
                                        style: FlutterFlowTheme.of(context)
                                            .subtitle1
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .subtitle1Family,
                                              fontSize: 15,
                                              useGoogleFonts:
                                                  GoogleFonts.asMap()
                                                      .containsKey(
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .subtitle1Family),
                                            ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.barcode,
                                            color: FlutterFlowTheme.of(context)
                                                .grayicon,
                                            size: 15,
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(3, 1.4, 0, 1),
                                            child: Text(
                                              'S/N: ${snapshot.data![index].idSerial}',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyText2
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
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
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 0, 0, 1),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            const FaIcon(
                                              FontAwesomeIcons.boxOpen,
                                              color: Color(0xFFAD8762),
                                              size: 9,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(3, 0, 0, 1),
                                              child: Text(
                                                (snapshot.data![index].numActivo
                                                        .isEmpty)
                                                    ? 'No registrado'
                                                    : snapshot
                                                        .data![index].numActivo,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyText2
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
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
                                      if (fechaEntrega.isNotEmpty && prestamo)
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 1),
                                              child: FaIcon(
                                                FontAwesomeIcons.calendar,
                                                color: utilidades
                                                    .defColorCalendario(context,
                                                        fechaEntrega[index]),
                                                size: 10,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(3, 0, 0, 1),
                                              child: AutoSizeText(
                                                fechaEntrega[index],
                                                textAlign: TextAlign.start,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyText2
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          color: utilidades
                                                              .defColorCalendario(
                                                                  context,
                                                                  fechaEntrega[
                                                                      index]),
                                                          fontSize: 9,
                                                          fontWeight:
                                                              FontWeight.w500,
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
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ).animateOnPageLoad(
                    animationsMap['containerOnPageLoadAnimation2']!),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _tarjetaComponentesInternos(
      AsyncSnapshot<List<ComponenteInterno>> snapshot,
      bool prestamo,
      List<String> fechaEntrega) {
    Utilidades utilidades = Utilidades();
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(24, 12, 0, 8),
              child: Text(
                'COMPONENTES INTERNOS',
                style: FlutterFlowTheme.of(context).bodyText2.override(
                      fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      useGoogleFonts: GoogleFonts.asMap().containsKey(
                          FlutterFlowTheme.of(context).bodyText2Family),
                    ),
              ),
            ),
          ],
        ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation1']!),
        SingleChildScrollView(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
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
                      onTap: () async {},
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(8, 0, 12, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 8, 2),
                                  child: Card(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    color:
                                        FlutterFlowTheme.of(context).whiteColor,
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
                                        fadeInDuration:
                                            const Duration(seconds: 1),
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
                                                          color: Color(
                                                              0xFF006D38))),
                                                SizedBox(
                                                    width: 65,
                                                    height: 65,
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
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${snapshot.data![index].nombre} ${snapshot.data![index].marca}',
                                        style: FlutterFlowTheme.of(context)
                                            .subtitle1
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .subtitle1Family,
                                              fontSize: 15,
                                              useGoogleFonts:
                                                  GoogleFonts.asMap()
                                                      .containsKey(
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .subtitle1Family),
                                            ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(3, 1.4, 0, 1),
                                            child: Text(
                                              '${snapshot.data![index].velocidad}',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyText2
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
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
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 0, 0, 1),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(3, 0, 0, 1),
                                              child: Text(
                                                snapshot.data![index]
                                                    .otrasCaracteristicas,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyText2
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
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
                                      if (fechaEntrega.isNotEmpty && prestamo)
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 1),
                                              child: FaIcon(
                                                FontAwesomeIcons.calendar,
                                                color: utilidades
                                                    .defColorCalendario(context,
                                                        fechaEntrega[index]),
                                                size: 10,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(3, 0, 0, 1),
                                              child: AutoSizeText(
                                                fechaEntrega[index],
                                                textAlign: TextAlign.start,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyText2
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          color: utilidades
                                                              .defColorCalendario(
                                                                  context,
                                                                  fechaEntrega[
                                                                      index]),
                                                          fontSize: 9,
                                                          fontWeight:
                                                              FontWeight.w500,
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
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ).animateOnPageLoad(
                    animationsMap['containerOnPageLoadAnimation2']!),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _tarjetaSoftware(AsyncSnapshot<List<Software>> snapshot, bool prestamo,
      List<String> fechaEntrega) {
    Utilidades utilidades = Utilidades();
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(24, 12, 0, 8),
              child: Text(
                'SOFTWARE',
                style: FlutterFlowTheme.of(context).bodyText2.override(
                      fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      useGoogleFonts: GoogleFonts.asMap().containsKey(
                          FlutterFlowTheme.of(context).bodyText2Family),
                    ),
              ),
            ),
          ],
        ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation1']!),
        SingleChildScrollView(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
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
                      onTap: () async {},
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(8, 0, 12, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 8, 2),
                                  child: Card(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    color:
                                        FlutterFlowTheme.of(context).whiteColor,
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
                                        fadeInDuration:
                                            const Duration(seconds: 1),
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
                                                          color: Color(
                                                              0xFF006D38))),
                                                SizedBox(
                                                    width: 65,
                                                    height: 65,
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
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${snapshot.data![index].fabricante} ${snapshot.data![index].nombre.replaceAll(snapshot.data![index].fabricante, '')}',
                                        style: FlutterFlowTheme.of(context)
                                            .subtitle1
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .subtitle1Family,
                                              fontSize: 15,
                                              useGoogleFonts:
                                                  GoogleFonts.asMap()
                                                      .containsKey(
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .subtitle1Family),
                                            ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(3, 1.4, 0, 1),
                                            child: Text(
                                              'Versión: ${snapshot.data![index].version}',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyText2
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
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
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 0, 0, 1),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(3, 0, 0, 1),
                                              child: Text(
                                                'Licencia ${snapshot.data![index].tipoLicencia}',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyText2
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
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
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 0, 0, 1),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(3, 0, 0, 1),
                                              child: Text(
                                                '${snapshot.data![index].licenciaClave}',
                                                overflow: TextOverflow.ellipsis,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyText2
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
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
                                      if (fechaEntrega.isNotEmpty && prestamo)
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 1),
                                              child: FaIcon(
                                                FontAwesomeIcons.calendar,
                                                color: utilidades
                                                    .defColorCalendario(context,
                                                        fechaEntrega[index]),
                                                size: 10,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(3, 0, 0, 1),
                                              child: AutoSizeText(
                                                fechaEntrega[index],
                                                textAlign: TextAlign.start,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyText2
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          color: utilidades
                                                              .defColorCalendario(
                                                                  context,
                                                                  fechaEntrega[
                                                                      index]),
                                                          fontSize: 9,
                                                          fontWeight:
                                                              FontWeight.w500,
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
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ).animateOnPageLoad(
                    animationsMap['containerOnPageLoadAnimation2']!),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _iconoEliminarEntregar(String fechaEntrega, bool prestamo,
      String idSerial, String idFuncionario) {
    if (prestamo && fechaEntrega.contains('Programado')) {
      return FlutterFlowIconButton(
        borderColor: Colors.transparent,
        borderRadius: 30,
        buttonSize: 46,
        icon: const Icon(
          Icons.cancel,
          color: Color(0xFFE62424),
          size: 24,
        ),
        onPressed: () async {
          var res = await prestamosController.entregarPrestamo(
              context, idFuncionario, idSerial);
          if (res == 'ok') {
            setState(() {});
          }
        },
      );
    } else if (prestamo) {
      return FlutterFlowIconButton(
        borderColor: Colors.transparent,
        borderRadius: 30,
        buttonSize: 46,
        icon: const Icon(
          FontAwesomeIcons.check,
          color: Color.fromARGB(255, 7, 133, 36),
          size: 24,
        ),
        onPressed: () async {
          var res = await prestamosController.entregarPrestamo(
              context, idFuncionario, idSerial);
          if (res == 'ok') {
            setState(() {});
          }
        },
      );
    } else {
      return FlutterFlowIconButton(
        borderColor: Colors.transparent,
        borderRadius: 30,
        buttonSize: 46,
        icon: const Icon(
          Icons.delete_outline,
          color: Color(0xFFE62424),
          size: 24,
        ),
        onPressed: () async {
          var res =
              await activoController.quitarActivoFuncionario(context, idSerial);
          if (res == 'ok') {
            activo = await ActivoController().buscarActivo(activo.idSerial);
            Future.delayed(const Duration(milliseconds: 2000), () {
// Here you can write your code

              setState(() {
                // Here you can write your code for open new view
              });
            });
          }
        },
      );
    }
  }

  Future<List<Funcionario>> cargarFuncionariosPrestamos(String idActivo) async {
    List<Funcionario> listaFuncionarios = [];
    PrestamosController prestamosController = PrestamosController();
    FuncionariosController funcionariosController = FuncionariosController();
    List<Prestamo> listFuncionariosActvos = await prestamosController
        .getActivosPrestados(idActivo: idActivo, soloMostarSinEntregar: true);
    await Future.forEach(listFuncionariosActvos, (Prestamo value) async {
      listaFuncionarios.add(await funcionariosController
          .buscarFuncionarioIndividual(value.idFuncionario));
      listaFechasEntrega.add(
          Utilidades.definirDias(value.fechaHoraInicio, value.fechaHoraFin!));
    });
    Logger().i('Cantidad de activos asignados devueltos:' +
        listaFuncionarios.length.toString());
    return Future.value(listaFuncionarios);
  }

  Future<List<Funcionario>> cargarFuncionariosAsignados(String cedula) async {
    List<Funcionario> listActivosAsignados = [];
    FuncionariosController funcionariosController = FuncionariosController();
    ActivoController activoController = ActivoController();
    List<ActivoFuncionario> listFuncionariosActvos =
        await activoController.getFuncionarioAsignado(activo.idSerial);
    await Future.forEach(listFuncionariosActvos,
        (ActivoFuncionario value) async {
      listActivosAsignados.add(await funcionariosController
          .buscarFuncionarioIndividual(value.idFuncionaro));
    });
    return Future.value(listActivosAsignados);
  }

  Widget _cajaAdvertencia(BuildContext context, mensaje, objetoaEliminar, id) {
    return Align(
      alignment: const AlignmentDirectional(0, 0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 24, 16, 5),
        child: Container(
          width: 450,
          constraints: const BoxConstraints(
            maxWidth: 500,
            maxHeight: 300,
          ),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            boxShadow: const [
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
                          color: Color(0xBFDF2424),
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
                    onPressed: () async {
                      var res =
                          await eliminarObjeto(context, objetoaEliminar, id);
                      if (res.contains('ok')) {
                        Navigator.pop(context);
                      }
                    },
                    text: 'Sí, deseo eliminar este $objetoaEliminar',
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

  Future<String> eliminarObjeto(context, String objeto, String id) async {
    switch (objeto) {
      case 'activo':
        ActivoController activoController = ActivoController();
        final res = await activoController.eliminarActivo(context, id);
        return res;

      default:
        return 'error';
    }
  }

  Future<void> cargarActivo(id) async {
    ActivoController activoController = ActivoController();
    var res = await activoController.buscarActivo(id);
    setState(() {
      activo = res;
    });
  }
}

class myFloatingButton extends StatelessWidget {
  final bool selectMode;
  final String idActivo;
  final BuildContext contextPadre;
  final Activo activo;
  final bool esPrestamo;
  final bool escogerComponente;
  const myFloatingButton(
      {Key? key,
      this.selectMode = false,
      this.idActivo = '',
      required this.contextPadre,
      required this.activo,
      this.esPrestamo = false,
      this.escogerComponente = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!selectMode &&
        !esPrestamo &&
        !escogerComponente &&
        activo.estaAsignado) {
      return Container();
    } else {
      return FloatingActionButton.extended(
        onPressed: () async {
          if (selectMode) {
            if (esPrestamo == false) {
              String? idFuncionario;
              SharedPreferences prefs = await SharedPreferences.getInstance();
              idFuncionario = prefs.getString('id_funcionario');
              ActivoController activoController = ActivoController();
              // ignore: use_build_context_synchronously
              String res = await activoController.asignarActivo(
                  context, idFuncionario!, idActivo);
              // ignore: use_build_context_synchronously
              if (res.contains('ok')) contextPadre.pop();
            } else {
              if (esPrestamo) {
                log('retornando activo');
                Navigator.pop(contextPadre, activo);
              }
            }
          } else {
            if (escogerComponente) {
              Navigator.pop(contextPadre, activo);
            } else {
              final Funcionario? result = await context.pushNamed<Funcionario>(
                'listaSeleccionFuncionariosPage',
              );
              log('Result:' + result.toString());
              if (result != null) {
                // ignore: use_build_context_synchronously
                await ActivoController()
                    .asignarActivo(context, result.cedula, idActivo);
              }
            }
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
          (selectMode || escogerComponente == true)
              ? 'Asignar este activo'
              : 'Asignar funcionario',
          style: FlutterFlowTheme.of(context).bodyText1.override(
                fontFamily: FlutterFlowTheme.of(context).bodyText1Family,
                color: FlutterFlowTheme.of(context).whiteColor,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).bodyText1Family),
              ),
        ),
      );
    }
  }
}

class ListaFuncionariosAsignados extends StatelessWidget {
  const ListaFuncionariosAsignados({
    Key? key,
    required this.animationsMap,
  }) : super(key: key);

  final Map<String, AnimationInfo> animationsMap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 5, 20, 4),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 88,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primaryBackground,
          boxShadow: const [
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
                        child: Image.network(
                          'https://la-jagua-de-ibirico.micolombiadigital.gov.co/sites/la-jagua-de-ibirico/content/files/000435/21702_garcia-guerra-yain-alfonso_1024x600.JPG',
                          width: 73,
                          height: 70,
                          fit: BoxFit.cover,
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
                          'Nombre',
                          style: FlutterFlowTheme.of(context)
                              .subtitle1
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .subtitle1Family,
                                fontSize: 16,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .subtitle1Family),
                              ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 1.4, 0, 1),
                          child: Text(
                            'Cargo',
                            style: FlutterFlowTheme.of(context)
                                .bodyText2
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyText2Family,
                                  fontSize: 14,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .bodyText2Family),
                                ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 1),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'Area',
                                style: FlutterFlowTheme.of(context)
                                    .bodyText2
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyText2Family,
                                      fontSize: 14,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .bodyText2Family),
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
                    onPressed: () {
                      print('IconButton pressed ...');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!),
    );
  }
}

class TituloListafFuncionariosAsignados extends StatelessWidget {
  const TituloListafFuncionariosAsignados({
    Key? key,
    required this.animationsMap,
  }) : super(key: key);

  final Map<String, AnimationInfo> animationsMap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24, 8, 24, 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
            child: Text(
              'FUNCIONARIO ASIGNADO',
              style: FlutterFlowTheme.of(context).bodyText2.override(
                    fontFamily: 'Poppins',
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    useGoogleFonts: GoogleFonts.asMap().containsKey(
                        FlutterFlowTheme.of(context).bodyText2Family),
                  ),
            ),
          ),
        ],
      ).animateOnPageLoad(animationsMap['rowOnPageLoadAnimation7']!),
    );
  }
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

String definirEstadoActivo(int? estado) {
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
