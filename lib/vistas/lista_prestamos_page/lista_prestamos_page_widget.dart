import 'dart:developer';

import 'package:app_gestion_prestamo_inventario/assets/utilidades.dart';
import 'package:app_gestion_prestamo_inventario/entidades/activo.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:logger/logger.dart';

import '../../entidades/prestamo.dart';
import '../../servicios/activoController.dart';
import '../../servicios/prestamosController.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  List<String> _listadiasPendientes = [];
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
              context.pushNamed('resgistrarPrestamosPage');
            },
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primaryColor,
        iconTheme:
            IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
        automaticallyImplyLeading: false,
        title: AutoSizeText(
          'Préstamo de activos',
          style: FlutterFlowTheme.of(context).bodyText1.override(
                fontFamily: FlutterFlowTheme.of(context).bodyText1Family,
                color: FlutterFlowTheme.of(context).whiteColor,
                fontSize: 28,
                fontWeight: FontWeight.w600,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).bodyText1Family),
              ),
        ),
        actions: [
          /*
          FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30,
            borderWidth: 1,
            buttonSize: 60,
            icon: Icon(
              Icons.notifications_none,
              color: FlutterFlowTheme.of(context).whiteColor,
              size: 30,
            ),
            onPressed: () {},
          ),*/
        ],
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
                            padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 12, 0, 0),
                                    child: TextFormField(
                                      controller: textController,
                                      onChanged: (_) => EasyDebounce.debounce(
                                        'textController',
                                        Duration(milliseconds: 2000),
                                        () => setState(() {}),
                                      ),
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        labelText: 'Buscar funcionario...',
                                        labelStyle: FlutterFlowTheme.of(context)
                                            .bodyText2
                                            .override(
                                              fontFamily: 'Poppins',
                                              color: Color(0xFF57636C),
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal,
                                              useGoogleFonts: GoogleFonts.asMap()
                                                  .containsKey(
                                                      FlutterFlowTheme.of(context)
                                                          .bodyText2Family),
                                            ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            width: 1,
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
                                        fillColor: FlutterFlowTheme.of(context)
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
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(
                                                    FlutterFlowTheme.of(context)
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
                            padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                            child: FutureBuilder<List<Activo>>(
                                future: cargarActivosPrestados(),
                                builder: (BuildContext context, snapshot) {
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
                                        return Opacity(
                                          opacity: (_listadiasPendientes[index]
                                                  .contains('Entregado'))
                                              ? 0.4
                                              : 1.0,
                                          child: tarjetaItem(
                                              snapshot.data![index],
                                              _listadiasPendientes[index]),
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

  Future<List<Activo>> cargarActivosPrestados() async {
    List<Activo> _listActivos = [];
    _listadiasPendientes = [];
    PrestamosController prestamosController = PrestamosController();
    ActivoController activoController = ActivoController();
    List<Prestamo> listFuncionariosActvos =
        await prestamosController.getActivosPrestados();
    Logger()
        .i('Cantidad de activos asignados:${listFuncionariosActvos.length}');
    await Future.forEach(listFuncionariosActvos, (Prestamo value) async {
      _listActivos.add(await activoController.buscarActivo(value.idActivo));
      if (value.entregado) {
        _listadiasPendientes.add('Entregado');
      } else {
        _listadiasPendientes.add(Utilidades.definirDias(
            value.fechaHoraInicio, value.fechaHoraEntrega!));
      }
    });

    return Future.value(_listActivos);
  }
}

class tarjetaItem extends StatelessWidget {
  final Activo activo;
  final String diasPendientes;
  Utilidades utilidades = Utilidades();
  tarjetaItem(this.activo, this.diasPendientes, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          'activoPerfilPage',
          queryParams: {
            'idActivo': serializeParam(
              activo.idSerial,
              ParamType.String,
            ),
            'selectMode': serializeParam(
              false,
              ParamType.bool,
            ),
            'esPrestamo': serializeParam(
              false,
              ParamType.bool,
            ),
          },
        );
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
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(3, 0, 0, 0),
                              child: FaIcon(
                                FontAwesomeIcons.barcode,
                                color: FlutterFlowTheme.of(context).grayicon,
                                size: 15,
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(5, 3, 8, 1),
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
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(3, 0, 0, 0),
                              child: FaIcon(
                                FontAwesomeIcons.calendar,
                                color: utilidades.defColorCalendario(
                                    context, diasPendientes),
                                size: 18,
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(5, 3, 8, 1),
                              child: AutoSizeText(
                                diasPendientes,
                                textAlign: TextAlign.start,
                                style: FlutterFlowTheme.of(context)
                                    .bodyText2
                                    .override(
                                      fontFamily: 'Poppins',
                                      color: utilidades.defColorCalendario(
                                          context, diasPendientes),
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
