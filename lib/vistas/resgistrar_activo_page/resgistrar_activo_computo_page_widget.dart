// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'dart:io';
import 'dart:ui';
import 'package:app_gestion_prestamo_inventario/entidades/activo_impresora.dart';
import 'package:app_gestion_prestamo_inventario/entidades/componenteExterno.dart';
import 'package:app_gestion_prestamo_inventario/entidades/componenteInterno.dart';
import 'package:app_gestion_prestamo_inventario/entidades/estadoActivo.dart';
import 'package:app_gestion_prestamo_inventario/index.dart';
import 'package:app_gestion_prestamo_inventario/servicios/activoController.dart';
import 'package:app_gestion_prestamo_inventario/servicios/categoriaController.dart';
import 'package:app_gestion_prestamo_inventario/servicios/componenteExternoController.dart';
import 'package:app_gestion_prestamo_inventario/servicios/componenteInternoController.dart';
import 'package:app_gestion_prestamo_inventario/servicios/pdfApi.dart';
import 'package:app_gestion_prestamo_inventario/servicios/softwareController.dart';
import 'package:app_gestion_prestamo_inventario/servicios/storageController.dart';
import 'package:app_gestion_prestamo_inventario/vistas/registrar_funcionario_page/registrar_funcionario_page_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../entidades/activo.dart';
import '../../entidades/categoria.dart';
import '../../entidades/software.dart';
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

import '../lista_activos_page/lista_activos_page_widget.dart';

class ResgistrarActivoPageWidget extends StatefulWidget {
  final String? operacionaRealizar;
  final String? idSerial;
  final int idCategoria;
  final Activo? activoEditar;
  final List<Activo>? listComponentesExActivos;
  final List<ComponenteInterno>? listComponentesInternos;
  final List<Software>? listSoftware;
  const ResgistrarActivoPageWidget(
      {Key? key,
      this.operacionaRealizar,
      this.idSerial,
      this.idCategoria = 0,
      this.activoEditar,
      this.listComponentesInternos,
      this.listComponentesExActivos,
      this.listSoftware})
      : super(key: key);

  @override
  _ResgistrarActivoPageWidgetState createState() =>
      _ResgistrarActivoPageWidgetState(
          this.operacionaRealizar,
          this.idSerial,
          this.idCategoria,
          this.activoEditar,
          this.listComponentesExActivos,
          this.listComponentesInternos,
          this.listSoftware);
}

