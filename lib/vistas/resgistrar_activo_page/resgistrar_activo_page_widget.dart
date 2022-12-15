import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:app_gestion_prestamo_inventario/entidades/activo_impresora.dart';
import 'package:app_gestion_prestamo_inventario/entidades/estadoActivo.dart';
import 'package:app_gestion_prestamo_inventario/servicios/activoController.dart';
import 'package:app_gestion_prestamo_inventario/servicios/categoriaController.dart';
import 'package:app_gestion_prestamo_inventario/servicios/storageController.dart';
import 'package:app_gestion_prestamo_inventario/vistas/registrar_funcionario_page/registrar_funcionario_page_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../entidades/activo.dart';
import '../../entidades/categoria.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
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
import 'package:dotted_border/dotted_border.dart';

class ResgistrarActivoPageWidget extends StatefulWidget {
  final String? operacionaRealizar;
  final String? idSerial;
  final String? categoria;
  final Activo? activoEditar;
  const ResgistrarActivoPageWidget(
      {Key? key,
      this.operacionaRealizar,
      this.idSerial,
      this.categoria,
      this.activoEditar})
      : super(key: key);

  @override
  _ResgistrarActivoPageWidgetState createState() =>
      _ResgistrarActivoPageWidgetState(this.operacionaRealizar, this.idSerial,
          this.categoria, this.activoEditar);
}

