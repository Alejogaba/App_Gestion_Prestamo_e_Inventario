import 'dart:developer';

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
        padding: const EdgeInsets.only(bottom: 50.0),
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
          ),
        ],
        centerTitle: false,
        elevation: 4,
      ),
      body: GestureDetector(
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
                                      log(_listadiasPendientes[index]);
                                      return tarjetaItem(snapshot.data![index],
                                          _listadiasPendientes[index]);
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
      log('fecha salidas: ${value.fechaHoraInicio}');
      log('fecha entrega: ${value.fechaHoraEntrega.toString()}');
      _listadiasPendientes
          .add(_definirDias(value.fechaHoraInicio, value.fechaHoraEntrega!));
    });

    return Future.value(_listActivos);
  }
}

class tarjetaItem extends StatelessWidget {
  final Activo activo;
  final String diasPendientes;
  const tarjetaItem(this.activo, this.diasPendientes, {Key? key})
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
                              'S/N: ${activo.idSerial}',
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
                              FontAwesomeIcons.userTie,
                              color: FlutterFlowTheme.of(context).grayicon,
                              size: 18,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(5, 3, 8, 1),
                            child: AutoSizeText(
                              diasPendientes,
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

String _definirDias(DateTime inicio, DateTime fin) {
  DateTimeRange rango;
  bool progamadoaFuturo= false;
  bool atrasado= false;
  DateTime now = DateTime.now();
  int duracion;
  if (inicio.isAfter(now)) {
    progamadoaFuturo = true;
  } else if(fin.isBefore(now)){
    atrasado = true;
  }
  if (progamadoaFuturo) {
    rango =
        DateTimeRange(start: now, end: inicio);
    duracion = rango.duration.inDays;
    if (duracion<8) {
      switch (duracion) {
      case 1:
        return 'Programado para mañana';
      case 2:
        return 'programado para pasado manñana';
      default:
        return 'Progamado para el ${definirDiaSemana(inicio.weekday)}';
    }
    } else {
       return 'Progamado para dentro de $duracion días';
    }
  } else if(atrasado){
    rango =
        DateTimeRange(start: fin, end: now);
    duracion = rango.duration.inDays;
    if (duracion<8) {
      switch (duracion) {
        case 1:
          return 'Debia entregarse ayer';
        case 2:
          return 'Debia entregarse antier';
        default:
          return 'Debia entregarse el ${definirDiaSemana(fin.weekday)}';
      }
    } else {
       return 'Debia entregarse hace $duracion días';
    }
      
    
  } else{
    rango =
        DateTimeRange(start: now, end: fin);
    duracion = rango.duration.inDays;
    if (duracion<8) {
      switch (duracion) {
        case 0:
          return 'Para entregar hoy';
        case 1:
          return 'Para entregar mañana';
        case 2:
          return 'Para entregar pasado mañana';
        default:
          return 'Para entregar el ${definirDiaSemana(fin.weekday)}';
      }
    } else {
      return 'Para entregar dentro de $duracion días';
    }
      
    
  }

  
}
  String definirDiaSemana(int numeroSemana) {
    switch (numeroSemana) {
      case 1:
        return "Lunes";
        break;
      case 2:
        return "Martes";
        break;
      case 3:
        return "Miercoles";
      case 4:
        return "Jueves";
        break;
      case 5:
        return "Viernes";
        break;
      case 6:
        return "Sábado";
        break;
      case 7:
        return "Domingo";
        break;
      default:
        return "Indefinido";
    }
  }

  String definirMes(int numMes) {
    switch (numMes) {
      case 1:
        return "Enero";
        break;
      case 2:
        return "Febrero";
        break;
      case 3:
        return "Marzo";
      case 4:
        return "Abril";
        break;
      case 5:
        return "Mayo";
        break;
      case 6:
        return "Junio";
        break;
      case 7:
        return "Julio";
        break;
      case 8:
        return "Agosto";
        break;
      case 9:
        return "Septiembre";
        break;
      case 10:
        return "Octubre";
        break;
      case 11:
        return "Noviembre";
        break;
      case 12:
        return "Diciembre";
        break;
      default:
        return "Indefinido";
    }
  }
