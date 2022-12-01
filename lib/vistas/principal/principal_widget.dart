import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

import '../../entidades/categoria.dart';
import '../../servicios/categoriaController.dart';

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

class PrincipalWidget extends StatefulWidget {
  const PrincipalWidget({
    Key? key,
    this.selectMode,
  }) : super(key: key);

  final bool? selectMode;

  @override
  _PrincipalWidgetState createState() => _PrincipalWidgetState();
}

class _PrincipalWidgetState extends State<PrincipalWidget> {
  TextEditingController? searchController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  CategoriaController categoriaController = CategoriaController();
  List<Categoria> listCategoriasLocal = [];
  String busquedaCategoria = '';
  late final listaCategoriasOnline = cargarCategorias();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final prefs = SharedPreferences.getInstance();
  bool local = false;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    _cargarlistaLocal();
  }

  @override
  void dispose() {
    searchController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      drawer: Drawer(
        elevation: 16,
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
          ),
        ),
      ),
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
            SpeedDialChild(
              //speed dial child
              child: Icon(FontAwesomeIcons.barcode),
              backgroundColor: Color.fromARGB(255, 7, 133, 36),
              foregroundColor: Colors.white,
              label: 'Buscar por código de barras',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => print('FIRST CHILD'),
            ),
            SpeedDialChild(
              child: Icon(Icons.add),
              backgroundColor: Color.fromARGB(255, 7, 133, 107),
              foregroundColor: Colors.white,
              label: 'Registrar nuevo activo',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => context.pushNamed('registraractivopage'),
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
            pinned: false,
            floating: true,
            snap: false,
            backgroundColor: FlutterFlowTheme.of(context).primaryColor,
            iconTheme:
                IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
            automaticallyImplyLeading: false,
            title: AutoSizeText(
              'Bienvenido',
              style: FlutterFlowTheme.of(context).bodyText1.override(
                    fontFamily: FlutterFlowTheme.of(context).bodyText1Family,
                    color: FlutterFlowTheme.of(context).tertiaryColor,
                    fontSize: 28,
                    fontWeight: FontWeight.normal,
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
                  color: FlutterFlowTheme.of(context).tertiaryColor,
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
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16, 12, 16, 0),
                                child: TextFormField(
                                  controller: searchController,
                                  onChanged: (value) => EasyDebounce.debounce(
                                    'textController',
                                    const Duration(milliseconds: 1000),
                                    () => setState(() {
                                      busquedaCategoria = value;
                                    }),
                                  ),
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelText: 'Buscar categoria...',
                                    labelStyle: FlutterFlowTheme.of(context)
                                        .bodyText2
                                        .override(
                                          fontFamily: 'Outfit',
                                          color: Color(0xFF57636C),
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyText2Family),
                                        ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
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
                                    fillColor: Colors.white,
                                    prefixIcon: Icon(
                                      Icons.search_rounded,
                                      color: Color(0xFF57636C),
                                    ),
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyText1
                                      .override(
                                        fontFamily: 'Outfit',
                                        color: Color(0xFF14181B),
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyText1Family),
                                      ),
                                  maxLines: null,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16, 8, 16, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 4, 0, 4),
                                      child: Text(
                                        'Categories',
                                        style: FlutterFlowTheme.of(context)
                                            .subtitle2
                                            .override(
                                              fontFamily: 'Outfit',
                                              color: Color(0xFF57636C),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              useGoogleFonts:
                                                  GoogleFonts.asMap()
                                                      .containsKey(
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .subtitle2Family),
                                            ),
                                      ),
                                    ),
                                    Text(
                                      'See All',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .override(
                                            fontFamily: 'Outfit',
                                            color: Color(0xFF14181B),
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(
                                                    FlutterFlowTheme.of(context)
                                                        .bodyText1Family),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              FutureBuilder<List<Categoria>>(
                                future: listaCategoriasOnline,
                                builder: ((context, snapshot) {
                                  int i = 0;
                                  List<Widget> temp = [];

                                  log('Estado de conexion connctionState:$snapshot.connectionState');

                                  if (snapshot.connectionState ==
                                          ConnectionState.done &&
                                      snapshot.data!.length > 0) {
                                    log('Cargando lista Online');
                                    _guardarlistaLocal(snapshot.data);
                                    return Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16, 16, 16, 0),
                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          log(constraints.maxWidth.toString());
                                          return GridView.builder(
                                            shrinkWrap: true,
                                            itemCount: snapshot.data!.length,
                                            itemBuilder: (context, index) {
                                              var temp = itemCategoria(
                                                  context,
                                                  snapshot.data![index].nombre,
                                                  snapshot
                                                      .data![index].urlImagen,
                                                  constraints.maxWidth);
                                              return temp;
                                            },
                                            scrollDirection: Axis.vertical,
                                            padding: EdgeInsets.zero,
                                            gridDelegate:
                                                // ignore: prefer_const_constructors
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount:
                                                        defCantidadColumnas(
                                                            constraints
                                                                .maxWidth),
                                                    mainAxisSpacing: 10,
                                                    crossAxisSpacing: 10,
                                                    childAspectRatio: 1.4),
                                          );
                                        },
                                      ),
                                    );
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    for (var element in listCategoriasLocal) {
                                      print(
                                          'Lista LOCAL categoria nombre: + ${element.nombre}');
                                      print(
                                          'Lista LOCAL categoria url: ${element.urlImagen}');
                                    }
                                    log('Usando cache local');

                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16, 16, 16, 0),
                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          log(constraints.maxWidth.toString());
                                          return GridView.builder(
                                            shrinkWrap: true,
                                            itemCount:
                                                listCategoriasLocal.length,
                                            itemBuilder: (context, index) {
                                              var temp = itemCategoria(
                                                  context,
                                                  listCategoriasLocal[index]
                                                      .nombre,
                                                  listCategoriasLocal[index]
                                                      .urlImagen,
                                                  constraints.maxWidth);
                                              return temp;
                                            },
                                            scrollDirection: Axis.vertical,
                                            padding: EdgeInsets.zero,
                                            gridDelegate:
                                                // ignore: prefer_const_constructors
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount:
                                                        defCantidadColumnas(
                                                            constraints
                                                                .maxWidth),
                                                    mainAxisSpacing: 10,
                                                    crossAxisSpacing: 10,
                                                    childAspectRatio: 1.4),
                                          );
                                        },
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    log('Error: ${snapshot.error}');
                                    return Container();
                                  } else {
                                    log('Error de conexion: ${snapshot.error}');
                                  }
                                  for (var element in listCategoriasLocal) {
                                    print(
                                        'Lista LOCAL categoria nombre: + ${element.nombre}');
                                    print(
                                        'Lista LOCAL categoria url: ${element.urlImagen}');
                                  }
                                  log('Usando cache local');
                                  return Container();
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

  Future<List<Categoria>> cargarCategorias() async {
    listCategoriasLocal =
        await categoriaController.getCategorias(busquedaCategoria);
    for (var element in listCategoriasLocal) {
      print('Lista categoria nombre: + ${element.nombre}');
      print('Lista categoria url: ${element.urlImagen}');
    }
    return Future.value(listCategoriasLocal);
  }

  Future<void> _guardarlistaLocal(List<Categoria>? listaOnline) async {
    final SharedPreferences prefs = await _prefs;

    if (listaOnline != null && listaOnline.isNotEmpty) {
      var listCategoriasJson = json.encode(listaOnline
          .map<Map<String, dynamic>>((categoria) => Categoria.toMap(categoria))
          .toList());
      await prefs.setString('listaCategorias', listCategoriasJson);
      log('Codificando listaCategoriasJson');
    }
  }

  Future<void> _cargarlistaLocal() async {
    final SharedPreferences prefs = await _prefs;
    final String? listaCategoriasJson = prefs.getString('listaCategorias');
    if (listaCategoriasJson != null) {
      setState(() {
        log('Decodificando listaCategoriasJson');
        listCategoriasLocal = Categoria.decode(listaCategoriasJson);
      });
    }
  }
}

