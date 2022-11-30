import 'dart:developer';
import 'dart:io' show Platform;
import 'dart:io';
import 'package:app_gestion_prestamo_inventario/servicios/categoriaController.dart';
import 'package:app_gestion_prestamo_inventario/servicios/storageController.dart';
import 'package:file_picker/file_picker.dart';
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
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_ml_kit/google_ml_kit.dart';

class ResgistrarActivoPageWidget extends StatefulWidget {
  const ResgistrarActivoPageWidget({Key? key}) : super(key: key);

  @override
  _ResgistrarActivoPageWidgetState createState() =>
      _ResgistrarActivoPageWidgetState();
}

class _ResgistrarActivoPageWidgetState
    extends State<ResgistrarActivoPageWidget> {
  String? dropDownValueEstadoActivo;
  TextEditingController? textControllerSerial;
  TextEditingController? textControllerN_inventario;
  TextEditingController? textControllerNombre;
  TextEditingController? textFieldDescripcionController;
  TextEditingController? controladorimagenUrl;
  String? dropDownValueCategoria;
  int? countControllerValue;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<Categoria> listCategorias = [];
  List<String> listEstados = [
    'Bueno: Activo en buen estado',
    'Regular: Activo con desperfectos o daños menores pero en perfecto estado funcional',
    'Malo: Activo en mal estado o dañado'
  ];
  File? imageFile;
  InputImage? inputImage;
  String? urlImagen;
  final ImagePicker picker = ImagePicker();
  late String result;
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    textControllerSerial = TextEditingController();
    textControllerN_inventario = TextEditingController();
    textControllerNombre = TextEditingController();
    textFieldDescripcionController = TextEditingController();

    cargarCategorias();
  }

  @override
  void dispose() {
    textControllerSerial?.dispose();
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
        backgroundColor: FlutterFlowTheme.of(context).primaryColor,
        elevation: 8,
        child: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30,
          borderWidth: 1,
          buttonSize: 60,
          icon: FaIcon(
            FontAwesomeIcons.solidSave,
            color: FlutterFlowTheme.of(context).tertiaryColor,
            size: 30,
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _loading = true;
              try {
                if (imageFile != null) {
                  StorageController storageController = StorageController();
                  storageController.subirImagen(context, imageFile,imageFile!.path.toString(),textControllerSerial!.text);
                }
              } catch (e) {
                log(e.toString());
              }
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
                            return null;
                          },
                          controller: textControllerSerial,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Número serial*',
                            labelStyle: FlutterFlowTheme.of(context)
                                .title3
                                .override(
                                  fontFamily:
                                      FlutterFlowTheme.of(context).title3Family,
                                  fontSize: 20,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .title3Family),
                                ),
                            hintText: 'S/N',
                            hintStyle: FlutterFlowTheme.of(context)
                                .title3
                                .override(
                                  fontFamily:
                                      FlutterFlowTheme.of(context).title3Family,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  fontSize: 22,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
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
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context).title3Family),
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
                      onPressed: () {
                        print('IconButton pressed ...');
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
                        child: TextFormField(
                          controller: textControllerN_inventario,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Número de inventario',
                            labelStyle: FlutterFlowTheme.of(context)
                                .title3
                                .override(
                                  fontFamily:
                                      FlutterFlowTheme.of(context).title3Family,
                                  fontSize: 20,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .title3Family),
                                ),
                            hintText: '01234',
                            hintStyle: FlutterFlowTheme.of(context)
                                .title3
                                .override(
                                  fontFamily:
                                      FlutterFlowTheme.of(context).title3Family,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  fontSize: 22,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
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
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context).title3Family),
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
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Nombre*',
                            labelStyle: FlutterFlowTheme.of(context)
                                .title3
                                .override(
                                  fontFamily:
                                      FlutterFlowTheme.of(context).title3Family,
                                  fontSize: 20,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .title3Family),
                                ),
                            hintText: 'Ej. Impresora MP125',
                            hintStyle: FlutterFlowTheme.of(context)
                                .title3
                                .override(
                                  fontFamily:
                                      FlutterFlowTheme.of(context).title3Family,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  fontSize: 22,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
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
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context).title3Family),
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
                        padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 14),
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
                          padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
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
                              hintText: 'Ej. Impresora Laserjet MP125 marca HP',
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
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 22,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
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
                        child: FlutterFlowDropDown<String>(
                          value: dropDownValueEstadoActivo,
                          options: List.generate(
                              listEstados.length,
                              (index) => DropdownMenuItem(
                                  value: listEstados[index],
                                  child: Text(listEstados[index]))),
                          onChanged: (val) =>
                              setState(() => dropDownValueEstadoActivo = val),
                          width: MediaQuery.of(context).size.width - 30,
                          height: 50,
                          textStyle: FlutterFlowTheme.of(context)
                              .bodyText1
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyText1Family,
                                fontSize: 18,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyText1Family),
                              ),
                          hintText: 'Estado del activo*',
                          fillColor:
                              FlutterFlowTheme.of(context).primaryBackground,
                          elevation: 2,
                          borderColor:
                              FlutterFlowTheme.of(context).secondaryText,
                          borderWidth: 2,
                          borderRadius: 8,
                          margin: EdgeInsetsDirectional.fromSTEB(12, 4, 12, 4),
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
                        child: FutureBuilder(
                          future: cargarCategorias(),
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
                                          value: listEstados[index],
                                          child: Text(listEstados[index]))),
                              onChanged: (val) =>
                                  setState(() => dropDownValueCategoria = val),
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
                              borderColor:
                                  FlutterFlowTheme.of(context).secondaryText,
                              borderWidth: 2,
                              borderRadius: 8,
                              margin:
                                  EdgeInsetsDirectional.fromSTEB(12, 4, 12, 4),
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
                                      .containsKey(FlutterFlowTheme.of(context)
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
                                      : FlutterFlowTheme.of(context).boxShadow,
                                  size: 20,
                                ),
                                incrementIconBuilder: (enabled) => FaIcon(
                                  FontAwesomeIcons.plus,
                                  color: enabled
                                      ? FlutterFlowTheme.of(context)
                                          .primaryColor
                                      : FlutterFlowTheme.of(context).boxShadow,
                                  size: 20,
                                ),
                                countBuilder: (count) => Text(
                                  count.toString(),
                                  style: FlutterFlowTheme.of(context)
                                      .title2
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
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
    );
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
        inputImage = InputImage.fromFilePath(pickedFile.path);
        imageToText(inputImage);
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
        inputImage = InputImage.fromFilePath(pickedFile.path);
        imageToText(inputImage);
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

  Future imageToText(inputImage) async {
    print("starting");
    result = '';

    final textDetector = GoogleMlKit.vision.textRecognizer();
    print("loaded textDetector");
    final RecognizedText recognisedText =
        await textDetector.processImage(inputImage);
    print("loaded recognisedText");

    setState(() {
      String text = recognisedText.text;
      for (TextBlock block in recognisedText.blocks) {
        //each block of text/section of text
        final String text = block.text;
        print("block of text: ");
        print(text);
        for (TextLine line in block.lines) {
          //each line within a text block
          for (TextElement element in line.elements) {
            //each word within a line
            result += element.text + " ";
          }
        }
      }
      result += "\n\n";
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
