// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:app_gestion_prestamo_inventario/main.dart';
import 'package:app_gestion_prestamo_inventario/vistas/principal/principal_widget.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:image_picker/image_picker.dart';

import '../../entidades/activo.dart';
import '../../entidades/categoria.dart';
import '../../entidades/estadoActivo.dart';
import '../../servicios/activoController.dart';
import '../../servicios/categoriaController.dart';
import '../../servicios/storageController.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class RegistrarCategoriaPageWidget extends StatefulWidget {
  final Categoria? categoriaEditar;
  const RegistrarCategoriaPageWidget({Key? key, this.categoriaEditar})
      : super(key: key);

  @override
  _RegistrarCategoriaPageWidgetState createState() =>
      _RegistrarCategoriaPageWidgetState(categoriaEditar);
}

class _RegistrarCategoriaPageWidgetState
    extends State<RegistrarCategoriaPageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController textControllerNombre = TextEditingController();
  TextEditingController? textControllerDetalles = TextEditingController();
  TextEditingController? controladorimagenUrl = TextEditingController();

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
  int? numInventario;
  int estadoActivoOpcion = 0;
  Activo? activo;
  final Categoria? categoriaEditar;
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

  dynamic tamanio_padding = EdgeInsetsDirectional.fromSTEB(25, 15, 25, 15);

  _RegistrarCategoriaPageWidgetState(this.categoriaEditar);

  // ignore: prefer_final_fields5

  @override
  void initState() {
    super.initState();
    if (categoriaEditar != null) {
      textControllerNombre.text = categoriaEditar!.nombre.toString();
      urlImagen = categoriaEditar!.urlImagen.toString();
      textControllerDetalles!.text = categoriaEditar!.descripcion.toString();
    } else {}
  }

  @override
  void dispose() {
    textControllerNombre.dispose();
    textControllerDetalles?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            if (_formKey.currentState!.validate()) {
              _loading = true;
              String imagenUrl =
                  'https://www.giulianisgrupo.com/wp-content/uploads/2018/05/nodisponible.png';
              ;
              if (imageFile != null) {
                StorageController storageController = StorageController();
                imagenUrl = await storageController.subirImagen(
                    context,
                    imageFile?.path.toString(),
                    imageFile!,
                    textControllerNombre.text,
                    'categorias');
                if (imagenUrl.contains('https')) {
                  CategoriaController categoriaController =
                      CategoriaController();
                  if (categoriaEditar != null) {
                    await registrarCategoria(
                        categoriaController,
                        context,
                        textControllerNombre.text,
                        imagenUrl,
                        textControllerDetalles!.text,
                        editar: true,
                        idCategoria: categoriaEditar!.id);
                    
                   Timer(Duration(seconds: 3), () {
                    Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyApp(),
                    ),
                  );
                  });
                  } else {
                    await registrarCategoria(
                        categoriaController,
                        context,
                        textControllerNombre.text,
                        imagenUrl,
                        textControllerDetalles!.text);
                         Timer(Duration(seconds: 3), () {
                    Navigator.pop(context);
                  });
                  }

                 
                }
              } else {
                CategoriaController categoriaController = CategoriaController();
                if (categoriaEditar != null) {
                  await registrarCategoria(
                      categoriaController,
                      context,
                      textControllerNombre.text,
                      categoriaEditar!.urlImagen.toString(),
                      textControllerDetalles!.text,
                      idCategoria: categoriaEditar!.id);
                      Timer(Duration(seconds: 3), () {
                    Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyApp(),
                    ),
                  );
                  });
                } else {
                  await registrarCategoria(
                      categoriaController,
                      context,
                      textControllerNombre.text,
                      'https://www.giulianisgrupo.com/wp-content/uploads/2018/05/nodisponible.png',
                      textControllerDetalles!.text);
                        Timer(Duration(seconds: 3), () {
                  Navigator.pop(context);
                });
                }

              
              }
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
        actions: [
          if (categoriaEditar != null)
            FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 30,
                borderWidth: 1,
                buttonSize: 60,
                icon: const FaIcon(
                  Icons.delete_forever_outlined,
                  color: Colors.red,
                  size: 30,
                ),
                onPressed: () async {
                  await CategoriaController()
                      .eliminar(context, categoriaEditar!.id.toString());
                  Timer(Duration(seconds: 3), () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyApp(),
                    ),
                  );
                });
                  
                }),
        ],
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
          'Registrar categoria',
          textAlign: TextAlign.start,
          style: FlutterFlowTheme.of(context).title1.override(
                fontFamily: FlutterFlowTheme.of(context).title1Family,
                color: FlutterFlowTheme.of(context).whiteColor,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).subtitle1Family),
              ),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(10, 18, 10, 16),
        child: Container(
          alignment: Alignment.topCenter,
          margin: null,
          height: 1000,
          width: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(30), //border corner radius
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
              padding: EdgeInsets.all(0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: tamanio_padding,
                              child: TextFormFieldCustom(
                                  context,
                                  textControllerNombre,
                                  'Impresoras',
                                  'Nombre*',
                                  30,
                                  TextInputType.text,
                                  null,
                                  true,
                                  null,
                                  _focusNodeNombre),
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
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                child: Text(
                                  'Toca en la camara para subir una imagen',
                                  style: FlutterFlowTheme.of(context).title3,
                                ),
                              ),
                              Container(
                                width: (Platform.isAndroid || Platform.isIOS)
                                    ? MediaQuery.of(context).size.width * 0.9
                                    : MediaQuery.of(context).size.width * 0.6,
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 16, 0, 14),
                                    child: Center(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: imagenPerfil(
                                            context, urlImagen, imageFile),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                width: (Platform.isAndroid || Platform.isIOS)
                                    ? MediaQuery.of(context).size.width * 0.9
                                    : MediaQuery.of(context).size.width * 0.9,
                                child: Align(
                                  alignment: AlignmentDirectional(0.05, 0),
                                  child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 30, 0, 0),
                                      child: TextFormFieldCustom(
                                          context,
                                          textControllerDetalles,
                                          'Ej.Impresoras laser y de inyencción de tinta multifuncionales',
                                          'Descripción',
                                          90,
                                          TextInputType.multiline,
                                          null,
                                          true,
                                          null,
                                          _focusNodeDetalles)),
                                ),
                              ),
                            ],
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

  Future<void> registrarCategoria(CategoriaController activoCategoria,
      BuildContext context, String nombre, String imagenUrl, String descripcion,
      {bool editar = false, int idCategoria = 0}) async {
    await activoCategoria.addCategoria(context, nombre, imagenUrl, descripcion,
        idCategoria: idCategoria);
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
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 90);
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

  Widget _decideImageView(imageFile) {
    if (categoriaEditar != null && imageFile == null) {
      return Image.network(
        categoriaEditar!.urlImagen.toString(),
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
}