Widget itemCategoria(
    BuildContext context, String? nombre, String? url, constraints) {
  log("Dibujando item categoria");

  return GestureDetector(
    onTap: () {
      log('Nombre Categoria: $nombre');
      context.pushNamed(
        'listaActivosPage',
        params: <String, String>{
          'nombreCategoria': nombre!,
        },
      );
    },
    child: Padding(
      padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
      child: Container(
        //MediaQuery.of(context).size.width * 0.45,
        width: 10,
        height: 10,
        constraints: const BoxConstraints(
          maxWidth: 10,
          maxHeight: 10,
        ),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: FlutterFlowTheme.of(context).boxShadow,
              offset: const Offset(0, 2),
            )
          ],
          borderRadius: BorderRadius.circular(12),
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
                  url!,
                  width: double.infinity,
                  height: defTamanoImagen(constraints),
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8, 12, 0, 0),
                child: Text(
                  nombre!,
                  style: FlutterFlowTheme.of(context).subtitle1.override(
                        fontFamily: 'Outfit',
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                            FlutterFlowTheme.of(context).subtitle1Family),
                      ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8, 4, 0, 0),
                child: Text(
                  'Category Name',
                  style: FlutterFlowTheme.of(context).bodyText2.override(
                        fontFamily: 'Outfit',
                        color: FlutterFlowTheme.of(context).grayicon,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                            FlutterFlowTheme.of(context).bodyText2Family),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

int defCantidadColumnas(screenSize) {
  if (screenSize > 440 && screenSize < 1057) {
    return 2;
  } else if (screenSize >= 1057 && screenSize < 1240) {
    return 3;
  } else if (screenSize >= 1240 && screenSize < 1500) {
    return 4;
  } else if (screenSize >= 1500 && screenSize < 1840) {
    return 5;
  } else if (screenSize >= 1840) {
    return 7;
  } else {
    return 1;
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

Widget _loader(BuildContext context, String url) {
  return const Center(
    child: CircularProgressIndicator(),
  );
}

bool esEscritorio(BuildContext context) {
  return responsiveVisibility(context: context, desktop: true);
}
