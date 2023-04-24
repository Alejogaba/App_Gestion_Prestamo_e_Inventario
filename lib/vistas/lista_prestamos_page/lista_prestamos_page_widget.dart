import 'dart:developer';

import 'package:app_gestion_prestamo_inventario/assets/utilidades.dart';
import 'package:app_gestion_prestamo_inventario/entidades/activo.dart';
import 'package:app_gestion_prestamo_inventario/vistas/lista_hojas_salida_page/lista_hojas_salida_page_widget.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:logger/logger.dart';

import '../../entidades/prestamo.dart';
import '../../servicios/activoController.dart';
import '../../servicios/prestamosController.dart';
import '../activo_perfil_page/activo_perfil_page_widget.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ListaPrestamosPageWidget extends StatefulWidget {
  const ListaPrestamosPageWidget({Key? key}) : super(key: key);

  @override
  _ListaPrestamosPageWidgetState createState() =>
      _ListaPrestamosPageWidgetState();
}

class _ListaPrestamosPageWidgetState extends State<ListaPrestamosPageWidget> {
  TextEditingController? textController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<Activo> listActivos = [];
  List<String> _listadiasSalidas = [];
  List<String> _listadiasPendientes = [];
  List<String> _listadiasEntregado = [];
  List<String> _listaEstado = [];
  Utilidades utilidades = Utilidades();

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  @override
  void dispose() {
    textController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50.0, right: 16),
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: FlutterFlowTheme.of(context).primaryColor,
          elevation: 123,
          child: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30,
            borderWidth: 1,
            buttonSize: 60,
            icon: Icon(
              Icons.add,
              color: FlutterFlowTheme.of(context).whiteColor,
              size: 30,
            ),
            onPressed: () {
              context.pushNamed('resgistrarPrestamosPage').then((value) {
                Future.delayed(Duration(milliseconds: 500), () {
                  setState(() {});
                });
              });
            },
          ),
        ),
      ),
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 6.0, right: 8.0),
            child: GestureDetector(
              onTap: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ListaHojaSalidaPageWidget(),
                    ));
              },
              child: Column(
                children: [
                  FaIcon(
                    FontAwesomeIcons.file,
                    color: FlutterFlowTheme.of(context).whiteColor,
                    size: 30,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Hojas de salida',
                    style: FlutterFlowTheme.of(context).bodyText1.copyWith(
                          color: FlutterFlowTheme.of(context).whiteColor,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
        backgroundColor: FlutterFlowTheme.of(context).primaryColor,
        iconTheme:
            IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
        automaticallyImplyLeading: false,
        title: AutoSizeText(
          'Préstamos',
          style: FlutterFlowTheme.of(context).bodyText1.override(
                fontFamily: FlutterFlowTheme.of(context).bodyText1Family,
                color: FlutterFlowTheme.of(context).whiteColor,
                fontSize: 28,
                fontWeight: FontWeight.w600,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).bodyText1Family),
              ),
        ),
        centerTitle: false,
        elevation: 4,
      ),
      body: SafeArea(
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
                            padding:
                                EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [],
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                            child: FutureBuilder<List<Activo>>(
                                future: cargarActivosPrestados(),
                                builder: (BuildContext context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return _loading(context);
                                  } else if (snapshot.connectionState ==
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
                                        return Opacity(
                                          opacity: (snapshot.data![index]
                                                      .estaPrestado ==
                                                  false)
                                              ? 0.4
                                              : 1.0,
                                          child: GestureDetector(
                                            onTap: () async {
                                              final e = await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ActivoPerfilPageWidget(
                                                    activo:
                                                        snapshot.data![index],
                                                    selectMode: false,
                                                    esPrestamo: false,
                                                    escogerComponente: false,
                                                  ),
                                                ),
                                              ).then((value) {
                                                Future.delayed(
                                                    Duration(milliseconds: 500),
                                                    () {
                                                  setState(() {});
                                                });
                                              });
                                            },
                                            child: tarjetaItem(
                                                snapshot.data![index],
                                                _listadiasPendientes[index],
                                                _listadiasSalidas[index],
                                                _listadiasEntregado[index]),
                                          ),
                                        );
                                      },
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
        ),
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

  Future<List<Activo>> cargarActivosPrestados() async {
    late List<Activo> _listActivos = [];
    _listadiasPendientes = [];
    _listadiasEntregado = [];
    _listadiasSalidas = [];
    PrestamosController prestamosController = PrestamosController();
    ActivoController activoController = ActivoController();
    List<Prestamo> listFuncionariosActvos =
        await prestamosController.getActivosPrestados();
    Logger()
        .i('Cantidad de activos asignados:${listFuncionariosActvos.length}');
    await Future.forEach(listFuncionariosActvos, (Prestamo value) async {
      _listActivos.add(await activoController.buscarActivo(value.idActivo));

      _listadiasSalidas.add(
          'Fecha salida: ${DateFormat.MMMMd('es_US').format(value.fechaHoraInicio)}');
      if (value.entregado) {
        _listadiasPendientes.add(
            'Fecha entrega: ${DateFormat.MMMMd('es_US').format(value.fechaHoraFin!)}');
        _listadiasEntregado.add(
            'Se entrego el ${DateFormat.MMMMd('es_US').format(value.fechaHoraEntregado!)}');
      } else {
        _listadiasPendientes.add(
            Utilidades.definirDias(value.fechaHoraInicio, value.fechaHoraFin!));
        _listadiasEntregado.add('');
      }
    });

    return Future.value(_listActivos);
  }
}

