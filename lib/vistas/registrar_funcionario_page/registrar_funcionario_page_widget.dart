import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:app_gestion_prestamo_inventario/entidades/activo_impresora.dart';
import 'package:app_gestion_prestamo_inventario/entidades/estadoActivo.dart';
import 'package:app_gestion_prestamo_inventario/entidades/funcionario.dart';
import 'package:app_gestion_prestamo_inventario/servicios/activoController.dart';
import 'package:app_gestion_prestamo_inventario/servicios/categoriaController.dart';
import 'package:app_gestion_prestamo_inventario/servicios/funcionariosController.dart';
import 'package:app_gestion_prestamo_inventario/servicios/storageController.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../entidades/activo.dart';
import '../../entidades/area.dart';
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

class RegistrarFuncionarioPageWidget extends StatefulWidget {
  final String? operacionaRealizar;
  final String? id;
  final Funcionario? funcionarioEditar;

  const RegistrarFuncionarioPageWidget(
      {Key? key, this.operacionaRealizar, this.id, this.funcionarioEditar})
      : super(key: key);

  @override
  _RegistrarFuncionarioPageWidgetState createState() =>
      _RegistrarFuncionarioPageWidgetState(
          this.operacionaRealizar, this.id, this.funcionarioEditar);
}

class _RegistrarFuncionarioPageWidgetState
    extends State<RegistrarFuncionarioPageWidget>
    with SingleTickerProviderStateMixin {
  EstadoActivo? dropDownValueEstadoActivo;
  TextEditingController textControllerApellidos = TextEditingController();
  TextEditingController textControllerCedula = TextEditingController();
  TextEditingController textControllerNombres = TextEditingController();
  TextEditingController? textControllerCorreo = TextEditingController();
  TextEditingController? controladorimagenUrl = TextEditingController();
  TextEditingController textControllerTelefono_1 = TextEditingController();
  TextEditingController textControllerTelefono_2 = TextEditingController();
  TextEditingController textControllerEnlaceSIGEP = TextEditingController();
  TextEditingController textControllerCargo = TextEditingController();
  Area? dropDownValueArea;
  int? countControllerValue = 1;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<Area> listAreas = [];
  List<EstadoActivo> listEstados = [
    EstadoActivo(0, 'Bueno: Activo en buen estado'),
    EstadoActivo(1,
        'Regular: Activo con desperfectos o daños menores pero en perfecto estado funcional'),
    EstadoActivo(2, 'Malo: Activo en mal estado o dañado'),
  ];
  File? imageFile;
  bool blur = false;

  String? urlImagen;
  final ImagePicker picker = ImagePicker();
  late String result;
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool _errorColor = false;
  bool _dropdownErrorColor = false;

  CategoriaController categoriaController = CategoriaController();
  late final _listaAreas = cargarAreas();
  int? numInventario;
  int estadoActivoOpcion = 0;
  Funcionario? activo;
  final String? operacionaRealizar;
  final String? id;
  int idArea = 0;
  int anchominimo = 640;

  final Funcionario? funcionarioEditar;
  FocusNode _focusNodeCorreo = FocusNode();
  FocusNode _focusNodeCedula = FocusNode();
  FocusNode _focusNodeNombre = FocusNode();
  FocusNode _focusNodeApellidos = FocusNode();
  FocusNode _focusNodeTelefono_1 = FocusNode();
  FocusNode _focusNodeTelefono_2 = FocusNode();
  FocusNode _focusNodeEnlaceSIGEP = FocusNode();
  FocusNode _focusNodeCargo = FocusNode();
  Color color = Colors.red;
  List<TextInputFormatter> inputNumero = <TextInputFormatter>[
    // for below version 2 use this
    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
// for version 2 and greater youcan also use this
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(10),
  ];

  List<TextInputFormatter> inputFormater = <TextInputFormatter>[
    LengthLimitingTextInputFormatter(10),
  ];

  _RegistrarFuncionarioPageWidgetState(
      this.operacionaRealizar, this.id, this.funcionarioEditar);

  // ignore: prefer_final_fields5

  @override
  void initState() {
    super.initState();
    if (funcionarioEditar != null) {
      textControllerApellidos.text = funcionarioEditar!.apellidos.toString();
      textControllerCedula.text = funcionarioEditar!.cedula.toString();
      textControllerNombres.text = funcionarioEditar!.nombres.toString();
      textControllerCorreo!.text = funcionarioEditar!.correo.toString();
      textControllerTelefono_1.text = funcionarioEditar!.telefono1.toString();
      (funcionarioEditar!.telefono2 != null)
          ? textControllerTelefono_2.text =
              funcionarioEditar!.telefono2.toString()
          : textControllerTelefono_2.text = "";
      textControllerCargo.text = funcionarioEditar!.cargo.toString();
      dropDownValueArea!.id = funcionarioEditar!.idArea;
    } else {
      id != null
          ? textControllerApellidos.text = id.toString()
          : textControllerApellidos.text = '';

      textControllerCedula.text = '';
    }
  }

  @override
  void dispose() {
    super.dispose();
    textControllerApellidos.dispose();
    textControllerCedula.dispose();
    textControllerNombres.dispose();
    textControllerCorreo?.dispose();
    textControllerCargo.dispose();
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
                dropDownValueArea != null) {
              setState(() {
                blur = true;
              });
              String? imagenUrl;
              log('serial: ${textControllerApellidos.text.toString()}');

              if (imageFile != null) {
                StorageController storageController = StorageController();
                imagenUrl = await storageController.subirImagen(
                    context,
                    imageFile!.path.toString(),
                    imageFile!,
                    textControllerCedula.text,
                    'funcionarios');
                FuncionariosController funcionarioController =
                    FuncionariosController();
                String res = '';
                // ignore: use_build_context_synchronously
                if (imagenUrl != 'error') {
                  res = await registrarFuncionario(
                      funcionarioController, context, imagenUrl);

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
                FuncionariosController funcionarioController =
                    FuncionariosController();
                String res = await registrarFuncionario(
                    funcionarioController,
                    context,
                    'https://www.giulianisgrupo.com/wp-content/uploads/2018/05/nodisponible.png');
                if (res == 'ok') {
                  setState(() {
                    blur = false;
                  });
                  Timer(Duration(seconds: 3), () {
                    context.pop();
                  });
                }
              }
            } else if (dropDownValueArea == null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  "Seleccione el área donde se encuentra el funcionario",
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
                blur = false;
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
                  "No deje campos obligatorios (*) vacios",
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
                blur = false;
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
                      ? EdgeInsetsDirectional.all(10)
                      : EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
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
                                      'Seleccione una imagen',
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
                                            0, 16, 10, 14),
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
                                          'http://www.lajaguadeibirico-cesar.gov.co/tema/directorio-de-funcionarios');
                                      if (!await launchUrl(
                                        url,
                                        mode: LaunchMode.externalApplication,
                                      )) {
                                        throw 'No se puede abrir $url';
                                      }
                                    },
                                    text: 'Buscar imagen en la web',
                                    icon: FaIcon(
                                      FontAwesomeIcons.externalLinkAlt,
                                      color: FlutterFlowTheme.of(context)
                                          .whiteColor,
                                      size: 20,
                                    ),
                                    options: FFButtonOptions(
                                      width: 230,
                                      height: 55,
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
                                    child: Align(
                                      alignment: AlignmentDirectional(0, 0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 50, 5, 0),
                                            child: FaIcon(
                                              FontAwesomeIcons.solidIdCard,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .grayicon,
                                              size: 28,
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 30, 0, 0),
                                              child: TextFormFieldCustom(
                                                  context,
                                                  textControllerCedula,
                                                  'Ej. 1065324298',
                                                  'Número de cédula*',
                                                  10,
                                                  TextInputType.number,
                                                  inputNumero,
                                                  true,
                                                  null,
                                                  _focusNodeCedula),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: anchoColumnaWrap,
                                    child: Align(
                                      alignment: AlignmentDirectional(0.05, 0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 50, 5, 0),
                                            child: FaIcon(
                                              FontAwesomeIcons.solidUser,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .grayicon,
                                              size: 28,
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 30, 0, 0),
                                              child: TextFormFieldCustom(
                                                  context,
                                                  textControllerNombres,
                                                  'Ej. Luis Carlos',
                                                  'Nombres*',
                                                  30,
                                                  TextInputType.name,
                                                  null,
                                                  true,
                                                  null,
                                                  _focusNodeNombre),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: anchoColumnaWrap,
                                    child: Align(
                                      alignment: AlignmentDirectional(0.05, 0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 50, 5, 0),
                                            child: FaIcon(
                                              FontAwesomeIcons.solidUser,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .grayicon,
                                              size: 28,
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 30, 0, 0),
                                              child: TextFormFieldCustom(
                                                  context,
                                                  textControllerApellidos,
                                                  'Ej. Calderon Gutierrez',
                                                  'Apellidos',
                                                  30,
                                                  TextInputType.name,
                                                  null,
                                                  false,
                                                  null,
                                                  _focusNodeApellidos),
                                            ),
                                          )
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
                                                child:
                                                    FutureBuilder<List<Area>>(
                                                  future: _listaAreas,
                                                  builder:
                                                      (BuildContext context,
                                                          snapshot) {
                                                    return FlutterFlowDropDown<
                                                        Area>(
                                                      value: dropDownValueArea,
                                                      options: (snapshot
                                                                      .connectionState ==
                                                                  ConnectionState
                                                                      .done &&
                                                              listAreas
                                                                  .isNotEmpty)
                                                          ? List.generate(
                                                              snapshot
                                                                  .data!.length,
                                                              (index) =>
                                                                  DropdownMenuItem(
                                                                      value: snapshot
                                                                              .data![
                                                                          index],
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
                                                              dropDownValueArea =
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
                                                      hintText: 'Área*',
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
                        (MediaQuery.of(context).size.width < anchominimo)
                            ? Container()
                            : Padding(
                                padding: tamanio_padding,
                                child: Divider(
                                  height: 2,
                                  thickness: 1,
                                  color: Color(0x94ABB3BA),
                                ),
                              ),
                        Column(
                          children: [
                            Padding(
                              padding: tamanio_padding,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 30, 15, 0),
                                    child: FaIcon(
                                      FontAwesomeIcons.suitcase,
                                      color:
                                          FlutterFlowTheme.of(context).grayicon,
                                      size: 25,
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFormFieldCustom(
                                        context,
                                        textControllerCargo,
                                        '',
                                        'Cargo*',
                                        30,
                                        TextInputType.name,
                                        null,
                                        true,
                                        null,
                                        _focusNodeCargo),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: tamanio_padding,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 30, 15, 0),
                                    child: Icon(
                                      Icons.mail,
                                      color:
                                          FlutterFlowTheme.of(context).grayicon,
                                      size: 28,
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFormFieldCustom(
                                        context,
                                        textControllerCorreo,
                                        'Ej. Sistemas@lajaguadeIbirico-Cesar.gov.co',
                                        'Correo eléctronico',
                                        100,
                                        TextInputType.emailAddress,
                                        null,
                                        false,
                                        null,
                                        _focusNodeCorreo),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: tamanio_padding,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 30, 15, 0),
                                    child: FaIcon(
                                      FontAwesomeIcons.phone,
                                      color:
                                          FlutterFlowTheme.of(context).grayicon,
                                      size: 25,
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFormFieldCustom(
                                        context,
                                        textControllerTelefono_1,
                                        'Ej.3104562222',
                                        'Número de teléfono*',
                                        10,
                                        TextInputType.phone,
                                        inputNumero,
                                        true,
                                        null,
                                        _focusNodeTelefono_1),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: tamanio_padding,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 30, 15, 0),
                                    child: FaIcon(
                                      FontAwesomeIcons.phone,
                                      color:
                                          FlutterFlowTheme.of(context).grayicon,
                                      size: 25,
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFormFieldCustom(
                                        context,
                                        textControllerTelefono_2,
                                        '',
                                        'Número de teléfono alternativo',
                                        10,
                                        TextInputType.phone,
                                        inputNumero,
                                        false,
                                        null,
                                        _focusNodeTelefono_2),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: (MediaQuery.of(context).size.width <
                                      anchominimo)
                                  ? EdgeInsetsDirectional.fromSTEB(
                                      10, 10, 10, 65)
                                  : tamanio_padding,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 30, 16, 0),
                                    child: FaIcon(
                                      FontAwesomeIcons.globe,
                                      color:
                                          FlutterFlowTheme.of(context).grayicon,
                                      size: 25,
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFormFieldCustom(
                                        context,
                                        textControllerEnlaceSIGEP,
                                        'Ej. https://www.funcionpublica.gov.co/web/sigep/hdv/-/directorio/S2138649-0690-4/view',
                                        'Enlace al SIGEP',
                                        150,
                                        TextInputType.url,
                                        null,
                                        false,
                                        null,
                                        _focusNodeEnlaceSIGEP),
                                  ),
                                  FlutterFlowIconButton(
                                    borderColor: Colors.transparent,
                                    borderRadius: 30,
                                    borderWidth: 1,
                                    buttonSize: 45,
                                    icon: Icon(
                                      Icons.content_paste,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      size: 30,
                                    ),
                                    onPressed: () {
                                      Clipboard.getData(Clipboard.kTextPlain)
                                          .then((value) {
                                        if (value != null) {
                                          if (value.text!.trim().isNotEmpty) {
                                            textControllerEnlaceSIGEP.text =
                                                value.text!.trim();
                                          }
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
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
              color: _focusNodeCorreo.hasFocus
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

  Future<String> registrarFuncionario(
      FuncionariosController funcionarioController,
      BuildContext context,
      String? imagenUrl) async {
    var res = await funcionarioController.addFuncionario(
        context: context,
        apellidos: textControllerApellidos.text,
        cedula: textControllerCedula.text,
        nombres: textControllerNombres.text,
        correo: textControllerCorreo!.text,
        urlImagen: imagenUrl,
        cargo: textControllerCargo.text,
        idArea: dropDownValueArea!.id,
        telefono1: textControllerTelefono_1.text,
        telefono2: textControllerTelefono_2.text,
        enlaceSIGEP: textControllerEnlaceSIGEP.text);
    return res;
  }

  Future<List<Area>> cargarAreas() async {
    FuncionariosController funcionarioController = FuncionariosController();
    listAreas = await funcionarioController.getAreas();
    return Future.value(listAreas);
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
    final FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      dialogTitle: 'Seleccionar imagen',
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'gif', 'gif', 'bmp', 'webp'],
    );
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
      child: (imageFile == null || imageFile.toString().isEmpty)
          ? DottedBorder(
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
                  child: _decideImageView(imageFile)))
          : Container(
              width: 250,
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).primaryText,
                    width: 2,
                  ),
                  shape: BoxShape.rectangle,
                  image: urlImagen != null && imageFile == null
                      ? DecorationImage(
                          fit: BoxFit.cover, image: NetworkImage(urlImagen))
                      : null),
              child: _decideImageView(imageFile)),
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
      return ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.file(
          imageFile,
          width: 250,
          height: 200,
          fit: BoxFit.cover,
        ),
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
