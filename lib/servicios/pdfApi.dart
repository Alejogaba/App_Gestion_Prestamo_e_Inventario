import 'dart:developer';
import 'dart:io';
import 'package:app_gestion_prestamo_inventario/assets/utilidades.dart';
import 'package:app_gestion_prestamo_inventario/entidades/activo.dart';
import 'package:app_gestion_prestamo_inventario/flutter_flow/flutter_flow_util.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_filex/open_filex.dart' as OpenFile;
import 'package:pdf_image_renderer/pdf_image_renderer.dart' as pdfRender;
import 'package:pdf/widgets.dart' as pw;

import '../entidades/area.dart';
import '../entidades/funcionario.dart';
import 'funcionariosController.dart';

class PdfApi {
  final PdfColor baseColor = PdfColor.fromHex('000000');
  final PdfColor accentColor = PdfColor.fromHex('1b800b');
  final PdfColor _accentTextColor = PdfColor.fromHex('000000');
  Uint8List? _logo1;
  Uint8List? _logo2;

  Future<void> generarTablaActivo(List<Activo> listaActivo,
      {String tipoActivo = ''}) async {
    final pdf = Document();
    tipoActivo = ' - $tipoActivo';
      
    

    pdf.addPage(MultiPage(
      build: (context) => [
        SizedBox(height: 0.1 * PdfPageFormat.cm),
        buildTextJustificado(
            "Reporte de activos$tipoActivo", 24, FontWeight.bold),
        buildTitle(
            "Fecha y hora en que se genero este reporte: " +
                DateFormat.yMd().add_jm().format(DateTime.now()),
            15.5,
            FontWeight.normal),
        buildTableActivo(listaActivo),
      ],
    ));

    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      saveDocumentDesktop(name: 'reporte de activos.pdf', pdf: pdf);
    } else {
      saveDocumentMobile(name: 'Reporte de activos.pdf', pdf: pdf);
    }
  }

  Future<bool> generarHojaSalida(
      List<Activo> listaActivo, Funcionario funcionario,
      {String numConsecutivo = 'GTI - 000'}) async {
    final pdf = Document();
    double separacionAltura = (listaActivo.length > 3) ? 0.5 : 1;
    String funcionarioArea = await cargarArea(funcionario.idArea);

    _logo1 = (await rootBundle.load('assets/images/logo-jagua-1.jpg'))
        .buffer
        .asUint8List();
    _logo2 = (await rootBundle.load('assets/images/logo-jagua-2.jpg'))
        .buffer
        .asUint8List();
    pdf.addPage(MultiPage(
      header: _buildHeader,
      footer: _buildFooter,
      margin: EdgeInsets.only(
          left: 2.5 * PdfPageFormat.cm,
          right: 2.5 * PdfPageFormat.cm,
          bottom: 0.6 * PdfPageFormat.cm,
          top: 0.6 * PdfPageFormat.cm),
      pageFormat: PdfPageFormat.letter,
      build: (context) => [
        SizedBox(height: separacionAltura * PdfPageFormat.cm),
        buildTextJustificado(
            "La Jagua de Ibirico, ${_formatDate(DateTime.now())}",
            11,
            FontWeight.normal),
        SizedBox(height: separacionAltura * PdfPageFormat.cm),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          pw.Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            buildTextJustificado("Señor", 11, FontWeight.bold),
            Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border(
                  left:
                      BorderSide(width: 0.5, color: PdfColor.fromHex("000000")),
                  right:
                      BorderSide(width: 0.5, color: PdfColor.fromHex("000000")),
                  top:
                      BorderSide(width: 0.5, color: PdfColor.fromHex("000000")),
                  bottom:
                      BorderSide(width: 0.5, color: PdfColor.fromHex("000000")),
                )),
                child: Column(children: [
                  Text('Consecutivo:          ',
                      style:
                          TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left),
                  Text(numConsecutivo,
                      style: TextStyle(
                          fontSize: 11, fontWeight: FontWeight.normal),
                      textAlign: TextAlign.center),
                ]))
          ]),
          buildTextJustificado(
              "_________________________________", 11, FontWeight.bold),
          buildTextJustificado("Celador - Vigilante ", 11, FontWeight.bold),
          buildTextJustificado(
              "Centro Administrativo Municipal - CAM", 11, FontWeight.bold),
          buildTextJustificado(
              "La Jagua de Ibirico, Cesar", 11, FontWeight.bold),
        ]),
        SizedBox(height: separacionAltura * PdfPageFormat.cm),
        buildTextJustificado(
            "REF: SALIDA DE EQUIPOS TECNOLOGICOS.", 11, FontWeight.bold),
        SizedBox(height: separacionAltura * PdfPageFormat.cm),
        buildTextJustificado(
            "Mediante la presente se le informa la autorización para la salida de los equipos a continuación:",
            12,
            FontWeight.normal),
        SizedBox(height: separacionAltura * PdfPageFormat.cm),
        buildTableActivoPrestamo(listaActivo, funcionarioArea),
        SizedBox(height: 0.5 * PdfPageFormat.cm),
        buildTableObservacion('Esta es una observacion'),
        SizedBox(height: 0.5 * PdfPageFormat.cm),
        buildTextJustificado("Cordialmente.", 11, FontWeight.normal),
        SizedBox(height: 2 * PdfPageFormat.cm),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          buildTextJustificado(
              "_________________________________", 11, FontWeight.bold),
          buildTextJustificado(
              "ALBA PATRICIA AMADOR OROZCO", 11, FontWeight.bold),
          buildTextJustificado("Jefe oficina de las TIC", 8, FontWeight.bold),
        ]),
      ],
    ));

    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      bool res =
          await saveDocumentDesktop(name: 'Salida de activos.pdf', pdf: pdf);
      return res;
    } else {
      saveDocumentMobile(name: 'Salida de activos.pdf', pdf: pdf);
      return false;
    }
  }

  static buildText({
    String title = '',
    String value = '',
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) async {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }

  static Widget buildTableActivo(List<Activo> listaActivo) {
    final headers = [
      'Marca',
      'Activo',
      'Número de serial',
      'Número de activo',
      'Estado'
    ];

    final data = listaActivo
        .map((activo) => [
              activo.detalles,
              activo.nombre,
              activo.idSerial,
              (activo.numActivo!.isEmpty || activo.numActivo == null)
                  ? 'Nulo'
                  : activo.numActivo,
              definirEstadoActivo(activo.estado)
            ])
        .toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.center,
        2: Alignment.center,
        3: Alignment.center,
        4: Alignment.centerRight,
      },
    );
  }

  static Widget buildTableActivoPrestamo(
      List<Activo> listaActivo, String funcionarioArea) {
    final headers = [
      'Item',
      'Descripción Dispositivo',
      'Marca',
      '# activo',
      'S/N',
      'Dependencia'
    ];

    int count = 0;

    listaActivo.forEach((element) {
      count++;
      element.cantidad = count;
    });

    final data = listaActivo
        .map((activo) => [
              activo.cantidad,
              activo.nombre,
              activo.detalles,
              (activo.numActivo!.isEmpty || activo.numActivo == null)
                  ? '  '
                  : activo.numActivo,
              activo.idSerial,
              funcionarioArea
            ])
        .toList();

    return Table.fromTextArray(
        headers: headers,
        data: data,
        border: const TableBorder(
            left: BorderSide(width: 0.6),
            right: BorderSide(width: 0.6),
            top: BorderSide(width: 0.6),
            bottom: BorderSide(width: 0.6),
            horizontalInside: BorderSide(width: 0.6),
            verticalInside: BorderSide(width: 0.6)),
        headerStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        headerDecoration: const BoxDecoration(color: PdfColors.grey300),
        headerAlignment: Alignment.center,
        cellHeight: 20,
        cellAlignment: Alignment.center,
        columnWidths: {
          0: FixedColumnWidth(35.0),
          1: FlexColumnWidth(),
          2: FlexColumnWidth(),
          3: FixedColumnWidth(45.0),
          4: FlexColumnWidth(),
          5: FixedColumnWidth(100.0),
        });
  }

  static Widget buildTableObservacion(String observacion) {
    List<String> products = ['Observaciones: ', observacion];
    return Table.fromTextArray(
        headers: null,
        data: List<List<String>>.generate(1, (row) => products),
        border: const TableBorder(
            left: BorderSide(width: 0.6),
            right: BorderSide(width: 0.6),
            top: BorderSide(width: 0.6),
            bottom: BorderSide(width: 0.6),
            horizontalInside: BorderSide(width: 0.6),
            verticalInside: BorderSide(width: 0.6)),
        headerStyle: TextStyle(
          fontWeight: FontWeight.normal,
        ),
        headerAlignment: Alignment.center,
        cellHeight: 30,
        cellAlignment: Alignment.center,
        columnWidths: {
          0: FixedColumnWidth(150),
          1: FlexColumnWidth(),
        });
  }

  static Widget buildTitle(String texto, double tamano, FontWeight fuente) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            texto,
            style: TextStyle(fontSize: tamano, fontWeight: fuente),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildTextJustificado(
          String texto, double tamano, FontWeight fuente) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(texto,
              style: TextStyle(fontSize: tamano, fontWeight: fuente),
              textAlign: TextAlign.justify),
        ],
      );

  static Future<void> saveDocumentMobile({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getExternalStorageDirectory();
    final File file = File('${dir!.path}/$name');

    await file.writeAsBytes(bytes);

    final Uri uri = Uri.file(file.path);

    if (!File(uri.toFilePath()).existsSync()) {
      log('abrir archivo 1');
    }
    //if (!await launchUrl(uri)) {
    //  log('abrir archivo 2');}
    final result = await OpenFile.OpenFilex.open(file.path);
    var _openResult = 'Desconocido';
    _openResult = "type=${result.type}  message=${result.message}";
    log('Resultado OpenResult: $_openResult');
  }

  static Future<bool> saveDocumentDesktop({
    String? name,
    Document? pdf,
  }) async {
    String? pickedFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Seleccione a ruta donde desea guardar el archivo:',
        fileName: name,
        type: FileType.custom,
        allowedExtensions: ['pdf']);

    if (pickedFile != null) {
      String extension = pickedFile.split('.').last;
      if (extension != 'pdf') {
        pickedFile = '$pickedFile.pdf';
      }
      File imagefile = File(pickedFile);
      log('ruta archivo: ${imagefile.path}');
      final bytes = await pdf!.save();

      final file = File(imagefile.path);

      await file.writeAsBytes(bytes);

      final Uri uri = Uri.file(imagefile.path);

      if (!File(uri.toFilePath()).existsSync()) {
        throw '$uri does not exist!';
      }
      if (!await launchUrl(uri)) {
        throw 'Could not launch $uri';
      }
      return true;
    } else {
      return false;
    }
  }

  static Future<File> getFileFromAssets(String filename) async {
    assert(filename != null);
    final byteData = await rootBundle.load(filename);
    var name = filename.split(Platform.pathSeparator).last;
    var absoluteName = '${(await getLibraryDirectory()).path}/$name';
    final file = File(absoluteName);

    await file.writeAsBytes(byteData.buffer.asUint8List());

    return file;
  }

  static Future<File?> pickFile() async {
    String? pickedFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Please select an output file:',
        fileName: 'Reporte de activos.pdf',
        type: FileType.custom,
        allowedExtensions: ['pdf']);
    if (pickedFile != null) {
      File imagefile = File(pickedFile);
      log('ruta archivo: ${imagefile.path}');
      return imagefile;
    } else {
      return null;
      // User canceled the picker
    }
  }

