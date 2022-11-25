import 'dart:developer';

import 'package:app_gestion_prestamo_inventario/entidades/categoria.dart';
import 'package:app_gestion_prestamo_inventario/servicios/categoriaController.dart';
import 'package:flutter/rendering.dart';

import '../components/nav_bar1_widget.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sidebarx/sidebarx.dart';

class PrincipalWidget extends StatefulWidget {
  const PrincipalWidget({Key? key}) : super(key: key);

  @override
  _PrincipalWidgetState createState() => _PrincipalWidgetState();
}

class _PrincipalWidgetState extends State<PrincipalWidget> {
  TextEditingController? textController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  CategoriaController categoriaController = CategoriaController();
  List<Categoria> listCategorias = [];

  @override
  initState() {
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
      appBar: AppBar(title: Text('title')),
      key: scaffoldKey,
      backgroundColor: Color(0xFFF1F4F8),
      drawer: Drawer(
        elevation: 16,
        child: ListView(
    // Important: Remove any padding from the ListView.
    padding: EdgeInsets.zero,
    children: [
      const DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: Text('Drawer Header'),
      ),
      ListTile(
        title: const Text('Item 1'),
        onTap: () {
          // Update the state of the app.
          // ...
        },
      ),
      ListTile(
        title: const Text('Item 2'),
        onTap: () {
          // Update the state of the app.
          // ...
        },
      ),
    ],
  ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            pinned: true,
            floating: false,
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            iconTheme:
                IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
            automaticallyImplyLeading: false,
            title: AutoSizeText(
              
              'Bienvenido',
              
              style: FlutterFlowTheme.of(context).bodyText1.override(
                    fontFamily: FlutterFlowTheme.of(context).bodyText1Family,
                    color: FlutterFlowTheme.of(context).primaryText,
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
                  color: FlutterFlowTheme.of(context).primaryText,
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
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16, 12, 16, 0),
                                child: TextFormField(
                                  controller: textController,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    'textController',
                                    Duration(milliseconds: 2000),
                                    () => setState(() {}),
                                  ),
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelText: 'Search products...',
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
                                  future: cargarCategorias(),
                                  builder: ((context, snapshot) {
                                    int i = 0;
                                    List<Widget> temp = [];

                                    log('Cantidad items: ${listCategorias.length}');

                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return Padding(
                                        padding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                16, 16, 16, 0),
                                        child: LayoutBuilder(
                                          builder: (context, constraints) {
                                            log(constraints.maxWidth.toString());
                                            return GridView.builder(
                                              shrinkWrap: true,
                                              itemCount:
                                                  snapshot.data!.length,
                                              itemBuilder: (context, index) {
                                                var temp = itemCategoria(
                                                    context,
                                                    snapshot
                                                        .data![index].nombre,
                                                    snapshot.data![index]
                                                        .urlImagen,
                                                    constraints.maxWidth);
                                                return temp;
                                              },
                                              scrollDirection: Axis.vertical,
                                              padding: EdgeInsets.zero,
                                              gridDelegate:
                                                  // ignore: prefer_const_constructors
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: defCantidadColumnas(constraints.maxWidth),
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
                                      return Container();
                                    }
                                    print(snapshot.connectionState);
                                  })),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (responsiveVisibility(
                    context: context,
                    desktop: false,
                  ))
                    Align(
                      alignment: AlignmentDirectional(0, 1),
                      child: NavBar1Widget(),
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
    listCategorias = await categoriaController.getCategorias();
    for (var element in listCategorias) {
      print('Lista categoria nombre: + ${element.nombre}');
      print('Lista categoria url: ${element.urlImagen}');
    }
    return Future.value(listCategorias);
  }
}

Widget itemCategoria(
    BuildContext context, String? nombre, String? url, constraints) {
  log("Dibijando item categoria");
  return Padding(
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
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Color(0x230E151B),
            offset: Offset(0, 2),
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
                      color: Color(0xFF14181B),
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
                      color: Color(0xFF57636C),
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
  );
}

int defCantidadColumnas(screenSize) {
  if (screenSize > 440 && screenSize<1057) {
    return 2;
  } else if (screenSize >= 1057 && screenSize<1240) {
    return 3;
  } else if (screenSize >= 1240 && screenSize<1500) {
    return 4;
  }else if(screenSize >= 1500 && screenSize<1840) {
    return 5;
  }else if (screenSize >= 1840) {
    return 7;
  }else{
    return 1;
  }
}

double? defTamanoImagen(screenSize) {
  if (screenSize > 440 && screenSize<640) {
    return 82;
  }else if (screenSize >= 640 && screenSize<1057) {
    return 180;
  }else if (screenSize >= 1057 && screenSize<1240) {
    return 170;
  }else if (screenSize >= 1240 && screenSize<1370) {
    return 140;
  }else if (screenSize >= 1370 && screenSize<1840) {
    return 135;
  }else if (screenSize >= 1840) {
    return 110;
  }else{
    return 180;
  }
}
