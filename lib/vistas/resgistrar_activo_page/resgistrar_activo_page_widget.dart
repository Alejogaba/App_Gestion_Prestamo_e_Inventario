import 'dart:developer';
import 'dart:io';
import 'package:app_gestion_prestamo_inventario/entidades/estadoActivo.dart';
import 'package:app_gestion_prestamo_inventario/servicios/activoController.dart';
import 'package:app_gestion_prestamo_inventario/servicios/categoriaController.dart';
import 'package:app_gestion_prestamo_inventario/servicios/storageController.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:image_picker/image_picker.dart';

import '../../entidades/categoria.dart';
import '../flutter_flow/flutter_flow_count_controller.dart';
import '../flutter_flow/flutter_flow_drop_down.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';


class ResgistrarActivoPageWidget extends StatefulWidget {
  final String? idSerial;
  const ResgistrarActivoPageWidget({Key? key, this.idSerial}) : super(key: key);

  @override
  _ResgistrarActivoPageWidgetState createState() =>
      _ResgistrarActivoPageWidgetState(this.idSerial);
}

class _ResgistrarActivoPageWidgetState extends State<ResgistrarActivoPageWidget>
    with SingleTickerProviderStateMixin {
  EstadoActivo? dropDownValueEstadoActivo;
  TextEditingController textControllerSerial = TextEditingController();
  TextEditingController? textControllerN_inventario;
  TextEditingController? textControllerNombre;
  TextEditingController? textFieldDescripcionController;
  TextEditingController? controladorimagenUrl;
  String? dropDownValueCategoria;
  int? countControllerValue;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<Categoria> listCategorias = [];
  List<EstadoActivo> listEstados = [
    EstadoActivo(0, 'Bueno: Activo en buen estado'),
    EstadoActivo(1,
        'Regular: Activo con desperfectos o daños menores pero en perfecto estado funcional'),
    EstadoActivo(2, 'Malo: Activo en mal estado o dañado'),
  ];
  File? imageFile;

  String? urlImagen;
  final ImagePicker picker = ImagePicker();
  late String result;
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool _errorColor = false;
  bool _dropdownErrorColor = false;
  CategoriaController categoriaController = CategoriaController();
  late final _listaCategorias = cargarCategorias();
  String? idSerial = '';
  int? numInventario;
  int estadoActivoOpcion = 0;

  _ResgistrarActivoPageWidgetState(this.idSerial);

  // ignore: prefer_final_fields

  @override
  void initState() {
    super.initState();
    idSerial != null
        ? textControllerSerial.text = idSerial!
        : textControllerSerial.text = '';
    textControllerN_inventario = TextEditingController();
    textControllerNombre = TextEditingController();
    textFieldDescripcionController = TextEditingController();
  }

  @override
  void dispose() {
    textControllerSerial.dispose();
    textControllerN_inventario?.dispose();
    textControllerNombre?.dispose();
    textFieldDescripcionController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
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
            _errorColor ? Icons.error : FontAwesomeIcons.solidSave,
            color: FlutterFlowTheme.of(context).whiteColor,
            size: 30,
          ),
          onPressed: () async {
            if (_formKey.currentState!.validate() &&
                dropDownValueCategoria != null) {
              _loading = true;
              String? imagenUrl;
              log('serial: ${textControllerSerial.text.toString()}');

              if (imageFile != null) {
                StorageController storageController = StorageController();
                imagenUrl = await storageController.subirImagen(
                    context,
                    imageFile!.path.toString(),
                    imageFile!,
                    textControllerSerial.text);
                ActivoController activoController = ActivoController();
                // ignore: use_build_context_synchronously
                await registrarActivo(activoController, context, imagenUrl);
                Timer(Duration(seconds: 3), () {
                  context.pop();
                });
              } else {
                ActivoController activoController = ActivoController();
                await registrarActivo(activoController, context, 'https://www.giulianisgrupo.com/wp-content/uploads/2018/05/nodisponible.png');
                Timer(Duration(seconds: 3), () {
                  context.pop();
                });
              }
            } else if (dropDownValueCategoria == null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  "Seleccione una categoria",
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
              });
              Future.delayed(const Duration(milliseconds: 6000), () {
                setState(() {
                  _errorColor = false;
                });
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  "No deje campos vacios",
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
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        iconTheme: IconThemeData(color: Colors.black),
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
          'Resgistrar activo',
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
      body: Padding(
        padding:  const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
        child: Container(
          alignment: Alignment.center,
            margin: EdgeInsets.all(20),
            height: 200,
            width:double.infinity,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
               borderRadius: BorderRadius.circular(30), //border corner radius
               boxShadow:[ 
                 BoxShadow(
                    color: FlutterFlowTheme.of(context).boxShadow, //color of shadow
                    spreadRadius: 5, //spread radius
                    blurRadius: 7, // blur radius
                    offset: Offset(0, 2), // changes position of shadow
                    //first paramerter of offset is left-right
                    //second parameter is top to down
                 ),
                 //you can set more BoxShadow() here
                ],
            ),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 5, 10, 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'No deje este campo vacio';
                                  }
                                },
                                controller: textControllerSerial,
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'Número serial*',
                                  labelStyle:
                                      FlutterFlowTheme.of(context).title3.override(
                                            fontFamily: FlutterFlowTheme.of(context)
                                                .title3Family,
                                            fontSize: 20,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(
                                                    FlutterFlowTheme.of(context)
                                                        .title3Family),
                                          ),
                                  hintText: 'S/N',
                                  hintStyle:
                                      FlutterFlowTheme.of(context).title3.override(
                                            fontFamily: FlutterFlowTheme.of(context)
                                                .title3Family,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            fontSize: 22,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(
                                                    FlutterFlowTheme.of(context)
                                                        .title3Family),
                                          ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4.0),
                                      topRight: Radius.circular(4.0),
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4.0),
                                      topRight: Radius.circular(4.0),
                                    ),
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4.0),
                                      topRight: Radius.circular(4.0),
                                    ),
                                  ),
                                  focusedErrorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4.0),
                                      topRight: Radius.circular(4.0),
                                    ),
                                  ),
                                ),
                                style: FlutterFlowTheme.of(context).title3.override(
                                      fontFamily:
                                          FlutterFlowTheme.of(context).title3Family,
                                      fontSize: 22,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(FlutterFlowTheme.of(context)
                                              .title3Family),
                                    ),
                              ),
                            ),
                          ),
                          FlutterFlowIconButton(
                            borderColor: Colors.transparent,
                            borderRadius: 30,
                            borderWidth: 1,
                            buttonSize: 60,
                            icon: FaIcon(
                              FontAwesomeIcons.barcode,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 30,
                            ),
                            onPressed: () async {
                              String res = await FlutterBarcodeScanner.scanBarcode(
                                  '#C62828', // scanning line color
                                  'Cancel', // cancel button text
                                  true, // whether to show the flash icon
                                  ScanMode.BARCODE);
                              textControllerSerial.text =
                                  res.trim().replaceAll(".", "");
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 5, 10, 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                              child: TextFormFieldCustom(textControllerN_inventario: textControllerN_inventario,
                              label:'Número de inventario',hint:'Ej.0134',maxCharacters:4),
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
                      padding: EdgeInsetsDirectional.fromSTEB(0, 5, 10, 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'No deje este campo vacio';
                                  }
                                  return null;
                                },
                                controller: textControllerNombre,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(20),
                                ],
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'Nombre*',
                                  labelStyle:
                                      FlutterFlowTheme.of(context).title3.override(
                                            fontFamily: FlutterFlowTheme.of(context)
                                                .title3Family,
                                            fontSize: 20,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(
                                                    FlutterFlowTheme.of(context)
                                                        .title3Family),
                                          ),
                                  hintText: 'Ej. Impresora MP125',
                                  hintStyle:
                                      FlutterFlowTheme.of(context).title3.override(
                                            fontFamily: FlutterFlowTheme.of(context)
                                                .title3Family,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            fontSize: 22,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(
                                                    FlutterFlowTheme.of(context)
                                                        .title3Family),
                                          ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4.0),
                                      topRight: Radius.circular(4.0),
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4.0),
                                      topRight: Radius.circular(4.0),
                                    ),
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4.0),
                                      topRight: Radius.circular(4.0),
                                    ),
                                  ),
                                  focusedErrorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4.0),
                                      topRight: Radius.circular(4.0),
                                    ),
                                  ),
                                ),
                                style: FlutterFlowTheme.of(context).title3.override(
                                      fontFamily:
                                          FlutterFlowTheme.of(context).title3Family,
                                      fontSize: 22,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(FlutterFlowTheme.of(context)
                                              .title3Family),
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
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10, 10, 0, 0),
                          child: Text(
                            'Seleccione o suba una imagen',
                            style: FlutterFlowTheme.of(context).bodyText1,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(16, 0, 16, 14),
                              child: GridView(
                                padding: EdgeInsets.zero,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 1,
                                ),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child:
                                        imagenPerfil(context, urlImagen, imageFile),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 2,
                      thickness: 1,
                      color: Color(0x94ABB3BA),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: AlignmentDirectional(0.05, 0),
                              child: Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                                child: TextFormField(
                                  controller: textFieldDescripcionController,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelText: 'Detalles del activo',
                                    labelStyle: FlutterFlowTheme.of(context)
                                        .subtitle2
                                        .override(
                                          fontFamily: FlutterFlowTheme.of(context)
                                              .subtitle2Family,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          fontSize: 20,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .subtitle2Family),
                                        ),
                                    hintText:
                                        'Ej. Impresora Laserjet MP125 marca HP',
                                    hintStyle: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                          fontFamily: FlutterFlowTheme.of(context)
                                              .bodyText1Family,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          fontSize: 18,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyText1Family),
                                        ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0),
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0),
                                      ),
                                    ),
                                    errorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0),
                                      ),
                                    ),
                                    focusedErrorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0),
                                      ),
                                    ),
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyText1
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyText1Family,
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        fontSize: 22,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyText1Family),
                                      ),
                                  maxLines: 2,
                                  minLines: 1,
                                  keyboardType: TextInputType.multiline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 2,
                      thickness: 1,
                      color: Color(0x94ABB3BA),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(0, 0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 10),
                              child: FlutterFlowDropDown<EstadoActivo>(
                                initialOption: listEstados[0],
                                value: dropDownValueEstadoActivo,
                                options: List.generate(
                                    listEstados.length,
                                    (index) => DropdownMenuItem(
                                        value: listEstados[index],
                                        child: Text(listEstados[index]
                                            .descripcion
                                            .toString()))),
                                onChanged: (val) => setState(() {
                                  dropDownValueEstadoActivo = val;
                                  estadoActivoOpcion = val!.id!;
                                }),
                                width: MediaQuery.of(context).size.width - 30,
                                height: 50,
                                textStyle: FlutterFlowTheme.of(context)
                                    .bodyText1
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyText1Family,
                                      fontSize: 18,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(FlutterFlowTheme.of(context)
                                              .bodyText1Family),
                                    ),
                                hintText: listEstados[0].descripcion,
                                fillColor:
                                    FlutterFlowTheme.of(context).primaryBackground,
                                elevation: 2,
                                borderColor:
                                    FlutterFlowTheme.of(context).secondaryText,
                                borderWidth: 2,
                                borderRadius: 8,
                                margin:
                                    EdgeInsetsDirectional.fromSTEB(12, 4, 12, 4),
                                hidesUnderline: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 2,
                      thickness: 1,
                      color: Color(0x94ABB3BA),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20,  MediaQuery.of(context).size.width-40,  MediaQuery.of(context).size.width-40, 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(0, 0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 10),
                              child: FutureBuilder<List<Categoria>>(
                                future: _listaCategorias,
                                builder: (BuildContext context, snapshot) {
                                  return FlutterFlowDropDown<String>(
                                    value: dropDownValueCategoria,
                                    options: (snapshot.connectionState ==
                                                ConnectionState.done &&
                                            listCategorias.isNotEmpty)
                                        ? List.generate(
                                            snapshot.data!.length,
                                            (index) => DropdownMenuItem(
                                                value: snapshot.data![index].nombre,
                                                child: Text(snapshot
                                                    .data![index].nombre
                                                    .toString())))
                                        : List.generate(
                                            0,
                                            (index) => DropdownMenuItem(
                                                value: null, child: Text(''))),
                                    onChanged: (val) => setState(
                                        () => dropDownValueCategoria = val),
                                    width: MediaQuery.of(context).size.width - 30,
                                    height: 50,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                          fontFamily: FlutterFlowTheme.of(context)
                                              .bodyText1Family,
                                          fontSize: 18,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyText1Family),
                                        ),
                                    hintText: 'Categoria*',
                                    fillColor: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    elevation: 2,
                                    borderColor: _dropdownErrorColor
                                        ? Colors.redAccent
                                        : FlutterFlowTheme.of(context)
                                            .secondaryText,
                                    borderWidth: 2,
                                    borderRadius: 8,
                                    margin: EdgeInsetsDirectional.fromSTEB(
                                        12, 4, 12, 4),
                                    hidesUnderline: true,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 2,
                      thickness: 1,
                      color: Color(0x94ABB3BA),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'Cantidad: ',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyText1
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyText1Family,
                                        fontSize: 18,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyText1Family),
                                      ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                                  child: Container(
                                    width: 160,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      borderRadius: BorderRadius.circular(40),
                                      shape: BoxShape.rectangle,
                                      border: Border.all(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        width: 1,
                                      ),
                                    ),
                                    child: FlutterFlowCountController(
                                      decrementIconBuilder: (enabled) => FaIcon(
                                        FontAwesomeIcons.minus,
                                        color: enabled
                                            ? Color(0xA9D43538)
                                            : FlutterFlowTheme.of(context)
                                                .boxShadow,
                                        size: 20,
                                      ),
                                      incrementIconBuilder: (enabled) => FaIcon(
                                        FontAwesomeIcons.plus,
                                        color: enabled
                                            ? FlutterFlowTheme.of(context)
                                                .primaryColor
                                            : FlutterFlowTheme.of(context)
                                                .boxShadow,
                                        size: 20,
                                      ),
                                      countBuilder: (count) => Text(
                                        count.toString(),
                                        style: FlutterFlowTheme.of(context)
                                            .title2
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .title2Family,
                                              color: FlutterFlowTheme.of(context)
                                                  .grayicon,
                                              useGoogleFonts: GoogleFonts.asMap()
                                                  .containsKey(
                                                      FlutterFlowTheme.of(context)
                                                          .title2Family),
                                            ),
                                      ),
                                      count: countControllerValue ??= 1,
                                      updateCount: (count) => setState(
                                          () => countControllerValue = count),
                                      stepSize: 1,
                                      minimum: 1,
                                      maximum: 99,
                                    ),
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
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> registrarActivo(ActivoController activoController,
      BuildContext context, String? imagenUrl) async {
    await activoController.addActivo(
        context,
        textControllerSerial.text,
        textControllerN_inventario!.text,
        textControllerNombre!.text,
        textFieldDescripcionController!.text,
        imagenUrl,
        estadoActivoOpcion,
        dropDownValueCategoria!,
        countControllerValue,
        null,
        null);
    _loading = false;
  }

  Future<List<Categoria>> cargarCategorias() async {
    CategoriaController categoriaController = CategoriaController();
    listCategorias = await categoriaController.getCategorias(null);
    for (var element in listCategorias) {
      print('Lista categoria nombre: + ${element.nombre}');
      print('Lista categoria url: ${element.urlImagen}');
    }
    return Future.value(listCategorias);
  }

  Future pickImageFromGallery() async {
    print("starting get image");
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    //final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    print("getting image.....");
    setState(() {
      if (pickedFile != null) {
        print("file not null");
        imageFile = File(pickedFile.path);
       
      } else {
        print('No image selected.');
      }
    });
  }

  Future captureImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
       
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Seleccione"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Galeria"),
                    onTap: () {
                      pickImageFromGallery();
                      Navigator.pop(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: Text("Camara"),
                    onTap: () {
                      captureImageFromCamera();
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<void> pickFile() async {
    FilePickerResult? pickedFile =
        await FilePicker.platform.pickFiles(type: FileType.image);
    setState(() {
      if (pickedFile != null) {
        File imagefile = File(pickedFile.files.single.path!);
        log('ruta archivo: ${imagefile.path}');
      } else {
        // User canceled the picker
      }
    });
  }

  Future pickImageDesktop() async {
    print("starting get image");
    final FilePickerResult? pickedFile =
        await FilePicker.platform.pickFiles(type: FileType.image);
    //final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    print("getting image Desktop.....");
    setState(() {
      if (pickedFile != null) {
        print("file not null");
        imageFile = File(pickedFile.files.single.path!);
        //inputImage = InputImage.fromFilePath(pickedFile.files.single.path!);
        //imageToText(inputImage);
      } else {
        print('No image selected.');
      }
    });
  }

  Widget imagenPerfil(BuildContext context, urlImagen, imageFile) {
    return GestureDetector(
      onTap: () async {
        if (Platform.isAndroid || Platform.isIOS) {
          await _showChoiceDialog(context);
          setState(() {
            controladorimagenUrl = null;
          });
        } else {
          print('Escoger imagen');
          await pickImageDesktop();
          setState(() {
            controladorimagenUrl = null;
          });
        }
      },
      child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: urlImagen != null && imageFile == null
                  ? DecorationImage(
                      fit: BoxFit.cover, image: NetworkImage(urlImagen))
                  : null),
          child: urlImagen == null || imageFile != null
              ? _decideImageView(imageFile)
              : null),
    );
  }

  Widget _decideImageView(imageFile) {
    if (imageFile == null) {
      return Center(child: Text("No se ha seleccionado una imagen"));
    } else {
      return Image.file(
        imageFile,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    }
  }
}

class TextFormFieldCustom extends StatelessWidget {

  const TextFormFieldCustom({
    Key? key,
    required TextEditingController controlador, required String hint, required String label, required int maxCharacters,
  }) : super(key: key);

  final TextEditingController? textControllerN_inventario;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
     cursorColor: FlutterFlowTheme.of(context).primaryText,
     
      controller:controlador,
       inputFormatters: [
                                  LengthLimitingTextInputFormatter(maxCharacters),
                                ],
      obscureText: false,
      decoration: InputDecoration(
        fillColor: FlutterFlowTheme.of(context).primaryBackground,
        labelText: 'Número de inventario',
        labelStyle:
            FlutterFlowTheme.of(context).title3.override(
                  fontFamily: FlutterFlowTheme.of(context)
                      .title3Family,
                  fontSize: 20,
                  useGoogleFonts: GoogleFonts.asMap()
                      .containsKey(
                          FlutterFlowTheme.of(context)
                              .title3Family),
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
        hintText: '01234',
        hintStyle:
            FlutterFlowTheme.of(context).title3.override(
                  fontFamily: FlutterFlowTheme.of(context)
                      .title3Family,
                  color: FlutterFlowTheme.of(context)
                      .secondaryText,
                  fontSize: 22,
                  useGoogleFonts: GoogleFonts.asMap()
                      .containsKey(
                          FlutterFlowTheme.of(context)
                              .title3Family),
                ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).primaryText,
            width: 1,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4.0),
            topRight: Radius.circular(4.0),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).primaryText,
            width: 1,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4.0),
            topRight: Radius.circular(4.0),
          ),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).primaryText,
            width: 1,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4.0),
            topRight: Radius.circular(4.0),
          ),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: FlutterFlowTheme.of(context).primaryText,
            width: 1,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4.0),
            topRight: Radius.circular(4.0),
          ),
        ),
        suffixIcon: FaIcon(
          FontAwesomeIcons.boxOpen,
          color: Color(0xFFAD8762),
          size: 30,
        ),
      ),
    
      style: FlutterFlowTheme.of(context).title3.override(
            fontFamily:
                FlutterFlowTheme.of(context).title3Family,
            fontSize: 22,
            useGoogleFonts: GoogleFonts.asMap()
                .containsKey(FlutterFlowTheme.of(context)
                    .title3Family),
          ),
    );
  }
}