class _ResgistrarActivoPageWidgetState extends State<ResgistrarActivoPageWidget>
    with SingleTickerProviderStateMixin {
  EstadoActivo? dropDownValueEstadoActivo;
  TextEditingController textControllerSerial = TextEditingController();
  TextEditingController textControllerN_inventario = TextEditingController();
  TextEditingController textControllerNombre = TextEditingController();
  TextEditingController? textControllerDetalles = TextEditingController();
  TextEditingController? controladorimagenUrl = TextEditingController();
  String? dropDownValueCategoria;
  int? countControllerValue = 1;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<Categoria> listCategorias = [];
  List<EstadoActivo> listEstados = [
    EstadoActivo(0, 'Bueno: Activo en buen estado'),
    EstadoActivo(1,
        'Regular: Activo con desperfectos o daños menores pero en perfecto estado funcional'),
    EstadoActivo(2, 'Malo: Activo en mal estado o dañado'),
  ];
  File? imageFile;
  int anchominimo = 640;
  bool blur = false;

  String? urlImagen;
  final ImagePicker picker = ImagePicker();
  late String result;
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool _errorColor = false;
  bool _dropdownErrorColor = false;
  CategoriaController categoriaController = CategoriaController();
  late final _listaCategorias = cargarCategorias();
  int? numInventario;
  int estadoActivoOpcion = 0;
  Activo? activo;
  final String? operacionaRealizar;
  final String? idSerial;
  final String? categoria;
  final Activo? activoEditar;
  FocusNode _focusNodeIdSerial = FocusNode();
  FocusNode _focusNodeNinventario = FocusNode();
  FocusNode _focusNodeNombre = FocusNode();
  FocusNode _focusNodeDetalles = FocusNode();
  Color color = Colors.red;
  List<TextInputFormatter> inputNumero = <TextInputFormatter>[
    // for below version 2 use this
    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
// for version 2 and greater youcan also use this
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(4),
  ];

  List<TextInputFormatter> inputFormater = <TextInputFormatter>[
    LengthLimitingTextInputFormatter(10),
  ];

  _ResgistrarActivoPageWidgetState(this.operacionaRealizar, this.idSerial,
      this.categoria, this.activoEditar);

  // ignore: prefer_final_fields5

  @override
  void initState() {
    super.initState();
    if (activoEditar != null) {
      textControllerSerial.text = activoEditar!.idSerial.toString();
      textControllerN_inventario.text = activoEditar!.numActivo.toString();
      textControllerNombre.text = activoEditar!.nombre.toString();
      textControllerDetalles!.text = activoEditar!.detalles.toString();
      dropDownValueCategoria = activoEditar!.categoria.toString();
      dropDownValueEstadoActivo!.id = activoEditar!.estado;
    } else {
      idSerial != null
          ? textControllerSerial.text = idSerial.toString()
          : textControllerSerial.text = '';

      textControllerN_inventario.text = '';
      textControllerNombre.text = '';
    }
  }

  @override
  void dispose() {
    textControllerSerial.dispose();
    textControllerN_inventario.dispose();
    textControllerNombre.dispose();
    textControllerDetalles?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dynamic tamanio_padding = (MediaQuery.of(context).size.width < anchominimo)
        ? EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10)
        : EdgeInsetsDirectional.fromSTEB(80, 10, 80, 10);

    dynamic anchoColumnaWrap = (MediaQuery.of(context).size.width < anchominimo)
        ? MediaQuery.of(context).size.width * 0.9
        : MediaQuery.of(context).size.width * 0.4;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
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
              setState(() {
                blur = true;
              });
              String? imagenUrl;
              log('serial: ${textControllerSerial.text.toString()}');

              if (imageFile != null) {
                StorageController storageController = StorageController();
                imagenUrl = await storageController.subirImagen(
                    context,
                    imageFile!.path.toString(),
                    imageFile!,
                    textControllerSerial.text,
                    'activos');
                ActivoController activoController = ActivoController();
                String res = '';
                // ignore: use_build_context_synchronously
                if (imagenUrl != 'error') {
                  res = await registrarActivo(
                      activoController, context, imagenUrl);

                  if (res == 'ok') {
                    setState(() {
                      blur = false;
                    });
                    Timer(Duration(seconds: 3), () {
                      context.pop();
                    });
                  }
                } else {
                  setState(() {
                    blur = false;
                  });
                }
              } else {
                ActivoController activoController = ActivoController();
                String res = '';
                if (imagenUrl != 'error') {
                  res = await registrarActivo(activoController, context,
                      'https://www.giulianisgrupo.com/wp-content/uploads/2018/05/nodisponible.png');

                  if (res == 'ok') {
                    setState(() {
                      blur = false;
                    });
                    Timer(Duration(seconds: 3), () {
                      context.pop();
                    });
                  }
                } else {
                  setState(() {
                    blur = false;
                  });
                }
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
                blur = false;
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
                blur = false;
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
        backgroundColor: FlutterFlowTheme.of(context).primaryColor,
        iconTheme:
            IconThemeData(color: FlutterFlowTheme.of(context).whiteColor),
        automaticallyImplyLeading: false,
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
        title: Text(
          'Resgistrar activo',
          textAlign: TextAlign.start,
          style: FlutterFlowTheme.of(context).subtitle1.override(
                fontFamily: FlutterFlowTheme.of(context).subtitle1Family,
                color: FlutterFlowTheme.of(context).whiteColor,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).subtitle1Family),
              ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Padding(
            padding: defTamanoAncho(MediaQuery.of(context).size.width),
            child: Container(
              alignment: Alignment.topCenter,
              margin: (MediaQuery.of(context).size.width < anchominimo)
                  ? EdgeInsets.fromLTRB(0, 15, 0, 0)
                  : EdgeInsets.all(10),
              height: (MediaQuery.of(context).size.width < anchominimo)
                  ? null
                  : 1000,
              width: double.infinity,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: (MediaQuery.of(context).size.width < anchominimo)
                    ? null
                    : BorderRadius.circular(30), //border corner radius
                /*boxShadow: [
                  BoxShadow(
                    color: FlutterFlowTheme.of(context).boxShadow, //color of shadow
                    spreadRadius: 5, //spread radius
                    blurRadius: 7, // blur radius
                    offset: Offset(0, 2), // changes position of shadow
                    //first paramerter of offset is left-right
                    //second parameter is top to down
                  ),
                  //you can set more BoxShadow() here
                ],*/
              ),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: (MediaQuery.of(context).size.width < anchominimo)
                      ? EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10)
                      : EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: tamanio_padding,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: TextFormFieldCustom(
                                        context,
                                        textControllerSerial,
                                        'S/N',
                                        'Número de serial*',
                                        20,
                                        TextInputType.text,
                                        null,
                                        true,
                                        null,
                                        _focusNodeIdSerial),
                                  ),
                                  Container(
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color:
                                          (Platform.isAndroid || Platform.isIOS)
                                              ? FlutterFlowTheme.of(context)
                                                  .secondaryBackground
                                              : Colors.transparent,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: (Platform.isAndroid ||
                                                Platform.isIOS)
                                            ? FlutterFlowTheme.of(context)
                                                .secondaryBackground
                                            : Colors.transparent,
                                        width: 0,
                                      ),
                                    ),
                                    child: FlutterFlowIconButton(
                                      fillColor:
                                          (Platform.isAndroid || Platform.isIOS)
                                              ? Color(0x00F1F4F8)
                                              : FlutterFlowTheme.of(context)
                                                  .secondaryBackground,
                                      borderColor: Colors.transparent,
                                      borderRadius: 30,
                                      borderWidth: 1,
                                      buttonSize: 60,
                                      icon: FaIcon(
                                        FontAwesomeIcons.barcode,
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        size: 30,
                                      ),
                                      onPressed: () async {
                                        if (Platform.isAndroid ||
                                            Platform.isIOS) {
                                          String res = await FlutterBarcodeScanner
                                              .scanBarcode(
                                                  '#C62828', // scanning line color
                                                  'Cancel', // cancel button text
                                                  true, // whether to show the flash icon
                                                  ScanMode.BARCODE);
                                          textControllerSerial.text =
                                              res.trim().replaceAll(".", "");
                                        } else {
                                          Clipboard.getData(
                                                  Clipboard.kTextPlain)
                                              .then((value) {
                                            if (value != null) {
                                              if (value.text!
                                                  .trim()
                                                  .isNotEmpty) {
                                                textControllerSerial.text =
                                                    value.text!
                                                        .trim()
                                                        .replaceAll(".", "");
                                              }
                                            }
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 5, 10, 12),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: tamanio_padding,
                                      child: TextFormFieldCustom(
                                          context,
                                          textControllerN_inventario,
                                          'Ej.0134',
                                          'Número de inventario',
                                          4,
                                          TextInputType.number,
                                          inputNumero,
                                          false,
                                          const FaIcon(
                                            FontAwesomeIcons.boxOpen,
                                            color: Color(0xFFAD8762),
                                            size: 30,
                                          ),
                                          _focusNodeNinventario),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 5, 10, 5),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: tamanio_padding,
                                  child: TextFormFieldCustom(
                                      context,
                                      textControllerNombre,
                                      'Ej.Impresora mp203',
                                      'Nombre*',
                                      30,
                                      TextInputType.text,
                                      null,
                                      true,
                                      null,
                                      _focusNodeNombre),
                                ),
                              ),
                              Container(
                                    width: anchoColumnaWrap,
                                    child: Align(
                                      alignment: AlignmentDirectional(0.05, 0),
                                      child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 30, 0, 0),
                                          child: TextFormFieldCustom(
                                              context,
                                              textControllerDetalles,
                                              'Ej.HP',
                                              'Marca',
                                              150,
                                              TextInputType.multiline,
                                              null,
                                              true,
                                              null,
                                              _focusNodeDetalles)),
                                    ),
                                  ),
                            ],
                          ),
                          
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                          child: Wrap(
                            spacing: 0,
                            runSpacing: 2,
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            direction: Axis.horizontal,
                            runAlignment: WrapAlignment.center,
                            verticalDirection: VerticalDirection.down,
                            clipBehavior: Clip.none,
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 10, 20, 0),
                                    child: Text(
                                      'Seleccione una imagen del activo',
                                      style:
                                          FlutterFlowTheme.of(context).title3,
                                    ),
                                  ),
                                  Container(
                                    width: (MediaQuery.of(context).size.width <
                                            anchominimo)
                                        ? MediaQuery.of(context).size.width *
                                            0.9
                                        : MediaQuery.of(context).size.width *
                                            0.2,
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 16, 0, 14),
                                        child: Center(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: imagenPerfil(
                                                context, urlImagen, imageFile),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  FFButtonWidget(
                                    onPressed: () async {
                                      var url = Uri.parse(
                                          'https://www.google.com/search?tbm=isch&q=${textControllerNombre.text.toString()}');
                                      if (!await launchUrl(
                                        url,
                                        mode: LaunchMode.externalApplication,
                                      )) {
                                        throw 'No se puede abrir $url';
                                      }
                                    },
                                    text: 'Buscar en la web',
                                    icon: FaIcon(
                                      FontAwesomeIcons.externalLinkAlt,
                                      color: FlutterFlowTheme.of(context)
                                          .whiteColor,
                                      size: 20,
                                    ),
                                    options: FFButtonOptions(
                                      width: 160,
                                      height: 50,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryColor,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .bodyText2
                                          .override(
                                            fontFamily: 'Lexend Deca',
                                            color: FlutterFlowTheme.of(context)
                                                .whiteColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.normal,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(
                                                    FlutterFlowTheme.of(context)
                                                        .bodyText2Family),
                                          ),
                                      elevation: 3,
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  
                                  Container(
                                    width: anchoColumnaWrap,
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 12, 0, 0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Align(
                                              alignment:
                                                  AlignmentDirectional(0, 0),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 16, 0, 10),
                                                child: FlutterFlowDropDown<
                                                    EstadoActivo>(
                                                  initialOption: listEstados[0],
                                                  value:
                                                      dropDownValueEstadoActivo,
                                                  options: List.generate(
                                                      listEstados.length,
                                                      (index) =>
                                                          DropdownMenuItem(
                                                              value:
                                                                  listEstados[
                                                                      index],
                                                              child: Text(
                                                                listEstados[
                                                                        index]
                                                                    .descripcion
                                                                    .toString(),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyText1
                                                                    .override(
                                                                      fontFamily:
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyText2Family,
                                                                      fontSize:
                                                                          18,
                                                                      useGoogleFonts: GoogleFonts
                                                                              .asMap()
                                                                          .containsKey(
                                                                              FlutterFlowTheme.of(context).bodyText1Family),
                                                                    ),
                                                              ))),
                                                  onChanged: (val) =>
                                                      setState(() {
                                                    dropDownValueEstadoActivo =
                                                        val;
                                                    estadoActivoOpcion =
                                                        val!.id!;
                                                  }),
                                                  height: 50,
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyText1
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyText1Family,
                                                            fontSize: 18,
                                                            useGoogleFonts: GoogleFonts
                                                                    .asMap()
                                                                .containsKey(
                                                                    FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyText1Family),
                                                          ),
                                                  hintText: listEstados[0]
                                                      .descripcion,
                                                  fillColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primaryBackground,
                                                  elevation: 2,
                                                  borderColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .secondaryText,
                                                  borderWidth: 2,
                                                  borderRadius: 8,
                                                  margin: EdgeInsetsDirectional
                                                      .fromSTEB(12, 4, 12, 4),
                                                  hidesUnderline: true,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: anchoColumnaWrap,
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 12, 0, 0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Align(
                                              alignment:
                                                  AlignmentDirectional(0, 0),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 16, 0, 20),
                                                child: FutureBuilder<
                                                    List<Categoria>>(
                                                  future: _listaCategorias,
                                                  builder:
                                                      (BuildContext context,
                                                          snapshot) {
                                                    return FlutterFlowDropDown<
                                                        String>(
                                                      value:
                                                          dropDownValueCategoria,
                                                      options: (snapshot.connectionState ==
                                                                  ConnectionState
                                                                      .done &&
                                                              listCategorias
                                                                  .isNotEmpty)
                                                          ? List.generate(
                                                              snapshot
                                                                  .data!.length,
                                                              (index) =>
                                                                  DropdownMenuItem(
                                                                      value: snapshot
                                                                          .data![
                                                                              index]
                                                                          .nombre,
                                                                      child:
                                                                          Text(
                                                                        snapshot
                                                                            .data![index]
                                                                            .nombre
                                                                            .toString(),
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyText1
                                                                            .override(
                                                                              fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                                                                              fontSize: 18,
                                                                              useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyText1Family),
                                                                            ),
                                                                      )))
                                                          : List.generate(
                                                              0,
                                                              (index) =>
                                                                  DropdownMenuItem(
                                                                      value:
                                                                          null,
                                                                      child: Text(
                                                                          ''))),
                                                      onChanged: (val) =>
                                                          setState(() =>
                                                              dropDownValueCategoria =
                                                                  val),
                                                      height: 50,
                                                      textStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyText1
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyText2Family,
                                                                fontSize: 18,
                                                                useGoogleFonts: GoogleFonts
                                                                        .asMap()
                                                                    .containsKey(
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyText1Family),
                                                              ),
                                                      hintText: 'Categoria*',
                                                      fillColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryBackground,
                                                      elevation: 2,
                                                      borderColor:
                                                          _dropdownErrorColor
                                                              ? Colors.redAccent
                                                              : FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryText,
                                                      borderWidth: 2,
                                                      borderRadius: 8,
                                                      margin:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  12, 4, 12, 4),
                                                      hidesUnderline: true,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: tamanio_padding,
                          child: Divider(
                            height: 2,
                            thickness: 1,
                            color: Color(0x94ABB3BA),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      'Cantidad: ',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText1
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyText1Family,
                                            fontSize: 18,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(
                                                    FlutterFlowTheme.of(context)
                                                        .bodyText1Family),
                                          ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 12, 0, 0),
                                      child: Container(
                                        width: 160,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          shape: BoxShape.rectangle,
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            width: 1,
                                          ),
                                        ),
                                        child: FlutterFlowCountController(
                                          decrementIconBuilder: (enabled) =>
                                              FaIcon(
                                            FontAwesomeIcons.minus,
                                            color: enabled
                                                ? Color(0xA9D43538)
                                                : FlutterFlowTheme.of(context)
                                                    .boxShadow,
                                            size: 20,
                                          ),
                                          incrementIconBuilder: (enabled) =>
                                              FaIcon(
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
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .title2Family,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  useGoogleFonts: GoogleFonts
                                                          .asMap()
                                                      .containsKey(
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .title2Family),
                                                ),
                                          ),
                                          count: countControllerValue ??= 1,
                                          updateCount: (count) => setState(() =>
                                              countControllerValue = count),
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
          if (blur)
            ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 4,
                  sigmaY: 4,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: CircularProgressIndicator(
                          color: FlutterFlowTheme.of(context).primaryColor,
                          strokeWidth: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget TextFormFieldCustom(
      context,
      controlador,
      String hint,
      String label,
      int maxCharacters,
      tipo_teclado,
      esNumero,
      bool _esObligatorio,
      sufix,
      _focusNode) {
    return TextFormField(
      validator: (_esObligatorio)
          ? (value) {
              if (value == null || value.isEmpty) {
                return 'No deje este campo vacio';
              }
              return null;
            }
          : null,
      cursorColor: FlutterFlowTheme.of(context).primaryText,
      controller: controlador,
      keyboardType: tipo_teclado,
      inputFormatters: (esNumero == null)
          ? <TextInputFormatter>[
              LengthLimitingTextInputFormatter(maxCharacters),
            ]
          : esNumero,
      obscureText: false,
      focusNode: _focusNode,
      decoration: InputDecoration(
        fillColor: FlutterFlowTheme.of(context).primaryBackground,
        labelText: label,
        labelStyle: FlutterFlowTheme.of(context).title3.override(
              fontFamily: FlutterFlowTheme.of(context).title3Family,
              fontSize: 22,
              color: _focusNodeIdSerial.hasFocus
                  ? FlutterFlowTheme.of(context).primaryText
                  : FlutterFlowTheme.of(context).grayicon,
              useGoogleFonts: GoogleFonts.asMap()
                  .containsKey(FlutterFlowTheme.of(context).title3Family),
            ),
        hintText: hint,
        hintStyle: FlutterFlowTheme.of(context).title3.override(
              fontFamily: FlutterFlowTheme.of(context).title3Family,
              color: FlutterFlowTheme.of(context).secondaryText,
              fontSize: 22,
              useGoogleFonts: GoogleFonts.asMap()
                  .containsKey(FlutterFlowTheme.of(context).title3Family),
            ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0x94ABB3BA),
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
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.redAccent,
            width: 1,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4.0),
            topRight: Radius.circular(4.0),
          ),
        ),
        suffixIcon: sufix,
      ),
      style: FlutterFlowTheme.of(context).title3.override(
            fontFamily: FlutterFlowTheme.of(context).title3Family,
            fontSize: 22,
            color: FlutterFlowTheme.of(context).primaryText,
            useGoogleFonts: GoogleFonts.asMap()
                .containsKey(FlutterFlowTheme.of(context).title3Family),
          ),
    );
  }

  Future<String> registrarActivo(ActivoController activoController,
      BuildContext context, String? imagenUrl) async {
    String res = await activoController.addActivo(
        context,
        textControllerSerial.text,
        textControllerN_inventario.text,
        textControllerNombre.text,
        textControllerDetalles!.text,
        imagenUrl,
        estadoActivoOpcion,
        dropDownValueCategoria!,
        countControllerValue,
        null,
        null);
    return res;
  }

  Future<List<Categoria>> cargarCategorias() async {
    CategoriaController categoriaController = CategoriaController();
    listCategorias = await categoriaController.getCategorias(null);
    for (var element in listCategorias) {
      print('Lista categoria nombre: + ${element.nombre}');
      print('Lista categoria url: ${element.urlImagen}');
    }
    if(listCategorias!= null && listCategorias.length>0){
      listCategorias.removeWhere((item) => item.nombre == 'Todos los activos');
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
      child: DottedBorder(
        color: FlutterFlowTheme.of(context).grayicon,
        strokeWidth: 2,
        dashPattern: [10, 10],
        child: Container(
            width: 250,
            height: 200,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: urlImagen != null && imageFile == null
                    ? DecorationImage(
                        fit: BoxFit.cover, image: NetworkImage(urlImagen))
                    : null),
            child: urlImagen == null || imageFile != null
                ? _decideImageView(imageFile)
                : null),
      ),
    );
  }

  Widget _decideImageView(imageFile) {
    if (imageFile == null) {
      return Center(
        child: Icon(
          FontAwesomeIcons.camera,
          size: 40,
        ),
      );
    } else {
      return Image.file(
        imageFile,
        width: 250,
        height: 200,
        fit: BoxFit.cover,
      );
    }
  }
}

EdgeInsetsGeometry defTamanoAncho(screenSize) {
  if (screenSize < 640) {
    return EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0);
  } else {
    return EdgeInsetsDirectional.fromSTEB(50, 50, 50, 50);
  }
}
