import 'dart:developer';

import 'package:app_gestion_prestamo_inventario/entidades/activo.dart';
import 'package:app_gestion_prestamo_inventario/entidades/categoria.dart';
import 'package:app_gestion_prestamo_inventario/entidades/funcionario.dart';
import 'package:app_gestion_prestamo_inventario/servicios/activoController.dart';
import 'package:app_gestion_prestamo_inventario/vistas/lista_funcionarios_page/lista_funcionarios_page_widget.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../entidades/area.dart';
import '../../servicios/funcionariosController.dart';
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

class ListaSeleccionFuncionariosPageWidget extends StatefulWidget {
  const ListaSeleccionFuncionariosPageWidget({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ListaSeleccionFuncionariosPageWidgetState createState() =>
      _ListaSeleccionFuncionariosPageWidgetState();
}

class _ListaSeleccionFuncionariosPageWidgetState
    extends State<ListaSeleccionFuncionariosPageWidget> {
  TextEditingController? textControllerBusqueda;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  var id = '';
  var a;
  ActivoController activoController = ActivoController();
  List<Funcionario> listaFuncionario = [];
  bool? esPrestamo;

  @override
  void initState() {
    super.initState();
    setState(() {});
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
                    .then((value) async {
                  if (value != null) {
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
                          ),
                          'selectMode': serializeParam(
                            false,
                            ParamType.bool,
                          ),
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
                          'esPrestamo': serializeParam(
                            esPrestamo,
                            ParamType.bool,
                          ),
                        },
                      );
                    }
                    setState(() {});
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
            iconTheme:
                IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
            automaticallyImplyLeading: false,
            title: AutoSizeText(
              'Funcionarios',
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
                onPressed: () async {},
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
                                child: FutureBuilder<List<Funcionario>>(
                                    future: cargarFuncionarios(
                                        textControllerBusqueda),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData ||
                                          snapshot.hasError ||
                                          snapshot.data!.isEmpty)
                                        return Container();

                                      listaFuncionario.clear();
                                      snapshot.data!.forEach((data) {
                                        listaFuncionario.add(data);
                                        log('Añadiendo activo: ${data.nombres}');
                                        Text(data.nombres.toString());
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
                                              final Funcionario? result =
                                                  await context
                                                      .pushNamed<Funcionario>(
                                                'funcionarioPerfilPage',
                                                queryParams: {
                                                  'funcionario': serializeParam(
                                                    snapshot.data![index],
                                                    ParamType.Funcionario,
                                                  ),
                                                  'area': serializeParam(
                                                    Area(
                                                        id: 1,
                                                        nombre:
                                                            'Oficina de las TICs',
                                                        urlImagen: ''),
                                                    ParamType.Area,
                                                  ),
                                                  'selectMode': serializeParam(
                                                    true,
                                                    ParamType.bool,
                                                  ),
                                                },
                                              );
                                              if (result != null) {
                                                // ignore: use_build_context_synchronously
                                                context.pop(result);
                                              }

                                              setState(() {});
                                            },
                                            child: tarjetaActivo(
                                                context, snapshot.data![index]),
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
}

Widget tarjetaActivo(context, Funcionario funcionario) {
  Area area = Area();
  return GestureDetector(
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
                  child: (funcionario.urlImagen.isEmpty)
                      ? Text('No disponible')
                      : FastCachedImage(
                          width: 80,
                          height: 80,
                          url: funcionario.urlImagen,
                          fit: BoxFit.cover,
                          fadeInDuration: const Duration(seconds: 1),
                          errorBuilder: (context, exception, stacktrace) {
                            log(stacktrace.toString());
                            return Text('ERROR');
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
                                          value: progress
                                              .progressPercentage.value)),
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
                        (funcionario.apellidos != null &&
                                funcionario.apellidos!.isNotEmpty)
                            ? '${funcionario.nombres.split(' ')[0]} ${funcionario.apellidos!.split(' ')[0]}'
                            : funcionario.nombres,
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
                          funcionario.cargo,
                          textAlign: TextAlign.start,
                          style: FlutterFlowTheme.of(context)
                              .bodyText2
                              .override(
                                fontFamily: 'Poppins',
                                color: FlutterFlowTheme.of(context).grayicon,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyText2Family),
                              ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 4, 8, 0),
                        child: FutureBuilder<Area>(
                          future: cargarArea(funcionario.idArea),
                          initialData: area,
                          builder: ((context, snapshot) {
                            area = snapshot.data!;
                            return AutoSizeText(
                              snapshot.data!.nombre,
                              textAlign: TextAlign.start,
                              style: FlutterFlowTheme.of(context)
                                  .bodyText2
                                  .override(
                                    fontFamily: 'Poppins',
                                    color:
                                        FlutterFlowTheme.of(context).grayicon,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    useGoogleFonts: GoogleFonts.asMap()
                                        .containsKey(
                                            FlutterFlowTheme.of(context)
                                                .bodyText2Family),
                                  ),
                            );
                          }),
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

Future<Area> cargarArea(id) async {
  FuncionariosController funcionariosController = FuncionariosController();
  Area area = await funcionariosController.buscarArea(id.toString());
  return area;
}
