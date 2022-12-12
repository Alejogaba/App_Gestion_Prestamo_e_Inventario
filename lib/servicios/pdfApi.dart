import 'dart:developer';
import 'dart:io';
import 'package:app_gestion_prestamo_inventario/entidades/activo.dart';
import 'package:app_gestion_prestamo_inventario/flutter_flow/flutter_flow_util.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class PdfApi {
  static Future<void> generarTablaActivo(List<Activo> listaActivo) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        SizedBox(height: 0.1 * PdfPageFormat.cm),
        buildTitle("Reporte de activos", 24, FontWeight.bold),
        buildTitle(
            "Fecha y hora en que se genero este reporte: " +
                DateFormat.yMd().add_jm().format(DateTime.now()),
            15.5,
            FontWeight.normal),
        buildTableActivo(listaActivo),
      ],
    ));

    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      saveDocumentDesktop(name: 'reporte', pdf: pdf);
    }else{
      saveDocumentMobile(name: 'Reporte de activos.pdf', pdf: pdf);
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
    final headers = ['Número Serial', 'Número de activo', 'Activo'];

    final data = listaActivo
        .map((activo) => [
              activo.idSerial,
              (activo.numActivo!.isEmpty || activo.numActivo == null)
                  ? 'No registrado'
                  : activo.numActivo,
              activo.nombre
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
        2: Alignment.centerRight,
      },
    );
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

   
  static Future<void> saveDocumentMobile({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getExternalStorageDirectory();
    final file = File('${dir!.path}/$name');

    await file.writeAsBytes(bytes);

    final Uri uri = Uri.file(file.path);

      if (!File(uri.toFilePath()).existsSync()) {
        throw '$uri does not exist!';
      }
      if (!await launchUrl(uri)) {
        throw 'Could not launch $uri';
      }
    }
  

  
  static Future<void> saveDocumentDesktop({
    String? name,
    Document? pdf,
  }) async {
    String? pickedFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Seleccione a ruta donde desea guardar el archivo:',
        fileName: 'Reporte de activos.pdf',
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
    }
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
}