class _ResgistrarActivoPageWidgetState extends State<ResgistrarActivoPageWidget>
    with SingleTickerProviderStateMixin {
  EstadoActivo? dropDownValueEstadoActivo;
  TextEditingController textControllerSerial = TextEditingController();
  TextEditingController textControllerN_inventario = TextEditingController();
  TextEditingController textControllerNombre = TextEditingController();
  TextEditingController? textControllerDetalles = TextEditingController();
  TextEditingController? controladorimagenUrl = TextEditingController();
  Categoria dropDownValueCategoria = Categoria(
      id: 3,
      'Proyectores',
      'https://mainframeltda.com/wp-content/uploads/2019/04/Que_es_un_proyector_de_video-1100x825.jpg',
      'Proyectores y video beams utilizados para presentaciones');
  int? idCategoriaValue;
  String? dropDownvalueTipoLicencia;
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
  String? imageEdit;
  int anchominimo = 640;
  bool blur = false;
  bool blurHojaVida = false;
  bool guardadoExitosamente = false;

  String? urlImagen;
  final ImagePicker picker = ImagePicker();
  late String result;
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool _errorColor = false;
  bool _dropdownErrorColor = false;
  TextEditingController controladorObservacion = TextEditingController();
  CategoriaController categoriaController = CategoriaController();
  late final _listaCategorias = cargarCategorias();
  int? numInventario;
  int estadoActivoOpcion = 0;
  Activo? activo;
  final String? operacionaRealizar;
  final String? idSerial;
  int idCategoria = 0;
  final Activo? activoEditar;

  List<Activo> listComponentesExActivos = [];
  List<Activo>? listComponentesExActivosNull;
  List<ComponenteInterno> listComponentesInternos = [
    ComponenteInterno(
        titulo: 'CPU',
        nombre: 'Procesador',
        urlImagen: 'https://cdn-icons-png.flaticon.com/512/689/689338.png'),
    ComponenteInterno(
        titulo: 'Memoria RAM',
        nombre: 'Memoria RAM',
        urlImagen: 'https://cdn-icons-png.flaticon.com/512/689/689328.png'),
    ComponenteInterno(
        titulo: 'Disco Duro',
        nombre: 'Disco Duro',
        urlImagen: 'https://cdn-icons-png.flaticon.com/512/689/689331.png'),
  ];
  List<ComponenteInterno>? listComponentesInternosNull;
  List<Software> listSoftware = [
    Software(
      titulo: 'Sistemas operativo',
      urlImagen: 'https://ujftfjxhobllfwadrwqj.supabase.co/storage/v1/object/public/activos/windows-icon-png-5802.png?t=2023-04-23T22%3A01%3A15.520Z',
      nombre: 'Windows',
      fabricante: 'Microsoft',
      version: '10 Pro',
    ),
    Software(
      titulo: 'Microsoft Office',
      urlImagen: 'https://cdn-icons-png.flaticon.com/512/888/888867.png',
      nombre: 'Office',
      fabricante: 'Microsoft',
      version: '2013 Pro',
    ),
    Software(
      titulo: 'Antivirus',
      urlImagen: 'https://cdn-icons-png.flaticon.com/512/2961/2961132.png',
      nombre: 'Eset Endpoint Antivirus',
      fabricante: 'ESET',
      tipoLicencia: 'Multi Usuario',
      licenciaClave: 'AD9R-XUWB-62AT-V48C-AJXK',
      version: '10',
    )
  ];
  List<Software>? listSoftwareNull;
  List<String> listTipoLicencia = ['Mono Usuario', 'Multi Usuario', 'Gratuita'];
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

  _ResgistrarActivoPageWidgetState(
      this.operacionaRealizar,
      this.idSerial,
      this.idCategoria,
      this.activoEditar,
      this.listComponentesExActivosNull,
      this.listComponentesInternosNull,
      this.listSoftwareNull);

  // ignore: prefer_final_fields5

  @override
  void initState() {
    super.initState();

    if (activoEditar != null) {
      textControllerSerial.text = activoEditar!.idSerial.toString();
      textControllerN_inventario.text = activoEditar!.numActivo.toString();
      textControllerNombre.text = activoEditar!.nombre.toString();
      textControllerDetalles!.text = activoEditar!.detalles.toString();
      imageEdit = activoEditar!.urlImagen.toString();
      dropDownValueCategoria.nombre = activoEditar!.categoria.toString();
      idCategoriaValue = activoEditar!.idCategoria;
    } else {
      idSerial != null
          ? textControllerSerial.text = idSerial.toString()
          : textControllerSerial.text = '';

      textControllerN_inventario.text = '';
      textControllerNombre.text = '';
    }
    if (listComponentesExActivosNull != null &&
        listComponentesExActivosNull!.isNotEmpty) {
      listComponentesExActivos = listComponentesExActivosNull!;
    }
    if (listComponentesInternosNull != null &&
        listComponentesInternosNull!.isNotEmpty) {
      listComponentesInternos = listComponentesInternosNull!;
    }
    if (listSoftwareNull != null && listSoftwareNull!.isNotEmpty) {
      listSoftware = listSoftwareNull!;
    }
    for (var element in listComponentesInternos) {
      element.nombreTextEditingController.text = element.nombre;
      element.marcaTextEditingController.text = element.marca;
      element.velocidadTextEditingController.text = element.velocidad;
      element.otrasCaracteristicasTextEditingController.text =
          element.otrasCaracteristicas;
    }
    for (var element in listSoftware) {
      element.nombreController.text = element.nombre;
      element.fabricanteController.text = element.fabricante;
      element.versionController.text = element.version;
      element.dropdownvalue = element.tipoLicencia;
      element.licenciaClaveController.text = element.licenciaClave;
    }
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {});
    });
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
            List<ComponenteExterno> listComponeteExterno = [];
            for (var element in listComponentesExActivos) {
              ComponenteExterno componenteExterno = ComponenteExterno(
                  idEquipoComputo: textControllerSerial.text,
                  idComponente: element.idSerial);
              listComponeteExterno.add(componenteExterno);
            }
            for (var element in listComponentesInternos) {
              element.nombre = element.nombreTextEditingController.text;
              element.marca = element.marcaTextEditingController.text;
              element.velocidad = element.velocidadTextEditingController.text;
              element.otrasCaracteristicas =
                  element.otrasCaracteristicasTextEditingController.text;
            }

            for (var element in listSoftware) {
              element.nombre = element.nombreController.text;
              element.fabricante = element.fabricanteController.text;
              element.version = element.versionController.text;
              element.version = element.versionController.text;
              element.licenciaClave = element.licenciaClaveController.text;
            }
            Logger().v(
                _formKey.currentState!.validate() && idCategoriaValue != null);
            if (_formKey.currentState!.validate() && idCategoria > 0) {
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
                  // ignore: use_build_context_synchronously
                  if (activoEditar != null) {
                    // ignore: use_build_context_synchronously
                    res = await registrarActivo(
                        activoController,
                        context,
                        imagenUrl,
                        listSoftware,
                        listComponeteExterno,
                        listComponentesInternos,
                        editar: true);
                  } else {
                    res = await registrarActivo(
                        activoController,
                        context,
                        imagenUrl,
                        listSoftware,
                        listComponeteExterno,
                        listComponentesInternos);
                  }

                  if (res == 'ok') {
                    Future.delayed(const Duration(seconds: 1), () {
                      if (idCategoria != 8) {
                        setState(() {
                          blur = false;
                        });
                        Navigator.pop(context);
                      } else {
                        setState(() {
                          guardadoExitosamente = true;
                        });
                      }
                    });
                  } else {
                    setState(() {
                      blur = false;
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
                  if (activoEditar != null) {
                    res = await registrarActivo(
                        activoController,
                        context,
                        activoEditar!.urlImagen,
                        listSoftware,
                        listComponeteExterno,
                        listComponentesInternos,
                        editar: true);
                  } else {
                    res = await registrarActivo(
                        activoController,
                        context,
                        'https://www.giulianisgrupo.com/wp-content/uploads/2018/05/nodisponible.png',
                        listSoftware,
                        listComponeteExterno,
                        listComponentesInternos);
                  }

                  if (res == 'ok') {
                    Future.delayed(const Duration(seconds: 1), () {
                      if (idCategoria != 8) {
                        setState(() {
                          blur = false;
                        });
                        Navigator.of(context).pop();
                      } else {
                        setState(() {
                          guardadoExitosamente = true;
                        });
                      }
                    });
                  } else {
                    setState(() {
                      blur = false;
                    });
                  }
                } else {
                  setState(() {
                    blur = false;
                  });
                }
              }
            } else if (idCategoria <= 0) {
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
            Navigator.pop(context);
          },
          child: Icon(
            Icons.chevron_left_rounded,
            color: FlutterFlowTheme.of(context).whiteColor,
            size: 30,
          ),
        ),
        title: Text(
          'Registrar activo',
          textAlign: TextAlign.start,
          style: FlutterFlowTheme.of(context).subtitle1.override(
                fontFamily: FlutterFlowTheme.of(context).title1Family,
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
          SingleChildScrollView(
            child: Column(
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
                      borderRadius: (MediaQuery.of(context).size.width <
                              anchominimo)
                          ? null
                          : BorderRadius.circular(30), //border corner radius
                    ),
                    child: Padding(
                      padding: (MediaQuery.of(context).size.width < anchominimo)
                          ? EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10)
                          : EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Form(
                              key: _formKey,
                              child: Column(
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
                                              _focusNodeIdSerial,
                                              soloLectura:
                                                  (activoEditar != null)
                                                      ? true
                                                      : false),
                                        ),
                                        Container(
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color: (Platform.isAndroid ||
                                                    Platform.isIOS)
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
                                            fillColor: (Platform.isAndroid ||
                                                    Platform.isIOS)
                                                ? Color(0x00F1F4F8)
                                                : FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                            borderColor: Colors.transparent,
                                            borderRadius: 30,
                                            borderWidth: 1,
                                            buttonSize: 60,
                                            icon: FaIcon(
                                              FontAwesomeIcons.barcode,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              size: 30,
                                            ),
                                            onPressed: () async {
                                              if (activoEditar == null) {
                                                if (Platform.isAndroid ||
                                                    Platform.isIOS) {
                                                  String res = await FlutterBarcodeScanner
                                                      .scanBarcode(
                                                          '#C62828', // scanning line color
                                                          'Cancel', // cancel button text
                                                          true, // whether to show the flash icon
                                                          ScanMode.BARCODE);
                                                  textControllerSerial.text =
                                                      res
                                                          .trim()
                                                          .replaceAll(".", "");
                                                } else {
                                                  Clipboard.getData(
                                                          Clipboard.kTextPlain)
                                                      .then((value) {
                                                    if (value != null) {
                                                      if (value.text!
                                                          .trim()
                                                          .isNotEmpty) {
                                                        textControllerSerial
                                                                .text =
                                                            value.text!
                                                                .trim()
                                                                .replaceAll(
                                                                    ".", "");
                                                      }
                                                    }
                                                  });
                                                }
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 5, 10, 12),
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
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 5, 10, 12),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
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
                                                Icon(
                                                  Icons.title,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  size: 30,
                                                ),
                                                _focusNodeNombre),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 5, 10, 12),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                              padding: tamanio_padding,
                                              child: TextFormFieldCustom(
                                                  context,
                                                  textControllerDetalles,
                                                  'Ej.HP',
                                                  'Marca',
                                                  150,
                                                  TextInputType.multiline,
                                                  null,
                                                  false,
                                                  null,
                                                  _focusNodeDetalles)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
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
                                          'Toca en la cámara para subir una imagen',
                                          textAlign: TextAlign.center,
                                          style: FlutterFlowTheme.of(context)
                                              .title3,
                                        ),
                                      ),
                                      Container(
                                        width:
                                            (MediaQuery.of(context).size.width <
                                                    anchominimo)
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.9
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2,
                                        child: Center(
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 16, 0, 14),
                                            child: Center(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: imagenPerfil(context,
                                                    urlImagen, imageFile),
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
                                            mode:
                                                LaunchMode.externalApplication,
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
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .bodyText2
                                              .override(
                                                fontFamily: 'Lexend Deca',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .whiteColor,
                                                fontSize: 20,
                                                fontWeight: FontWeight.normal,
                                                useGoogleFonts: GoogleFonts
                                                        .asMap()
                                                    .containsKey(
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyText2Family),
                                              ),
                                          elevation: 3,
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        width: anchoColumnaWrap,
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
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
                                                      AlignmentDirectional(
                                                          0, 0),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 16, 0, 10),
                                                    child: FlutterFlowDropDown<
                                                        EstadoActivo>(
                                                      initialOption:
                                                          (activoEditar != null)
                                                              ? listEstados[
                                                                  activoEditar!
                                                                      .estado]
                                                              : listEstados[0],
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
                                                                              FlutterFlowTheme.of(context).bodyText2Family,
                                                                          fontSize:
                                                                              18,
                                                                          useGoogleFonts:
                                                                              GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyText1Family),
                                                                        ),
                                                                  ))),
                                                      onChanged: (val) =>
                                                          setState(() {
                                                        dropDownValueEstadoActivo =
                                                            val!;
                                                        estadoActivoOpcion =
                                                            val.id!;
                                                      }),
                                                      height: 50,
                                                      textStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyText1
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyText1Family,
                                                                fontSize: 18,
                                                                useGoogleFonts: GoogleFonts
                                                                        .asMap()
                                                                    .containsKey(
                                                                        FlutterFlowTheme.of(context)
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
                                                      margin:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  12, 4, 12, 4),
                                                      hidesUnderline: true,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      FutureBuilder<List<Categoria>>(
                                        future: _listaCategorias,
                                        builder:
                                            (BuildContext context, snapshot) {
                                          if (snapshot.connectionState ==
                                                  ConnectionState.done &&
                                              snapshot.hasData) {
                                            return Container(
                                              width: anchoColumnaWrap,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 20),
                                                    child: Text(
                                                      'Categoria',
                                                      textAlign:
                                                          TextAlign.start,
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyText1
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyText1Family,
                                                                fontSize: 20,
                                                                useGoogleFonts: GoogleFonts
                                                                        .asMap()
                                                                    .containsKey(
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyText1Family),
                                                              ),
                                                    ),
                                                  ),
                                                  Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0, 12, 0, 0),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Align(
                                                              alignment:
                                                                  AlignmentDirectional(
                                                                      0, 0),
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0,
                                                                            5,
                                                                            0,
                                                                            20),
                                                                child: FlutterFlowDropDown<
                                                                    Categoria>(
                                                                  value: (idCategoria >
                                                                              0 &&
                                                                          snapshot
                                                                              .hasData &&
                                                                          snapshot.data!.length >=
                                                                              idCategoria)
                                                                      ? snapshot
                                                                              .data![
                                                                          idCategoria -
                                                                              1]
                                                                      : snapshot
                                                                          .data![1],
                                                                  options: List.generate(
                                                                      snapshot.data!.length,
                                                                      (index) => DropdownMenuItem(
                                                                          value: snapshot.data![index],
                                                                          child: Text(
                                                                            snapshot.data![index].nombre.toString(),
                                                                            style: FlutterFlowTheme.of(context).bodyText1.override(
                                                                                  fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                                                                                  fontSize: 18,
                                                                                  useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyText1Family),
                                                                                ),
                                                                          ))),
                                                                  onChanged:
                                                                      (val) {
                                                                    if (val !=
                                                                        null) {
                                                                      idCategoria =
                                                                          val.id;
                                                                      setState(
                                                                          () {
                                                                        idCategoria =
                                                                            val.id;
                                                                        dropDownValueCategoria.nombre =
                                                                            val.nombre;
                                                                      });
                                                                    }
                                                                  },
                                                                  height: 50,
                                                                  textStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyText1
                                                                      .override(
                                                                        fontFamily:
                                                                            FlutterFlowTheme.of(context).bodyText2Family,
                                                                        fontSize:
                                                                            18,
                                                                        useGoogleFonts:
                                                                            GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyText1Family),
                                                                      ),
                                                                  hintText:
                                                                      'Área*',
                                                                  initialOption: (activoEditar !=
                                                                              null &&
                                                                          snapshot
                                                                              .hasData &&
                                                                          snapshot.connectionState ==
                                                                              ConnectionState
                                                                                  .done)
                                                                      ? snapshot
                                                                              .data![
                                                                          idCategoria -
                                                                              1]
                                                                      : Categoria(
                                                                          id: 3,
                                                                          'Proyectores',
                                                                          'https://mainframeltda.com/wp-content/uploads/2019/04/Que_es_un_proyector_de_video-1100x825.jpg',
                                                                          'Proyectores y video beams utilizados para presentaciones'),
                                                                  fillColor: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryBackground,
                                                                  elevation: 2,
                                                                  borderColor: _dropdownErrorColor
                                                                      ? Colors
                                                                          .redAccent
                                                                      : FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryText,
                                                                  borderWidth:
                                                                      2,
                                                                  borderRadius:
                                                                      8,
                                                                  margin: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          12,
                                                                          4,
                                                                          12,
                                                                          4),
                                                                  hidesUnderline:
                                                                      true,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                ],
                                              ),
                                            );
                                          } else {
                                            return Container();
                                          }
                                        },
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
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 16),
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
                                                useGoogleFonts: GoogleFonts
                                                        .asMap()
                                                    .containsKey(
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyText1Family),
                                              ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 12, 0, 0),
                                          child: Container(
                                            width: 160,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                              shape: BoxShape.rectangle,
                                              border: Border.all(
                                                color:
                                                    FlutterFlowTheme.of(context)
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
                                                    : FlutterFlowTheme.of(
                                                            context)
                                                        .boxShadow,
                                                size: 20,
                                              ),
                                              incrementIconBuilder: (enabled) =>
                                                  FaIcon(
                                                FontAwesomeIcons.plus,
                                                color: enabled
                                                    ? FlutterFlowTheme.of(
                                                            context)
                                                        .primaryColor
                                                    : FlutterFlowTheme.of(
                                                            context)
                                                        .boxShadow,
                                                size: 20,
                                              ),
                                              countBuilder: (count) => Text(
                                                count.toString(),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .title2
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .title2Family,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
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
                                              updateCount: (count) => setState(
                                                  () => countControllerValue =
                                                      count),
                                              stepSize: 1,
                                              minimum: 1,
                                              maximum: (idCategoria!=8)?99:1,
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
                //primer bloque
                if (idCategoria == 8)
                  Padding(
                    padding: defTamanoAnchoSecundario(
                        MediaQuery.of(context).size.width),
                    child: Container(
                      margin: (MediaQuery.of(context).size.width < anchominimo)
                          ? EdgeInsets.fromLTRB(0, 15, 0, 0)
                          : EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: (MediaQuery.of(context).size.width <
                                anchominimo)
                            ? null
                            : BorderRadius.circular(30), //border corner radius
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 5, 10, 5),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Software',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyText1
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyText1Family,
                                        fontSize: 24,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyText1Family),
                                      ),
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: listSoftware.length,
                              itemBuilder: (BuildContext context, int index) {
                                return _tarjetaSoftware(listSoftware[index]);
                              },
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 25, 0, 12),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        listSoftware.add(Software());
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          5, 5, 5, 5),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 3,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .boxShadow,
                                              spreadRadius: 1,
                                            )
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                          ),
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  8, 8, 8, 8),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 1, 1, 1),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  child: Image.network(
                                                    'https://www.iconsdb.com/icons/preview/light-gray/plus-4-xxl.png',
                                                    width: 80,
                                                    height: 80,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(8, 2, 4, 0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Añadir otro software',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .title3
                                                                .override(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .title3Family),
                                                                ),
                                                      ),
                                                      FittedBox(
                                                        fit: BoxFit.scaleDown,
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          6,
                                                                          0,
                                                                          0,
                                                                          6),
                                                              child: Icon(
                                                                Icons.touch_app,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                size: 30,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          5,
                                                                          8,
                                                                          8,
                                                                          0),
                                                              child:
                                                                  AutoSizeText(
                                                                'Haz clic aquí',
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyText2
                                                                    .override(
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      useGoogleFonts: GoogleFonts
                                                                              .asMap()
                                                                          .containsKey(
                                                                              FlutterFlowTheme.of(context).bodyText2Family),
                                                                    ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 4, 0, 0),
                                                    child: Icon(
                                                      Icons
                                                          .chevron_right_rounded,
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
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                //segundo bloque

                if (idCategoria == 8)
                  Padding(
                      padding: defTamanoAnchoSecundario(
                          MediaQuery.of(context).size.width),
                      child: Container(
                        margin:
                            (MediaQuery.of(context).size.width < anchominimo)
                                ? EdgeInsets.fromLTRB(0, 15, 0, 0)
                                : EdgeInsets.all(10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius:
                              (MediaQuery.of(context).size.width < anchominimo)
                                  ? null
                                  : BorderRadius.circular(
                                      30), //border corner radius
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 5, 10, 5),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Hardware | Componentes externos',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText1
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyText1Family,
                                          fontSize: 24,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyText1Family),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            SingleChildScrollView(
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: listComponentesExActivos.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return _tarjetaComponenteExterno(
                                      listComponentesExActivos[index],
                                      listComponentesExActivos[index]
                                          .controlador);
                                },
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 25, 0, 12),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        final Activo? result =
                                            await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const ListaActivosPageWidget(
                                              idCategoria: 2,
                                              selectMode: false,
                                              esPrestamo: false,
                                              escogerComponente: true,
                                            ),
                                          ),
                                        );

                                        if (result != null) {
                                          Logger().i(
                                              'Activo devuelto:${result.nombre}');
                                          var contain = listComponentesExActivos
                                              .where((element) =>
                                                  element.idSerial ==
                                                  result.idSerial);
                                          if (contain.isEmpty) {
                                            setState(() {
                                              listComponentesExActivos
                                                  .add(result);
                                            });
                                          }
                                        }
                                      },
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            5, 5, 5, 5),
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 3,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .boxShadow,
                                                spreadRadius: 1,
                                              )
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                            ),
                                          ),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    8, 8, 8, 8),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 1, 1, 1),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    child: Image.network(
                                                      'https://www.iconsdb.com/icons/preview/light-gray/plus-4-xxl.png',
                                                      width: 80,
                                                      height: 80,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                8, 2, 4, 0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Añadir otro componente',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .title3
                                                              .override(
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                useGoogleFonts: GoogleFonts
                                                                        .asMap()
                                                                    .containsKey(
                                                                        FlutterFlowTheme.of(context)
                                                                            .title3Family),
                                                              ),
                                                        ),
                                                        FittedBox(
                                                          fit: BoxFit.scaleDown,
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            6,
                                                                            0,
                                                                            0,
                                                                            6),
                                                                child: Icon(
                                                                  Icons
                                                                      .touch_app,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  size: 30,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            5,
                                                                            8,
                                                                            8,
                                                                            0),
                                                                child:
                                                                    AutoSizeText(
                                                                  'Haz clic aquí para seleccionar',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyText2
                                                                      .override(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                        useGoogleFonts:
                                                                            GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyText2Family),
                                                                      ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0, 4, 0, 0),
                                                      child: Icon(
                                                        Icons
                                                            .chevron_right_rounded,
                                                        color:
                                                            Color(0xFF57636C),
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
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                //tercer bloque
                if (idCategoria == 8)
                  Padding(
                    padding: defTamanoAnchoSecundario(
                        MediaQuery.of(context).size.width),
                    child: Container(
                      margin: (MediaQuery.of(context).size.width < anchominimo)
                          ? EdgeInsets.fromLTRB(0, 15, 0, 0)
                          : EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: (MediaQuery.of(context).size.width <
                                anchominimo)
                            ? null
                            : BorderRadius.circular(30), //border corner radius
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 5, 10, 5),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Hardware | Componentes internos',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyText1
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyText1Family,
                                        fontSize: 24,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyText1Family),
                                      ),
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            physics: const NeverScrollableScrollPhysics(),
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: listComponentesInternos.length,
                              itemBuilder: (BuildContext context, int index) {
                                return _tarjetaComponenteInterno(
                                    listComponentesInternos[index]);
                              },
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 25, 0, 12),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        listComponentesInternos
                                            .add(ComponenteInterno());
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          5, 5, 5, 5),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 3,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .boxShadow,
                                              spreadRadius: 1,
                                            )
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                          ),
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  8, 8, 8, 8),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 1, 1, 1),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  child: Image.network(
                                                    'https://www.iconsdb.com/icons/preview/light-gray/plus-4-xxl.png',
                                                    width: 80,
                                                    height: 80,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(8, 2, 4, 0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Añadir otro componente',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .title3
                                                                .override(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .title3Family),
                                                                ),
                                                      ),
                                                      FittedBox(
                                                        fit: BoxFit.scaleDown,
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          6,
                                                                          0,
                                                                          0,
                                                                          6),
                                                              child: Icon(
                                                                Icons.touch_app,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                size: 30,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          5,
                                                                          8,
                                                                          8,
                                                                          0),
                                                              child:
                                                                  AutoSizeText(
                                                                'Haz clic aquí',
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyText2
                                                                    .override(
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      useGoogleFonts: GoogleFonts
                                                                              .asMap()
                                                                          .containsKey(
                                                                              FlutterFlowTheme.of(context).bodyText2Family),
                                                                    ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 4, 0, 0),
                                                    child: Icon(
                                                      Icons
                                                          .chevron_right_rounded,
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
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (blur)
            (guardadoExitosamente)
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 4,
                        sigmaY: 4,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          Align(
                            alignment: AlignmentDirectional(0, 0),
                            child: _cajaAdvertencia(context),
                            //. animateOnActionTrigger(animationsMap['cajaAdvertenciaOnActionTriggerAnimation']!,hasBeenTriggered: true),
                          ),
                        ],
                      ),
                    ),
                  )
                : ClipRRect(
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
                                color:
                                    FlutterFlowTheme.of(context).primaryColor,
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

  Widget _tarjetaComponenteExterno(
      Activo activo, TextEditingController controladorObservacion) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
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
                            activo.nombre,
                            overflow: TextOverflow.ellipsis,
                            style: FlutterFlowTheme.of(context).title3.override(
                                  fontFamily: 'Poppins',
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .title3Family),
                                ),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      6, 0, 0, 0),
                                  child: FaIcon(
                                    FontAwesomeIcons.barcode,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    size: 18,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      5, 3, 8, 1),
                                  child: AutoSizeText(
                                    'S/N: ${activo.idSerial}',
                                    textAlign: TextAlign.start,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText2
                                        .override(
                                          fontFamily: 'Poppins',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
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
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      3, 0, 0, 0),
                                  child: FaIcon(
                                    FontAwesomeIcons.boxOpen,
                                    color: Color(0xFFAD8762),
                                    size: 18,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      5, 3, 8, 1),
                                  child: AutoSizeText(
                                    'N° inventario: ${(activo.numActivo.isEmpty) ? 'No registrado' : activo.numActivo}',
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyText2
                                        .override(
                                          fontFamily: 'Poppins',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
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
                        child: IconButton(
                          icon: Icon(
                            Icons.cancel,
                            color: Color.fromARGB(255, 187, 26, 26),
                            size: 24,
                          ),
                          onPressed: () {
                            if (activoEditar != null) {
                              ComponenteExternoController()
                                  .eliminarbyidComponente(
                                      context,
                                      textControllerSerial.text,
                                      activo.idSerial);
                            }
                            setState(() {
                              listComponentesExActivos.remove(activo);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _tarjetaComponenteInterno(ComponenteInterno activo) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 0.0),
                child: Text(
                  activo.titulo,
                  style: FlutterFlowTheme.of(context).bodyText1.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).bodyText1Family,
                        fontSize: 20,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                            FlutterFlowTheme.of(context).bodyText1Family),
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: IconButton(
                    onPressed: () {
                      if (activo.id > 0) {
                        ComponenteInternoController()
                            .eliminarbyid(context, activo.id.toString());
                      }
                      setState(() {
                        listComponentesInternos.remove(activo);
                      });
                    },
                    icon: Icon(Icons.close)),
              )
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [imagenComponenteInterno(context, activo.urlImagen)],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.49,
                    child: Expanded(
                      child: TextFormFieldCustom(
                          context,
                          activo.nombreTextEditingController,
                          'Nombre Componente',
                          'Nombre Componente',
                          50,
                          TextInputType.name,
                          null,
                          false,
                          null,
                          activo.nombreFocus),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.49,
                    child: TextFormFieldCustom(
                        context,
                        activo.marcaTextEditingController,
                        'Marca',
                        'Marca',
                        20,
                        TextInputType.name,
                        null,
                        false,
                        null,
                        activo.marcaFocus),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.49,
                    child: TextFormFieldCustom(
                        context,
                        activo.velocidadTextEditingController,
                        'Velocidad',
                        'Velocidad',
                        20,
                        TextInputType.name,
                        null,
                        false,
                        null,
                        activo.velocidadFocus),
                  )
                ],
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.75,
                child: TextFormFieldCustom(
                    context,
                    activo.otrasCaracteristicasTextEditingController,
                    'Otras Caracteristicas',
                    'Otras Caracteristicas',
                    100,
                    TextInputType.name,
                    null,
                    false,
                    null,
                    activo.otrasCaracteristicasFocus),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _tarjetaSoftware(Software activo) {
    if (activoEditar != null) {
      dropDownvalueTipoLicencia = activo.tipoLicencia;
    }
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 0.0),
                child: Text(
                  activo.titulo,
                  style: FlutterFlowTheme.of(context).bodyText1.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).bodyText1Family,
                        fontSize: 20,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                            FlutterFlowTheme.of(context).bodyText1Family),
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: IconButton(
                    onPressed: () {
                      if (activo.id > 0) {
                        SoftwareController()
                            .eliminarbyid(context, activo.id.toString());
                      }
                      setState(() {
                        listSoftware.remove(activo);
                      });
                    },
                    icon: Icon(Icons.close)),
              )
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [imagenComponenteInterno(context, activo.urlImagen)],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.49,
                    child: TextFormFieldCustom(
                        context,
                        activo.nombreController,
                        'Nombre',
                        'Nombre',
                        50,
                        TextInputType.name,
                        null,
                        false,
                        null,
                        activo.nombreFocus),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.49,
                    child: TextFormFieldCustom(
                        context,
                        activo.fabricanteController,
                        'Fabricante',
                        'Fabricante',
                        20,
                        TextInputType.name,
                        null,
                        false,
                        null,
                        activo.fabricanteFocus),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      'Tipo de Licencia',
                      textAlign: TextAlign.start,
                      style: FlutterFlowTheme.of(context).bodyText1.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyText1Family,
                            fontSize: 17,
                            color: FlutterFlowTheme.of(context).grayicon,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context).bodyText1Family),
                          ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.49,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: AlignmentDirectional(0, 0),
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                              child: FlutterFlowDropDown<String>(
                                value: activo.dropdownvalue,
                                initialOption: 'Mono Usuario',
                                options: List.generate(
                                    listTipoLicencia.length,
                                    (index) => DropdownMenuItem(
                                        value: listTipoLicencia[index],
                                        child: Text(
                                          listTipoLicencia[index].toString(),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText1
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyText2Family,
                                                fontSize: 18,
                                                useGoogleFonts: GoogleFonts
                                                        .asMap()
                                                    .containsKey(
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyText1Family),
                                              ),
                                        ))),
                                onChanged: (val) => setState(() {
                                  activo.tipoLicencia = val!;
                                  activo.dropdownvalue = val;
                                }),
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
                                hintText: 'Tipo de licencia...',
                                fillColor: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                elevation: 2,
                                borderColor:
                                    FlutterFlowTheme.of(context).secondaryText,
                                borderWidth: 2,
                                borderRadius: 8,
                                margin: EdgeInsetsDirectional.fromSTEB(
                                    12, 4, 12, 4),
                                hidesUnderline: true,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: TextFormFieldCustom(
                    context,
                    activo.versionController,
                    'Versión',
                    'Versión',
                    100,
                    TextInputType.name,
                    null,
                    false,
                    null,
                    activo.versionFocus),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 20, 5),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 30, 16, 16),
                child: FaIcon(
                  FontAwesomeIcons.key,
                  color: FlutterFlowTheme.of(context).grayicon,
                  size: 25,
                ),
              ),
              Expanded(
                child: TextFormFieldCustom(
                    context,
                    activo.licenciaClaveController,
                    'Clave de activación',
                    'Clave de activación',
                    100,
                    TextInputType.name,
                    null,
                    false,
                    null,
                    activo.licenciaClaveFocus),
              ),
              FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 30,
                borderWidth: 1,
                buttonSize: 45,
                icon: Icon(
                  Icons.content_paste,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 30,
                ),
                onPressed: () {
                  Clipboard.getData(Clipboard.kTextPlain).then((value) {
                    if (value != null) {
                      if (value.text!.trim().isNotEmpty) {
                        activo.licenciaClaveController.text =
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
      _focusNode,
      {bool soloLectura = false}) {
    return TextFormField(
      readOnly: soloLectura,
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
          borderRadius: BorderRadius.only(
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

  Future<String> registrarActivo(
      ActivoController activoController,
      BuildContext context,
      String? imagenUrl,
      List<Software> listaSoftware,
      List<ComponenteExterno> listaComponenteExterno,
      List<ComponenteInterno> listaComponenteInterno,
      {bool editar = false}) async {
    // ignore: use_build_context_synchronously
    String res = await activoController.addActivo(
        context,
        textControllerSerial.text,
        textControllerN_inventario.text,
        textControllerNombre.text,
        textControllerDetalles!.text,
        imagenUrl,
        estadoActivoOpcion,
        dropDownValueCategoria.nombre,
        idCategoria,
        countControllerValue,
        null,
        null,
        editar: editar);

    if (res == 'ok' && idCategoria == 8) {
      if (listSoftware.isNotEmpty) {
        for (var element in listSoftware) {
          // ignore: use_build_context_synchronously
          await SoftwareController().registrarSoftware(
              context,
              textControllerSerial.text,
              element.nombre,
              element.fabricante,
              element.version,
              element.tipoLicencia,
              element.licenciaClave,
              element.urlImagen,
              editar: editar,
              id: element.id);
        }
      }

      

      if (listaComponenteExterno.isNotEmpty) {
        for (var element in listaComponenteExterno) {
          // ignore: use_build_context_synchronously
          await ComponenteExternoController().registrar(
              context, textControllerSerial.text, element.idComponente,
              editar: editar);
        }
      }

      if (listComponentesInternos.isNotEmpty) {
        for (var element in listaComponenteInterno) {
          // ignore: use_build_context_synchronously
          await ComponenteInternoController().registrar(
              context,
              textControllerSerial.text,
              element.urlImagen,
              element.nombre,
              element.marca,
              element.velocidad,
              element.otrasCaracteristicas,
              editar: editar,
              id: element.id);
        }
      }
    }
    return res;
  }

  Future<List<Categoria>> cargarCategorias() async {
    CategoriaController categoriaController = CategoriaController();
    listCategorias = await categoriaController.getCategoriasOrderById(null);
    for (var element in listCategorias) {
      print('Lista categoria nombre: + ${element.nombre}');
      print('Lista categoria url: ${element.urlImagen}');
    }
    if (listCategorias != null && listCategorias.length > 0) {
      for (var element in listCategorias) {
        if (element.nombre!.contains('Todos los activos')) {
          element.nombre = 'Todos los activos (Sin Categoria)';
        }
      }
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

  Widget _cajaAdvertencia(BuildContext contextPadre) {
    return Align(
      alignment: AlignmentDirectional(0, 0),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16, 24, 16, 5),
        child: Container(
          width: 450,
          constraints: BoxConstraints(
            maxWidth: 500,
            maxHeight: 300,
          ),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(contextPadre).secondaryBackground,
            boxShadow: [
              BoxShadow(
                blurRadius: 7,
                color: Color(0x4D000000),
                offset: Offset(0, 3),
              )
            ],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Text(
                    'Hoja de vida',
                    style: FlutterFlowTheme.of(contextPadre).title2.override(
                          fontFamily: 'Poppins',
                          color: FlutterFlowTheme.of(contextPadre).primaryText,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(contextPadre).title2Family),
                        ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Text(
                    '¿Desea generar la hoja de vida para este equipo de computo?',
                    style: FlutterFlowTheme.of(contextPadre).bodyText1.override(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(contextPadre)
                                  .bodyText1Family),
                        ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      Activo activo = Activo(
                        idSerial: textControllerSerial.text,
                        numActivo: textControllerN_inventario.text,
                        nombre: textControllerNombre.text,
                        detalles: textControllerDetalles!.text,
                        idCategoria: idCategoria,
                        categoria: dropDownValueCategoria.nombre!,
                      );
                      await PdfApi().generarHojadeVidaComputo(
                          activo,
                          listSoftware,
                          listComponentesExActivos,
                          listComponentesInternos);
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                    },
                    text: 'Si, generar Hoja de vida',
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 50,
                      color: FlutterFlowTheme.of(contextPadre).primaryColor,
                      textStyle: FlutterFlowTheme.of(contextPadre)
                          .subtitle2
                          .override(
                            fontFamily: 'Poppins',
                            color: FlutterFlowTheme.of(contextPadre).whiteColor,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(contextPadre)
                                    .subtitle2Family),
                          ),
                      elevation: 2,
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    showLoadingIndicator: false,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                      child: FFButtonWidget(
                        onPressed: () {
                          Navigator.of(contextPadre).pop();
                        },
                        text: 'No, gracias',
                        options: FFButtonOptions(
                          width: 170,
                          height: 50,
                          color: FlutterFlowTheme.of(contextPadre)
                              .primaryBackground,
                          textStyle: FlutterFlowTheme.of(contextPadre)
                              .subtitle2
                              .override(
                                fontFamily: 'Poppins',
                                color: FlutterFlowTheme.of(contextPadre)
                                    .primaryText,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(contextPadre)
                                        .subtitle2Family),
                              ),
                          elevation: 0,
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        showLoadingIndicator: false,
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
                shape: BoxShape.rectangle,
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

  Widget imagenComponenteInterno(BuildContext context, urlImagen) {
    return SizedBox(
        child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                shape: BoxShape.rectangle,
                image: DecorationImage(
                  fit: BoxFit.fitHeight,
                  image: NetworkImage(urlImagen),
                ))));
  }

  Widget _decideImageView(imageFile) {
    if (imageEdit != null && imageFile == null) {
      return Image.network(
        imageEdit!,
        width: 250,
        height: 200,
        fit: BoxFit.cover,
      );
    } else if (imageFile == null) {
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

  Future<void> _cargarCaetgoria(int idCategoria) async {
    Categoria? res;
    Logger().v('Cargando area...');
    res = await CategoriaController().buscarCategoriaID(idCategoria);
    Logger().v(res.nombre.toString());
    if (res != null && res.nombre!.isNotEmpty) {
      setState(() {
        dropDownValueCategoria = res!;
      });
    }
  }
}

EdgeInsetsGeometry defTamanoAncho(screenSize) {
  if (screenSize < 640) {
    return EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0);
  } else {
    return EdgeInsetsDirectional.fromSTEB(50, 50, 50, 10);
  }
}

EdgeInsetsGeometry defTamanoAnchoSecundario(screenSize) {
  if (screenSize < 640) {
    return EdgeInsetsDirectional.fromSTEB(0, 15, 0, 5);
  } else {
    return EdgeInsetsDirectional.fromSTEB(50, 25, 50, 15);
  }
}
