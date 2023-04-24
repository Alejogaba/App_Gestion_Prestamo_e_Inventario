import 'dart:async';
import 'dart:developer';
import 'package:app_gestion_prestamo_inventario/assets/utilidades.dart';
import 'package:app_gestion_prestamo_inventario/entidades/activo_funcionario.dart';
import 'package:app_gestion_prestamo_inventario/entidades/activo.dart';
import 'package:app_gestion_prestamo_inventario/entidades/area.dart';
import 'package:app_gestion_prestamo_inventario/entidades/funcionario.dart';
import 'package:app_gestion_prestamo_inventario/entidades/hoja_salida.dart';
import 'package:app_gestion_prestamo_inventario/entidades/prestamo.dart';
import 'package:app_gestion_prestamo_inventario/servicios/storageController.dart';
import 'package:app_gestion_prestamo_inventario/vistas/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
//import 'package:sqflite/sqflite.dart';
// ignore: implementation_imports
import 'package:supabase/src/supabase_stream_builder.dart';
import 'package:supabase/supabase.dart';
import '../../assets/constantes.dart' as constantes;
import '../flutter_flow/flutter_flow_theme.dart';

class PrestamosController {
  Utilidades utilidades = Utilidades();
  final supabase =
      SupabaseClient(constantes.SUPABASE_URL, constantes.SUPABASE_ANNON_KEY);