/*
  static Future openFilePersonal(String nombreArchivo) async {
    final dir = await getExternalStorageDirectory();
    final url = dir!.path+'/'+nombreArchivo;

    await OpenFile.open(url);
  }

*/

  static String definirEstadoActivo(int? estado) {
    switch (estado) {
      case 0:
        return 'Bueno';

      case 1:
        return 'Regular';

      case 2:
        return 'Malo';

      default:
        return 'No definido';
    }
  }

  pw.Widget _buildHeader(pw.Context context) {
    return pw.Column(
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                children: [
                  pw.Container(
                    alignment: pw.Alignment.topLeft,
                    padding: const pw.EdgeInsets.only(bottom: 0),
                    height: 72,
                    child: _logo1 != null
                        ? pw.Image(MemoryImage(_logo1!))
                        : pw.PdfLogo(),
                  ),
                ],
              ),
            ),
            pw.Expanded(
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.Container(
                    height: 15,
                    padding: const pw.EdgeInsets.only(left: 20),
                    alignment: pw.Alignment.bottomRight,
                    child: pw.Text(
                      'Código: CRI - SGC - 001',
                      style: pw.TextStyle(
                        color: baseColor,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 8,
                      ),
                    ),
                  ),
                  pw.Container(
                    height: 15,
                    padding: const pw.EdgeInsets.only(left: 20),
                    alignment: pw.Alignment.bottomRight,
                    child: pw.Text(
                      'Versión: 4 / 04-01-2016',
                      style: pw.TextStyle(
                        color: baseColor,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (context.pageNumber > 1) pw.SizedBox(height: 20)
      ],
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    double altura = 10;
    return pw.Column(
      children: [
        pw.Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Center(
                child: Text('- ${context.pageNumber} -',
                    style: TextStyle(fontSize: 11),
                    textAlign: TextAlign.center),
              )
            ]),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.Container(
                    height: 20,
                    padding: const pw.EdgeInsets.only(),
                    alignment: pw.Alignment.bottomLeft,
                    child: pw.Text(
                      ' ',
                      style: pw.TextStyle(
                        color: baseColor,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  pw.Container(
                    height: altura,
                    padding: const pw.EdgeInsets.only(),
                    alignment: pw.Alignment.bottomLeft,
                    child: pw.Text(
                      'EL PUEBLO PRIMERO',
                      style: pw.TextStyle(
                        color: baseColor,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  pw.Container(
                    height: altura,
                    padding: const pw.EdgeInsets.only(),
                    alignment: pw.Alignment.bottomLeft,
                    child: pw.Text(
                      'Página Web: www.lajaguaibirico-cesar.gov.co',
                      style: pw.TextStyle(
                        color: baseColor,
                        fontWeight: pw.FontWeight.normal,
                        fontSize: 8,
                      ),
                    ),
                  ),
                  pw.Container(
                    height: altura,
                    padding: const pw.EdgeInsets.only(),
                    alignment: pw.Alignment.bottomLeft,
                    child: pw.Text(
                      'Correo Institucional: alcaldía@lajaguadeibirico-cesar.gov.co',
                      style: pw.TextStyle(
                        color: baseColor,
                        fontWeight: pw.FontWeight.normal,
                        fontSize: 8,
                      ),
                    ),
                  ),
                  pw.Container(
                    height: altura,
                    padding: const pw.EdgeInsets.only(),
                    alignment: pw.Alignment.bottomLeft,
                    child: pw.Text(
                      'Teléfono (095)5769206 - Fax (095) 5769024',
                      style: pw.TextStyle(
                        color: baseColor,
                        fontWeight: pw.FontWeight.normal,
                        fontSize: 8,
                      ),
                    ),
                  ),
                  pw.Container(
                    height: altura,
                    padding: const pw.EdgeInsets.only(),
                    alignment: pw.Alignment.bottomLeft,
                    child: pw.Text(
                      'Calle 6 No. 3ª - 23 ',
                      style: pw.TextStyle(
                        color: baseColor,
                        fontWeight: pw.FontWeight.normal,
                        fontSize: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            pw.Expanded(
              child: pw.Column(
                children: [
                  pw.Container(
                    alignment: pw.Alignment.topRight,
                    padding: const pw.EdgeInsets.only(bottom: 0),
                    height: 72,
                    child: _logo2 != null
                        ? pw.Image(MemoryImage(_logo2!))
                        : pw.PdfLogo(),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (context.pageNumber > 1) pw.SizedBox(height: 20)
      ],
    );
  }

  String _formatDate(DateTime date) {
    final format = DateFormat.yMMMMEEEEd('es_CO');
    return format.format(date);
  }

  Future<String> cargarArea(id) async {
    FuncionariosController funcionariosController = FuncionariosController();
    Area area = await funcionariosController.buscarArea(id.toString());
    return area.nombre;
  }
}
