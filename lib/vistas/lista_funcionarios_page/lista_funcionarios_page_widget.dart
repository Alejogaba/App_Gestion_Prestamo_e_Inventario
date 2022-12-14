import 'dart:developer';
import 'dart:io';

import 'package:app_gestion_prestamo_inventario/entidades/area.dart';
import 'package:app_gestion_prestamo_inventario/entidades/funcionario.dart';
import 'package:app_gestion_prestamo_inventario/servicios/funcionariosController.dart';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

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

import 'package:path_provider/path_provider.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';

class ListaFuncionariosPageWidget extends StatefulWidget {
  const ListaFuncionariosPageWidget({Key? key}) : super(key: key);

  @override
  _ListaFuncionariosPageWidgetState createState() =>
      _ListaFuncionariosPageWidgetState();
}

class _ListaFuncionariosPageWidgetState
    extends State<ListaFuncionariosPageWidget> {
  TextEditingController? textControllerBusqueda;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String textDial = 'Buscar por código de barras';
  List<Funcionario> listFuncionariosLocal = [];
  FuncionariosController funcionariosController = FuncionariosController();
  late final listaFuncioarios = cargarFuncionarios(textControllerBusqueda);

  late final storageLocation = rutaArchivostemporales();
  @override
  void initState() {
    super.initState();
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
            SpeedDialChild(
              //speed dial child
              child: Icon(FontAwesomeIcons.barcode),
              backgroundColor: Color.fromARGB(255, 7, 133, 36),
              foregroundColor: Colors.white,
              label: 'Buscar por código de barras',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () async {
               /* var res = await scanCnic(ImageSource.camera);

                log('https://pub.dev/packages/barcode_scan2/install');*/
              },
            ),
            SpeedDialChild(
              child: Icon(Icons.add),
              backgroundColor: Color.fromARGB(255, 7, 133, 107),
              foregroundColor: Colors.white,
              label: 'Registrar nuevo activo',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => context.pushNamed(
                'registrarfuncionariopage',
              ),
            ),

            //add more menu item childs here
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            pinned: true,
            floating: false,
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
                icon: Icon(
                  Icons.notifications_none,
                  color: FlutterFlowTheme.of(context).whiteColor,
                  size: 30,
                ),
                onPressed: () {
                  print('IconButton pressed ...');
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
                                            'textControllerBusqueda',
                                            Duration(milliseconds: 2000),
                                            () => setState(() {}),
                                          ),
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: 'Buscar funcionario...',
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
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                                child: FutureBuilder<List<Funcionario>>(
                                  future: cargarFuncionarios(
                                      textControllerBusqueda),
                                  builder: ((context, snapshot) {
                                    int i = 0;
                                    List<Widget> temp = [];

                                    log('Estado de conexion connctionState:$snapshot.connectionState');

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
                                          return tarjetaFuncionario(
                                              snapshot.data![index]);
                                        },
                                      );
                                    } else if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return loading(context);
                                    } else if (snapshot.hasError) {
                                      log('Error: ${snapshot.error}');
                                      return Container();
                                    } else {
                                      log('Error de conexion: ${snapshot.error}');
                                    }

                                    return Container();
                                  }),
                                ),
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
/*
  Future<void> scanCnic(ImageSource imageSource) async {
    /// you will need to pass one argument of "ImageSource" as shown here
    CnicModel cnicModel =
        await CnicScanner().scanImage(imageSource: imageSource);
    if (cnicModel == null) return;
    setState(() {
      textDial = cnicModel.cnicHolderName;
      log(cnicModel.cnicHolderName);
    });
  }
*/
  static Future<String> rutaArchivostemporales() async {
    var _tempDirectory = await getTemporaryDirectory();
    return _tempDirectory.path;
  }
}

Future<List<Funcionario>> cargarFuncionarios(
    TextEditingController? terminobusqueda) async {
  FuncionariosController funcionariosController = FuncionariosController();
  List<Funcionario> listFuncionariosLocal =
      await funcionariosController.getFuncionarios(terminobusqueda!.text);
  return Future.value(listFuncionariosLocal);
}

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

class tarjetaFuncionario extends StatelessWidget {
  final Funcionario funcionario;
  const tarjetaFuncionario(
    this.funcionario, {
    Key? key,
  }) : super(key: key);

  @override
  void initState() {}
  @override
  Widget build(BuildContext context) {
    Area area = Area(id: 1, nombre: 'Área', urlImagen: '');
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          'funcionarioPerfilPage',
          queryParams: {
            'funcionario': serializeParam(
              funcionario,
              ParamType.Funcionario,
            ),
            'area': serializeParam(
              Area(id: 1, nombre: 'Oficina de las TICs',urlImagen: ''),
              ParamType.Area,
            )
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
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
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
}

Future<Area> cargarArea(id) async {
  FuncionariosController funcionariosController = FuncionariosController();
  Area area = await funcionariosController.buscarArea(id.toString());
  return area;
}