  Future<String> registrarPrestamo(
      context, String idActivo, String idFuncionario, String? fechaHoraInicio,
      {bool entregado = false,
      String? observacion,
      DateTime? fechaHoraFinal}) async {
    try {
      await supabase.from('PRESTAMOS').insert({
        'ID_FUNCIONARIO': idFuncionario,
        'ID_ACTIVO': idActivo,
        'FECHA_HORA_INICIO': (fechaHoraInicio == null)
            ? DateTime.now().toString()
            : fechaHoraInicio,
        'ENTREGADO': entregado,
        'OBSERVACION': observacion,
        'FECHA_HORA_FINAL': (fechaHoraFinal == null)
            ? DateFormat.yMd('es_CO').format(DateTime.now())
            : DateFormat.yMd('es_CO').format(fechaHoraFinal),
        'FECHA_HORA_ENTREGA': (fechaHoraFinal == null)
            ? DateFormat.yMd('es_CO').format(DateTime.now())
            : DateFormat.yMd('es_CO').format(fechaHoraFinal),
      }).then((value) async {
        log('Nuevo activo prestado: $value');
        await supabase
            .from('ACTIVOS')
            .update({'ESTA_PRESTADO': true}).match({'ID_SERIAL': idActivo});
      });
      log("Prestado con exito");

      return 'ok';
    } on PostgrestException catch (errorPostgres) {
      var error = Utilidades()
          .validarErroresInsertar(errorPostgres.code!, 'Este prestamo');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          error,
          style: FlutterFlowTheme.of(context).bodyText2.override(
                fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                color: FlutterFlowTheme.of(context).tertiaryColor,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).bodyText2Family),
              ),
        ),
        backgroundColor: Colors.redAccent,
      ));
      log(errorPostgres.toString());
      return 'error';
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Ha ocurrido un error, revise su conexión a internet',
          style: FlutterFlowTheme.of(context).bodyText2.override(
                fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                color: FlutterFlowTheme.of(context).tertiaryColor,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).bodyText2Family),
              ),
        ),
        backgroundColor: Colors.redAccent,
      ));
      Logger().e(e);
      return 'error';
    }
  }

  Future<String> registrarHojaSalida(
      context, String descripcion, String seriales, String funcionario) async {
    try {
      final data = await supabase
          .from('HOJAS_SALIDAS')
          .select('*')
          .order('consecutivo', ascending: false)
          .limit(1)
          .maybeSingle() as Map<String, dynamic>;
      final HojaSalida ultimahojaSalida = HojaSalida.fromMap(data);
      final int consecutivo = ultimahojaSalida.id + 1;
      await supabase.from('HOJAS_SALIDAS').insert({
        'consecutivo': consecutivo,
        'descripcion': descripcion,
        'seriales': seriales,
        'funcionario': funcionario
      });
      log("Hoja de salida registrada con exito");
      if (consecutivo > 99) {
        return 'GTI-$consecutivo';
      } else if (consecutivo > 9) {
        return 'GTI-0$consecutivo';
      } else {
        return 'GTI-00$consecutivo';
      }
    } on Exception catch (error) {
      StorageController storageController = StorageController();
      var errorTraducido = await storageController.traducir(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          errorTraducido,
          style: FlutterFlowTheme.of(context).bodyText2.override(
                fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                color: FlutterFlowTheme.of(context).tertiaryColor,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).bodyText2Family),
              ),
        ),
        backgroundColor: Colors.redAccent,
      ));
      log(error.toString());
      return 'error';
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Ha ocurrido un error',
          style: FlutterFlowTheme.of(context).bodyText2.override(
                fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                color: FlutterFlowTheme.of(context).tertiaryColor,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).bodyText2Family),
              ),
        ),
        backgroundColor: Colors.redAccent,
      ));
      Logger().e(e);
      return 'error';
    }
  }

  Future<List<HojaSalida>> getHojaSalida(String? terminoBusqueda) async {
    try {
      if (terminoBusqueda != null && terminoBusqueda.length > 2) {
        final data = await supabase
            .from('HOJAS_SALIDAS')
            .select('*')
            .ilike('descripcion', '%$terminoBusqueda%') as List<dynamic>;
        log('Datos: $data');
        return (data).map((e) => HojaSalida.fromMap(e)).toList();
      } else {
        final data =
            await supabase.from('HOJAS_SALIDAS').select('*') as List<dynamic>;
        log('Datos: $data');
        return (data).map((e) => HojaSalida.fromMap(e)).toList();
      }
    } on PostgrestException catch (error) {
      log(error.message);
      return [];
    } catch (error) {
      log('Error al cargar categorias: $error');
      return [];
    }
  }

  Future<String> entregarPrestamo(
      context, String idFuncionario, String idActivo) async {
    try {
      if (idActivo.isNotEmpty) {
        final data = (await supabase.from('PRESTAMOS').update({
          'ENTREGADO': true,
          'FECHA_HORA_ENTREGA': DateFormat.yMd('es_CO').format(DateTime.now())
        }).match({
          'ID_FUNCIONARIO': idFuncionario,
          'ID_ACTIVO': idActivo,
        }).then((value) async {
          await supabase.from('ACTIVOS').update({
            'ESTA_PRESTADO': false,
          }).match({'ID_SERIAL': idActivo});
        }));
        log('Entregado:$data');
      } else {
        final data = (await supabase.from('PRESTAMOS').update({
          'ENTREGADO': true,
          'FECHA_HORA_ENTREGA': DateFormat.yMd('es_CO').format(DateTime.now())
        }).match({
          'ID_FUNCIONARIO': idFuncionario,
        }));
        log('Entregado:$data');
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Marcado como entregado',
            style: FlutterFlowTheme.of(context).bodyText2.override(
                  fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                  color: FlutterFlowTheme.of(context).tertiaryColor,
                  useGoogleFonts: GoogleFonts.asMap().containsKey(
                      FlutterFlowTheme.of(context).bodyText2Family),
                ),
          ),
          backgroundColor: FlutterFlowTheme.of(context).primaryColor));
      return 'ok';
    } on Exception catch (error) {
      StorageController storageController = StorageController();
      var errorTraducido = await storageController.traducir(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          errorTraducido,
          style: FlutterFlowTheme.of(context).bodyText2.override(
                fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                color: FlutterFlowTheme.of(context).tertiaryColor,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).bodyText2Family),
              ),
        ),
        backgroundColor: Colors.redAccent,
      ));
      log(error.toString());
      return 'error';
    } catch (e) {
      log(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Ha ocurrido un error inesperado',
          style: FlutterFlowTheme.of(context).bodyText2.override(
                fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                color: FlutterFlowTheme.of(context).tertiaryColor,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).bodyText2Family),
              ),
        ),
        backgroundColor: Colors.redAccent,
      ));
      return 'error';
    }
  }

  Future<List<Prestamo>> getActivosPrestados(
      {String? idFuncionario,
      String? idActivo,
      bool? soloMostarSinEntregar}) async {
    try {
      if (soloMostarSinEntregar != null && soloMostarSinEntregar) {
        if (idFuncionario != null) {
          final data = await supabase.from('PRESTAMOS').select('*').match({
            'ID_FUNCIONARIO': idFuncionario,
            'ENTREGADO': false
          }).order('FECHA_HORA_FINAL', ascending: true) as List<dynamic>;
          return (data).map((e) => Prestamo.fromMap(e)).toList();
        } else if (idActivo != null) {
          final data = await supabase
              .from('PRESTAMOS')
              .select('*')
              .match({'ID_ACTIVO': idActivo, 'ENTREGADO': false}).order(
                  'FECHA_HORA_FINAL',
                  ascending: true) as List<dynamic>;
          return (data).map((e) => Prestamo.fromMap(e)).toList();
        } else {
          final data = await supabase
              .from('PRESTAMOS')
              .select('*')
              .match({'ENTREGADO': false})
              .order('ENTREGADO', ascending: true)
              .order('FECHA_HORA_FINAL', ascending: true) as List<dynamic>;
          return (data).map((e) => Prestamo.fromMap(e)).toList();
        }
      } else {
        if (idFuncionario != null) {
          final data = await supabase
              .from('PRESTAMOS')
              .select('*')
              .eq('ID_FUNCIONARIO', idFuncionario)
              .order('ENTREGADO', ascending: true)
              .order('FECHA_HORA_FINAL', ascending: true) as List<dynamic>;
          return (data).map((e) => Prestamo.fromMap(e)).toList();
        } else if (idActivo != null) {
          final data = await supabase
              .from('PRESTAMOS')
              .select('*')
              .eq('ID_ACTIVO', idActivo)
              .order('ENTREGADO', ascending: true)
              .order('FECHA_HORA_FINAL', ascending: true) as List<dynamic>;
          return (data).map((e) => Prestamo.fromMap(e)).toList();
        } else {
          final data = await supabase
              .from('PRESTAMOS')
              .select('*')
              .order('ENTREGADO', ascending: true)
              .order('FECHA_HORA_FINAL', ascending: true) as List<dynamic>;
          return (data).map((e) => Prestamo.fromMap(e)).toList();
        }
      }
    } on PostgrestException catch (error) {
      Logger().e(error.message);
      return [];
    } catch (error) {
      Logger().e('Error al cargar ACTIVOS ASIGNADOS: $error');
      return [];
    }
  }
}
