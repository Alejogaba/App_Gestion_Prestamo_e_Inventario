import 'dart:developer';
import 'dart:io';
import 'package:app_gestion_prestamo_inventario/assets/utilidades.dart';
import 'package:app_gestion_prestamo_inventario/entidades/activo.dart';
import 'package:app_gestion_prestamo_inventario/entidades/componenteExterno.dart';
import 'package:app_gestion_prestamo_inventario/flutter_flow/flutter_flow_util.dart';
import 'package:app_gestion_prestamo_inventario/servicios/activoController.dart';
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

import '../entidades/activo_funcionario.dart';
import '../entidades/area.dart';
import '../entidades/componenteInterno.dart';
import '../entidades/funcionario.dart';
import '../entidades/software.dart';
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
        buildTextLeft(
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
      List<Activo> listaActivo, Funcionario funcionario, String observacion,
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
      margin: const EdgeInsets.only(
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
                padding: const EdgeInsets.all(10),
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
        buildTableObservacion(observacion),
        SizedBox(height: 0.5 * PdfPageFormat.cm),
        buildTextJustificado("Cordialmente.", 11, FontWeight.normal),
        SizedBox(height: 2 * PdfPageFormat.cm),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          buildTextJustificado(
              "_________________________________", 11, FontWeight.bold),
          buildTextJustificado(
              "ALBA PATRICIA AMADOR OROZCO", 11, FontWeight.bold),
          buildTextJustificado(
              "Jefe oficina de las Tic", 11, FontWeight.bold),
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

  Future<bool> generarHojadeVidaComputo(
    Activo activo,
    List<Software> listaSoftware,
    List<Activo> listaComponenteExterno,
    List<ComponenteInterno> listaComponenteInterno,
  ) async {
    Funcionario funcionario = Funcionario(tieneActivos: true);
    Area area = Area();
    double tamanioTextNormal1raHoja = 8;
    if (activo.estaAsignado) {
      List<ActivoFuncionario> activoFuncionarios =
          await ActivoController().getFuncionarioAsignado(activo.idSerial);
      if (activoFuncionarios.isNotEmpty) {
        for (var element in activoFuncionarios) {
          funcionario = await FuncionariosController()
              .buscarFuncionarioIndividual(element.idFuncionaro);
        }
        area = await FuncionariosController()
            .buscarArea(funcionario.idArea.toString());
      }
    }
    final pdf = Document();
    double separacionAltura = (listaComponenteExterno.length > 3) ? 0.5 : 1;
    _logo1 = (await rootBundle.load('assets/images/logo-jagua-1.jpg'))
        .buffer
        .asUint8List();
    _logo2 = (await rootBundle.load('assets/images/logo-jagua-2.jpg'))
        .buffer
        .asUint8List();
    /* 
    pdf.addPage(MultiPage(
      header: _buildHeader,
      footer: _buildFooter,
      margin: const EdgeInsets.only(
          left: 2.5 * PdfPageFormat.cm,
          right: 2.5 * PdfPageFormat.cm,
          bottom: 0.6 * PdfPageFormat.cm,
          top: 0.6 * PdfPageFormat.cm),
      pageFormat: PdfPageFormat.letter,
      build: (context) => [
        SizedBox(height: separacionAltura * PdfPageFormat.cm),
        pw.Center(
          child: buildTextCentrado(
              "HOJA DE VIDA DE EQUIPO DE COMPUTO", 16, FontWeight.bold),
        ),
        SizedBox(height: separacionAltura * PdfPageFormat.cm),
        SizedBox(height: separacionAltura * PdfPageFormat.cm),
        SizedBox(height: 0.3 * PdfPageFormat.cm),
        buildTextJustificado("3.Limpieza Física", tamanioTextNormal1raHoja,FontWeight.bold),
        Padding(padding: EdgeInsets.only(right: 150),
        child: cuadrosLimpieza('Limpieza exterior', 'Verificar estado del tóner')),
        Padding(padding: EdgeInsets.only(right: 150),
        child: cuadrosLimpieza('Verificar Conexión de red', 'Verificar estado del fusor')),
        Padding(padding: EdgeInsets.only(right: 177),
        child: cuadrosLimpieza('Verificar Conexión electrica', 'Recarga de tóner')),
        SizedBox(height: 0.2 * PdfPageFormat.cm),
        Padding(padding: EdgeInsets.only(right: 0),
        child: cuadrosLimpieza('Otros          __________________________________________________________', '')),
        SizedBox(height: 0.3 * PdfPageFormat.cm),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          buildTextJustificado(
              'Marca      ', tamanioTextNormal1raHoja, FontWeight.normal),
          buildTextJustificado(
              (activo.marca.isEmpty) ? '__________________' : '     ${activo.marca}',
              tamanioTextNormal1raHoja,
              FontWeight.normal),
          buildTextJustificado('        Serial      ', tamanioTextNormal1raHoja,
              FontWeight.normal),
          buildTextJustificado(
              (activo.idSerial.isEmpty)
                  ? '___________________'
                  : '     ${activo.idSerial}',
              tamanioTextNormal1raHoja,
              FontWeight.normal),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          buildTextJustificado(
              'Modelo      ', tamanioTextNormal1raHoja, FontWeight.normal),
          buildTextJustificado(
              (activo.nombre.isEmpty)
                  ? '___________________'
                  : '     ${activo.nombre}',
              tamanioTextNormal1raHoja,
              FontWeight.normal),
          buildTextJustificado('        Placa      ', tamanioTextNormal1raHoja,
              FontWeight.normal),
          buildTextJustificado(
              (activo.numActivo.isEmpty)
                  ? '___________________'
                  : '     ${activo.numActivo}',
              tamanioTextNormal1raHoja,
              FontWeight.normal),
        ]),
        SizedBox(height: 0.3 * PdfPageFormat.cm),
        buildTextJustificado("4. Actividades finales", tamanioTextNormal1raHoja,
            FontWeight.bold),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          buildCuadroVacio(),
          buildTextJustificado(
              ' Entrega del equipo al usuario', 7, FontWeight.normal)
        ]),
        SizedBox(height: 0.3 * PdfPageFormat.cm),
        buildTextJustificado(
            "5. Encuesta", tamanioTextNormal1raHoja, FontWeight.bold),
        buildTextJustificado(
            "5.1 ¿Cúal es su nivel de satisfación del servicio",
            tamanioTextNormal1raHoja,
            FontWeight.normal),
        pw.Padding(
            padding: EdgeInsets.only(right: 150), child: cuadrosSatisfaccion()),
        SizedBox(height: 0.3 * PdfPageFormat.cm),
        buildTextJustificado(
            "5.2 ¿Como califica la atención brindada por el soporte?",
            tamanioTextNormal1raHoja,
            FontWeight.normal),
        pw.Padding(
            padding: EdgeInsets.only(right: 150), child: cuadrosBuenoMalo()),
        SizedBox(height: 0.3 * PdfPageFormat.cm),
        buildTextJustificado(
            "5.3 ¿Cúal es su percepción sobre la capacitación del personal que realizo las actividades de mantenimiento?",
            tamanioTextNormal1raHoja,
            FontWeight.normal),
        pw.Padding(
            padding: EdgeInsets.only(right: 150), child: cuadrosBuenoMalo()),
        SizedBox(height: 0.3 * PdfPageFormat.cm),
        buildTextJustificado(
            "Observación: _______________________________________________________________________________________________________________________________________________________________________________________________________________________________________",
            tamanioTextNormal1raHoja,
            FontWeight.normal),
        SizedBox(height: 0.3 * PdfPageFormat.cm),
        pw.Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                buildTextJustificado(
                    "_________________________________", 10, FontWeight.bold),
                buildTextJustificado(
                    "Firma de Personal Técnico", 10, FontWeight.bold),
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                buildTextJustificado(
                    "_________________________________", 10, FontWeight.bold),
                buildTextJustificado(
                    "Firma y nombre de usuario", 10, FontWeight.bold),
              ]),
            ]),
        SizedBox(height: 0.5 * PdfPageFormat.cm),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          buildTextJustificado("Proyectó:                  Alba Amador Orozco",
              6, FontWeight.bold),
          buildTextJustificado(
              "                                   Jefe Oficina de las TIC",
              6,
              FontWeight.normal),
          SizedBox(height: 0.2 * PdfPageFormat.cm),
          buildTextJustificado(
              "Revisó:                      Alba Amador Orozco",
              6,
              FontWeight.bold),
          buildTextJustificado(
              "                                   Jefe Oficina de las TIC",
              6,
              FontWeight.normal),
        ]),
      ],
    ));*/
    pdf.addPage(MultiPage(
      header: _buildHeader,
      footer: _buildFooter,
      margin: const EdgeInsets.only(
          left: 2.5 * PdfPageFormat.cm,
          right: 2.5 * PdfPageFormat.cm,
          bottom: 0.6 * PdfPageFormat.cm,
          top: 0.6 * PdfPageFormat.cm),
      pageFormat: PdfPageFormat.letter.landscape,
      build: (context) => [
        SizedBox(height: separacionAltura * PdfPageFormat.cm),
        pw.Center(
          child: buildTextCentrado(
              "HOJA DE VIDA DE SOFTWARE", 16, FontWeight.bold),
        ),
        SizedBox(height: separacionAltura * PdfPageFormat.cm),
        buildTableAreaTematica(),
        buildTableIdentificacionInstitucional(),
        buildTable4Columnas([
          'ÁREA ASIGNADA:',
          funcionario.cargo,
          'USUARIO RESPONSABLE:',
          '${funcionario.nombres} ${funcionario.apellidos}'
        ]),
        SizedBox(height: 0.3 * PdfPageFormat.cm),
        buildTableInfoEquipoTtulo(),
        buildTable4Columnas([
          'NOMBRE USUARIO RESPONSABLE',
          '${funcionario.nombres} ${funcionario.apellidos}',
          'DOMINIO O GRUPO DE TRABAJO',
          ''
        ]),
        buildTable4Columnas([
          'CARGO USUARIO RESPONSABLE',
          funcionario.cargo,
          'FECHA ASIGNACIÓN',
          DateFormat.yMMMMd('es_US').format(DateTime.now())
        ]),
        buildTable4Columnas([
          'NOMBRE USUARIO DEL EQUIPO',
          '',
          'BÚZON CORREO INTERNO',
          (funcionario.correo != null) ? funcionario.correo! : '',
        ]),
        SizedBox(height: 0.3 * PdfPageFormat.cm),
        buildTableInfoEquipoTtulo(),
        buildTableInfoEquipo(activo),
        SizedBox(height: 0.3 * PdfPageFormat.cm),
        buildTableSoftware(listaSoftware),
        SizedBox(height: 0.3 * PdfPageFormat.cm),
        buildTableFirma(),
        SizedBox(height: 0.5 * PdfPageFormat.cm),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          buildTextJustificado("Proyectó:                  Alba Amador Orozco",
              6, FontWeight.bold),
          buildTextJustificado(
              "                                   Jefe Oficina de las TIC",
              6,
              FontWeight.normal),
          SizedBox(height: 0.2 * PdfPageFormat.cm),
          buildTextJustificado(
              "Revisó:                      Alba Amador Orozco",
              6,
              FontWeight.bold),
          buildTextJustificado(
              "                                   Jefe Oficina de las TIC",
              6,
              FontWeight.normal),
        ]),
      ],
    ));
    pdf.addPage(MultiPage(
      header: _buildHeader,
      footer: _buildFooter,
      margin: const EdgeInsets.only(
          left: 2.5 * PdfPageFormat.cm,
          right: 2.5 * PdfPageFormat.cm,
          bottom: 0.6 * PdfPageFormat.cm,
          top: 0.6 * PdfPageFormat.cm),
      pageFormat: PdfPageFormat.letter.landscape,
      build: (context) => [
        SizedBox(height: separacionAltura * PdfPageFormat.cm),
        pw.Center(
          child: buildTextCentrado(
              "HOJA DE VIDA DE HARDWARE", 16, FontWeight.bold),
        ),
        SizedBox(height: separacionAltura * PdfPageFormat.cm),
        buildTableAreaTematica(),
        buildTableIdentificacionInstitucional(),
        buildTable4Columnas([
          'ÁREA ASGINADA:',
          area.nombre,
          'USUARIO RESPONSABLE:',
          '${funcionario.nombres} ${funcionario.apellidos}'
        ]),
        SizedBox(height: 0.3 * PdfPageFormat.cm),
        buildTableComponenteExterno(listaComponenteExterno),
        buildTableComponenteInterno(listaComponenteInterno),
        SizedBox(height: 0.3 * PdfPageFormat.cm),
        buildTableFirma(),
        SizedBox(height: 0.5 * PdfPageFormat.cm),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          buildTextJustificado("Proyectó:                  Alba Amador Orozco",
              6, FontWeight.bold),
          buildTextJustificado(
              "                                   Jefe Oficina de las TIC",
              6,
              FontWeight.normal),
          SizedBox(height: 0.2 * PdfPageFormat.cm),
          buildTextJustificado(
              "Revisó:                      Alba Amador Orozco",
              6,
              FontWeight.bold),
          buildTextJustificado(
              "                                   Jefe Oficina de las TIC",
              6,
              FontWeight.normal),
        ]),
      ],
    ));

    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      bool res =
          await saveDocumentDesktop(name: 'Hoja de vida equipo.pdf', pdf: pdf);
      return res;
    } else {
      saveDocumentMobile(name: 'Hoja de vida equipo.pdf', pdf: pdf);
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
              (activo.numActivo.isEmpty || activo.numActivo == null)
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
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
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

  static pw.Widget cuadrosBuenoMalo() {
    return pw.Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              buildCuadroVacio(),
              buildTextJustificado(' Buena', 7, FontWeight.normal)
            ])
          ]),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              buildCuadroVacio(),
              buildTextJustificado(' Regular', 7, FontWeight.normal)
            ])
          ]),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              buildCuadroVacio(),
              buildTextJustificado(' Mala', 7, FontWeight.normal)
            ])
          ]),
        ]);
  }

  static pw.Widget cuadrosSatisfaccion() {
    return pw.Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              buildCuadroVacio(),
              buildTextJustificado(' Satisfecho', 7, FontWeight.normal)
            ])
          ]),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              buildCuadroVacio(),
              buildTextJustificado(' Conforme', 7, FontWeight.normal)
            ])
          ]),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              buildCuadroVacio(),
              buildTextJustificado(' Insatisfecho', 7, FontWeight.normal)
            ])
          ]),
        ]);
  }

  static pw.Widget cuadrosLimpieza(String conlumna1, String columna2) {
    return pw.Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              buildCuadroVacio(),
              buildTextJustificado(' $conlumna1', 8, FontWeight.normal)
            ])
          ]),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              buildCuadroVacio(),
              buildTextJustificado(' $columna2', 8, FontWeight.normal)
            ])
          ]),
        ]);
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
              (activo.numActivo.isEmpty || activo.numActivo == null)
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
          0: const FixedColumnWidth(35.0),
          1: const FlexColumnWidth(),
          2: const FlexColumnWidth(),
          3: const FixedColumnWidth(45.0),
          4: const FlexColumnWidth(),
          5: const FixedColumnWidth(100.0),
        });
  }

  static Widget buildTableComponenteInterno(
      List<ComponenteInterno> listaComponenteInterno) {
    final headers = [
      'COMPONENTES TORRE',
      'MARCA',
      'VELOCIDAD',
      'OTRAS CARACTERISTICAS',
    ];
    if (listaComponenteInterno.length < 5) {
      while (listaComponenteInterno.length < 5) {
        listaComponenteInterno.add(ComponenteInterno());
      }
    }

    final data = listaComponenteInterno
        .map((activo) => [
              activo.nombre,
              activo.marca,
              activo.velocidad,
              activo.otrasCaracteristicas
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
        headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 8),
        headerHeight: 10,
        cellPadding: const EdgeInsets.all(2),
        headerDecoration: const BoxDecoration(color: PdfColors.grey300),
        headerAlignment: Alignment.center,
        cellStyle: const TextStyle(fontSize: 8),
        cellHeight: 10,
        cellAlignment: Alignment.center,
        columnWidths: {
          0: const FixedColumnWidth(200.0),
          1: const FixedColumnWidth(100.0),
          2: const FixedColumnWidth(100.0),
          3: const FlexColumnWidth(),
        });
  }

  static Widget buildTableSoftware(List<Software> listaSoftware) {
    final headers = [
      'NOMBRE',
      'FABRICANTE',
      'VERSION',
      'TIPO LICENCIA',
    ];

    if (listaSoftware.length < 7) {
      while (listaSoftware.length < 7) {
        listaSoftware.add(Software(tipoLicencia: ''));
      }
    }

    final data = listaSoftware
        .map((activo) => [
              activo.nombre,
              activo.fabricante,
              activo.version,
              activo.tipoLicencia
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
        headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 8),
        headerHeight: 10,
        cellPadding: const EdgeInsets.all(2),
        headerDecoration: const BoxDecoration(color: PdfColors.grey300),
        headerAlignment: Alignment.center,
        cellStyle: const TextStyle(fontSize: 8),
        cellHeight: 10,
        cellAlignment: Alignment.center,
        columnWidths: {
          0: const FixedColumnWidth(200.0),
          1: const FixedColumnWidth(100.0),
          2: const FixedColumnWidth(100.0),
          3: const FlexColumnWidth(),
        });
  }

  static Widget buildTableInfoEquipo(Activo activo) {
    List<Activo> listaSoftware = [activo];
    final headers = [
      'MARCA',
      'MODELO',
      'SERIAL',
      'N° PLACA INVENTARIO',
    ];

    final data = listaSoftware
        .map((activo) =>
            [activo.detalles, activo.nombre, activo.idSerial, activo.numActivo])
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
        headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 8),
        headerHeight: 10,
        cellPadding: const EdgeInsets.all(2),
        headerDecoration: const BoxDecoration(color: PdfColors.grey300),
        headerAlignment: Alignment.center,
        cellStyle: const TextStyle(fontSize: 8),
        cellHeight: 10,
        cellAlignment: Alignment.center,
        columnWidths: {
          0: const FixedColumnWidth(200.0),
          1: const FixedColumnWidth(100.0),
          2: const FixedColumnWidth(100.0),
          3: const FlexColumnWidth(),
        });
  }

  static Widget buildTableInfoEquipoTtulo() {
    List<Activo> listaSoftware = [];
    final headers = [
      'IDENTIFICACION DEL EQUIPO',
    ];

    final data = listaSoftware
        .map((activo) =>
            [activo.detalles, activo.nombre, activo.idSerial, activo.numActivo])
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
        headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 8),
        headerHeight: 10,
        cellPadding: const EdgeInsets.all(0),
        headerDecoration: const BoxDecoration(color: PdfColors.grey300),
        headerAlignment: Alignment.centerLeft,
        cellStyle: const TextStyle(fontSize: 8),
        cellHeight: 10,
        cellAlignment: Alignment.center,
        columnWidths: {
          0: const FlexColumnWidth(),
        });
  }

  static Widget buildTableComponenteExterno(
      List<Activo> listaComponenteExterno) {
    final headers = [
      'COMPONENTE',
      'MARCA',
      'SERIAL',
      'N° PLACA INVENTARIO',
      'DETALLES'
    ];
    if (listaComponenteExterno.length < 5) {
      while (listaComponenteExterno.length < 5) {
        listaComponenteExterno.add(Activo(detalles: ''));
      }
    }

    final data = listaComponenteExterno
        .map((activo) => [
              activo.nombre,
              activo.detalles,
              activo.idSerial,
              activo.numActivo,
              activo.detallesExtra
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
        headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 8),
        headerHeight: 10,
        cellPadding: const EdgeInsets.all(0),
        headerDecoration: const BoxDecoration(color: PdfColors.grey300),
        headerAlignment: Alignment.center,
        cellStyle: const TextStyle(fontSize: 8),
        cellHeight: 10,
        cellAlignment: Alignment.center,
        columnWidths: {
          0: const FixedColumnWidth(200.0),
          1: const FixedColumnWidth(100.0),
          2: const FixedColumnWidth(100.0),
          3: const FixedColumnWidth(100.0),
          4: const FlexColumnWidth(),
        });
  }

  static Widget buildTableFirma({List<String>? products}) {
    products = ['Nombre y Firma de usuario', 'Nombre y Firma del técnico'];
    return Table.fromTextArray(
        headers: null,
        data: List<List<String>>.generate(1, (row) => products!),
        border: const TableBorder(
            left: BorderSide(width: 0.6),
            right: BorderSide(width: 0.6),
            top: BorderSide(width: 0.6),
            bottom: BorderSide(width: 0.6),
            horizontalInside: BorderSide(width: 0.6),
            verticalInside: BorderSide(width: 0.6)),
        headerStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 7),
        headerAlignment: Alignment.bottomCenter,
        cellHeight: 30,
        cellStyle: TextStyle(fontSize: 8),
        cellAlignment: Alignment.center,
        columnWidths: {
          0: const FixedColumnWidth(300),
          1: const FlexColumnWidth(),
        });
  }

  static Widget buildTable4Columnas(List<String> campos) {
    return Table.fromTextArray(
        headers: null,
        data: List<List<String>>.generate(1, (row) => campos),
        border: const TableBorder(
            left: BorderSide(width: 0.6),
            right: BorderSide(width: 0.6),
            top: BorderSide(width: 0.6),
            bottom: BorderSide(width: 0.6),
            horizontalInside: BorderSide(width: 0.6),
            verticalInside: BorderSide(width: 0.6)),
        headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 7),
        headerAlignment: Alignment.centerLeft,
        cellHeight: 10,
        cellStyle: TextStyle(fontSize: 7),
        cellAlignment: Alignment.centerLeft,
        cellFormat: (index, data) {
          return 'fsddsfsd + data';
        },
        cellPadding: const EdgeInsets.all(2),
        columnWidths: {
          0: const FixedColumnWidth(200),
          1: const FixedColumnWidth(100),
          2: const FixedColumnWidth(200),
          3: const FlexColumnWidth(),
        });
  }

  static Widget buildCuadroVacio() {
    List<String> campos = [' '];
    return Table.fromTextArray(
        headers: null,
        data: List<List<String>>.generate(1, (row) => campos),
        border: const TableBorder(
            left: BorderSide(width: 0.6),
            right: BorderSide(width: 0.6),
            top: BorderSide(width: 0.6),
            bottom: BorderSide(width: 0.6),
            horizontalInside: BorderSide(width: 0.6),
            verticalInside: BorderSide(width: 0.6)),
        headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 5),
        headerAlignment: Alignment.centerLeft,
        cellHeight: 10,
        cellStyle: TextStyle(fontSize: 5),
        cellAlignment: Alignment.centerLeft,
        cellPadding: const EdgeInsets.all(1),
        columnWidths: {
          0: const FixedColumnWidth(20),
        });
  }

  static Widget buildTableIdentificacionInstitucional() {
    List<Activo> listaSoftware = [];
    final headers = [
      'IDENTIFICACIÓN INSTITUCIONAL',
    ];

    final data = listaSoftware
        .map((activo) =>
            [activo.detalles, activo.nombre, activo.idSerial, activo.numActivo])
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
        headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 8),
        headerHeight: 10,
        cellPadding: const EdgeInsets.all(2),
        headerDecoration: const BoxDecoration(color: PdfColors.grey300),
        headerAlignment: Alignment.centerLeft,
        cellStyle: const TextStyle(fontSize: 8),
        cellHeight: 10,
        cellAlignment: Alignment.center,
        columnWidths: {
          0: const FlexColumnWidth(),
        });
  }

  static Widget buildTableAreaTematica() {
    List<Activo> listaSoftware = [];
    final headers = [
      'ÁREA TEMÁTICA',
      'Sistemas e informatica',
      'PROCESO',
      'Administración del hardware'
    ];

    final data = listaSoftware
        .map((activo) =>
            [activo.detalles, activo.nombre, activo.idSerial, activo.numActivo])
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
        headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 6),
        headerHeight: 10,
        cellPadding: const EdgeInsets.all(2),
        headerDecoration: const BoxDecoration(color: PdfColors.grey300),
        headerAlignment: Alignment.centerLeft,
        cellStyle: const TextStyle(fontSize: 6),
        cellHeight: 10,
        cellAlignment: Alignment.center,
        columnWidths: {
          0: const FixedColumnWidth(200),
          1: const FixedColumnWidth(100),
          2: const FixedColumnWidth(200),
          3: const FlexColumnWidth(),
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
          0: const FixedColumnWidth(150),
          1: const FlexColumnWidth(),
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
  
  static Widget buildTextLeft(
          String texto, double tamano, FontWeight fuente) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(texto,
              style: TextStyle(fontSize: tamano, fontWeight: fuente),
              textAlign: TextAlign.left),
        ],
      );

  static Widget buildTextCentrado(
          String texto, double tamano, FontWeight fuente) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(texto,
              style: TextStyle(fontSize: tamano, fontWeight: fuente),
              textAlign: TextAlign.center),
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

  pw.Widget _buildFooter(pw.Context context, {bool contarPag = true}) {
    double altura = 10;
    return pw.Column(
      children: [
        if (contarPag)
          pw.Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Center(
                  child: Text('- ${context.pageNumber} -',
                      style: const TextStyle(fontSize: 11),
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