class tarjetaItem extends StatelessWidget {
  final Activo activo;
  final String diaPendiente;
  final String diaSalida;
  final String diaEntregado;
  Utilidades utilidades = Utilidades();
  tarjetaItem(this.activo, this.diaPendiente, this.diaSalida, this.diaEntregado,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  borderRadius: BorderRadius.circular(6),
                  child: FastCachedImage(
                    width: 100,
                    height: 100,
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
                        color: FlutterFlowTheme.of(context).secondaryBackground,
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
                                    value: progress.progressPercentage.value)),
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
                        '${activo.nombre} ${activo.detalles}',
                        overflow: TextOverflow.ellipsis,
                        style: FlutterFlowTheme.of(context).title3.override(
                              fontFamily: 'Poppins',
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              useGoogleFonts: GoogleFonts.asMap().containsKey(
                                  FlutterFlowTheme.of(context).title3Family),
                            ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(3, 0, 0, 0),
                            child: FaIcon(
                              FontAwesomeIcons.barcode,
                              color: FlutterFlowTheme.of(context).grayicon,
                              size: 15,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(5, 3, 8, 1),
                            child: AutoSizeText(
                              ' ${activo.idSerial}',
                              textAlign: TextAlign.start,
                              style: FlutterFlowTheme.of(context)
                                  .bodyText2
                                  .override(
                                    fontFamily: 'Poppins',
                                    color:
                                        FlutterFlowTheme.of(context).grayicon,
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
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(3, 0, 0, 0),
                            child: FaIcon(
                              FontAwesomeIcons.calendar,
                              color: FlutterFlowTheme.of(context).grayicon,
                              size: 18,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(5, 3, 8, 1),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.49,
                              child: AutoSizeText(
                                diaSalida,
                                maxFontSize: 15,
                                minFontSize: 10,
                                maxLines: 2,
                                textAlign: TextAlign.start,
                                style: FlutterFlowTheme.of(context)
                                    .bodyText2
                                    .override(
                                      fontFamily: 'Poppins',
                                      color:
                                          FlutterFlowTheme.of(context).grayicon,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .bodyText2Family),
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (activo.estaPrestado)
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(3, 0, 0, 0),
                              child: FaIcon(
                                FontAwesomeIcons.calendar,
                                color: (diaEntregado.isNotEmpty)
                                    ? FlutterFlowTheme.of(context).grayicon
                                    : utilidades.defColorCalendario(
                                        context, diaPendiente),
                                size: 18,
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(5, 3, 8, 1),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.49,
                                child: AutoSizeText(
                                  diaPendiente,
                                  maxFontSize: 15,
                                  minFontSize: 10,
                                  textAlign: TextAlign.start,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyText2
                                      .override(
                                        fontFamily: 'Poppins',
                                        color: utilidades.defColorCalendario(
                                            context, diaPendiente),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyText2Family),
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (!activo.estaPrestado)
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(3, 0, 0, 0),
                              child: FaIcon(
                                FontAwesomeIcons.calendar,
                                color: (diaEntregado.isNotEmpty)
                                    ? FlutterFlowTheme.of(context).grayicon
                                    : const Color.fromARGB(255, 6, 113, 122),
                                size: 18,
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(5, 3, 8, 1),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.49,
                                child: AutoSizeText(
                                  diaEntregado,
                                  maxFontSize: 15,
                                  minFontSize: 10,
                                  textAlign: TextAlign.start,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyText2
                                      .override(
                                        fontFamily: 'Poppins',
                                        color: (diaEntregado.isNotEmpty)
                                            ? FlutterFlowTheme.of(context)
                                                .grayicon
                                            : const Color.fromARGB(
                                                255, 6, 113, 122),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyText2Family),
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
    );
  }
}
