import 'dart:async';
import 'dart:developer';
import 'package:app_gestion_prestamo_inventario/assets/utilidades.dart';
import 'package:app_gestion_prestamo_inventario/entidades/activo.dart';
import 'package:app_gestion_prestamo_inventario/entidades/categoria.dart';
import 'package:app_gestion_prestamo_inventario/servicios/storageController.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
//import 'package:sqflite/sqflite.dart';
// ignore: implementation_imports
import 'package:supabase/src/supabase_stream_builder.dart';
import 'package:supabase/supabase.dart';
import '../../assets/constantes.dart' as constantes;
import '../entidades/activo_funcionario.dart';
import '../entidades/funcionario.dart';
import '../flutter_flow/flutter_flow_theme.dart';

class ActivoController {
  Utilidades utilidades = Utilidades();
  final supabase =
      SupabaseClient(constantes.SUPABASE_URL, constantes.SUPABASE_ANNON_KEY);

  Future<String> addActivo(
      context,
      String idSerial,
      String? numInventario,
      String nombre,
      String? detalles,
      String? urlImagen,
      int estado,
      String? categoria,
      int? idCategoria,
      int? cantidad,
      String? capacidad,
      String? fechaCreado,
      {bool editar = false}) async {
    try {
      log('Insertando nuevo activo......');
      Utilidades utilidades = Utilidades();
      if (editar) {
        await supabase
            .from('ACTIVOS')
            .update({
              'NUM_ACTIVO': numInventario,
              'NOMBRE': utilidades.mayusculaTodasPrimerasLetras(nombre),
              'DETALLES': (detalles == null || detalles.trim().isEmpty)
                  ? 'Genérico'
                  : utilidades.mayusculaPrimeraLetra(detalles),
              'URL_IMAGEN': urlImagen,
              'ESTADO': estado,
              'NOMBRE_CATEGORIA': (categoria!=null) ?
                  utilidades.mayusculaTodasPrimerasLetras(categoria):'Proyectores',
              'ID_CATEGORIA': (idCategoria!=null) ? idCategoria:3,
              'CANTIDAD': cantidad,
              'CAPACIDAD': capacidad,
            })
            .eq('ID_SERIAL', idSerial.toUpperCase())
            .then((value) => log('Nueva activo registrado: $value'));
      } else {
        await supabase.from('ACTIVOS').insert({
          'ID_SERIAL': idSerial.toUpperCase(),
          'NUM_ACTIVO': numInventario,
          'NOMBRE': utilidades.mayusculaTodasPrimerasLetras(nombre),
          'DETALLES': (detalles == null || detalles.trim().isEmpty)
              ? 'Genérico'
              : utilidades.mayusculaPrimeraLetra(detalles),
          'URL_IMAGEN': urlImagen,
          'ESTADO': estado,
          'NOMBRE_CATEGORIA':(categoria!=null) ?
                  utilidades.mayusculaTodasPrimerasLetras(categoria):'Proyectores',
          'ID_CATEGORIA': idCategoria,
          'CANTIDAD': cantidad,
          'CAPACIDAD': capacidad,
        }).then((value) => log('Nueva activo registrado: $value'));
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 1),
        content: Text(
          "Activo registrado con exitó",
          style: FlutterFlowTheme.of(context).bodyText2.override(
                fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                color: FlutterFlowTheme.of(context).tertiaryColor,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).bodyText2Family),
              ),
        ),
        backgroundColor: FlutterFlowTheme.of(context).primaryColor,
      ));
      return 'ok';
    } on PostgrestException catch (errorPostgres) {
      StorageController storageController = StorageController();
      var error = Utilidades().validarErroresInsertar(
          errorPostgres.code!, 'Este activo',
          objetoLlaveForaneo: 'esa categoria');
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
      log(e.toString());
      return 'error';
    }
  }

  Future<String> asignarActivo(
    context,
    String idFuncionario,
    String idActivo,
  ) async {
    try {
      await supabase.from('FUNCIONARIOS_ACTIVOS').insert({
        'ID_FUNCIONARIO': idFuncionario,
        'ID_SERIAL': idActivo,
      }).then((value) async {
        log('Nuevo activo asignado: $value');
        await supabase
            .from('ACTIVOS')
            .update({'ESTA_ASIGNADO': true}).match({'ID_SERIAL': idActivo});
        await supabase
            .from('FUNCIONARIOS')
            .update({'TIENE_ACTIVOS': true}).match({'CEDULA': idFuncionario});
      });
      log("Asignado con exito");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Activo asignado con exitó",
          style: FlutterFlowTheme.of(context).bodyText2.override(
                fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                color: FlutterFlowTheme.of(context).tertiaryColor,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).bodyText2Family),
              ),
        ),
        backgroundColor: FlutterFlowTheme.of(context).primaryColor,
      ));
      return 'ok';
    } on PostgrestException catch (errorPostgres) {
      var error = Utilidades().validarErroresInsertar(
        errorPostgres.code!,
        'Este activo',
      );
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
      log(e.toString());
      return 'error';
    }
  }

  Future<Funcionario> buscarFuncionarioAsignado(String idActivo) async {
    Funcionario funcionarioVacio = Funcionario(tieneActivos: false);
    try {
      final data = (await supabase
              .from('FUNCIONARIOS_ACTIVOS')
              .select()
              .match({'ID_SERIAL': idActivo}).maybeSingle())
          as Map<String, dynamic>?;
      if (data == null) {
        return funcionarioVacio;
      } else {
        ActivoFuncionario activoFuncionario = ActivoFuncionario.fromMap(data);
        final dataFuncionario = (await supabase
                .from('FUNCIONARIOS')
                .select()
                .match(
                    {'CEDULA': activoFuncionario.idFuncionaro}).maybeSingle())
            as Map<String, dynamic>?;
        if (dataFuncionario == null) {
          return funcionarioVacio;
        }else{
          return Funcionario.fromMap(dataFuncionario);
        }
      }
    } catch (e) {
      log(e.toString());
      return funcionarioVacio;
    }
  }

  Stream<SupabaseStreamEvent> getActivoStream(String? categoria) {
    if (categoria!.contains('Todos')) {
      final response = (categoria != null && categoria.length > 3)
          ? supabase.from('ACTIVOS').stream(
              primaryKey: ['ID_SERIAL']).order('FECHA_CREADO', ascending: false)
          : supabase.from('ACTIVOS').stream(primaryKey: ['ID_SERIAL']).order(
              'FECHA_CREADO',
              ascending: false);
      return response;
    } else {
      final response = (categoria != null && categoria.length > 3)
          ? supabase
              .from('ACTIVOS')
              .stream(primaryKey: ['ID_SERIAL'])
              .eq('NOMBRE_CATEGORIA', categoria)
              .order('FECHA_CREADO', ascending: false)
          : supabase.from('ACTIVOS').stream(primaryKey: ['ID_SERIAL']).order(
              'FECHA_CREADO',
              ascending: false);
      return response;
    }
  }

  Future<List<Activo>> getActivosList(String? nombre, int? idCategoria) async {
    try {
      if (nombre == null || nombre.trim().isEmpty) {
        final data = (idCategoria != null && !(idCategoria == 2))
            ? await supabase
                .from('ACTIVOS')
                .select('*')
                .eq('ID_CATEGORIA', idCategoria)
                .order('FECHA_CREADO', ascending: false) as List<dynamic>
            : await supabase
                .from('ACTIVOS')
                .select('*')
                .order('FECHA_CREADO', ascending: false) as List<dynamic>;
        log('Datos: $data');
        return (data).map((e) => Activo.fromMap(e)).toList();
      } else {
        final data = (idCategoria != null && !(idCategoria == 2))
            ? await supabase
                .from('ACTIVOS')
                .select('*')
                .textSearch('NOMBRE',
                    "'${Utilidades().mayusculaPrimeraLetraFrase(nombre)}'")
                .eq('ID_CATEGORIA', idCategoria)
                .order('FECHA_CREADO', ascending: false) as List<dynamic>
            : await supabase
                .from('ACTIVOS')
                .select('*')
                .textSearch('NOMBRE',
                    "'${Utilidades().mayusculaPrimeraLetraFrase(nombre)}'")
                .order('FECHA_CREADO', ascending: false) as List<dynamic>;
        log('Datos: $data');
        return (data).map((e) => Activo.fromMap(e)).toList();
      }
    } on PostgrestException catch (error) {
      log(error.message);
      return [];
    } catch (error) {
      log('Error al cargar activos: $error');
      return [];
    }
  }

  Future<Categoria> buscarCategoria(int id) async {
    Categoria vacio = Categoria('', '', '');
    try {
      final data = (await supabase
          .from('CATEGORIAS')
          .select()
          .match({'ID': id}).maybeSingle()) as Map<String, dynamic>?;
      if (data == null) {
        return vacio;
      } else {
        return Categoria.fromMap(data);
      }
    } catch (e) {
      log(e.toString());
      return vacio;
    }
  }

  Future<Activo> buscarActivo(String idSerial) async {
    Activo activoVacio = Activo();
    try {
      final data = (await supabase
              .from('ACTIVOS')
              .select()
              .match({'ID_SERIAL': idSerial}).maybeSingle())
          as Map<String, dynamic>?;
      if (data == null) {
        return activoVacio;
      } else {
        return Activo.fromMap(data);
      }
    } catch (e) {
      log(e.toString());
      return activoVacio;
    }
  }

  Future<String> eliminarActivo(context, String idSerial) async {
    late String response;
    try {
      (await supabase.from('PRESTAMOS').delete().match({'ID_ACTIVO': idSerial,'ENTREGADO':true}).then((value) async {
        final data =
          (await supabase.from('ACTIVOS').delete().eq('ID_SERIAL', idSerial));
      log('Eliminando:$data');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Eliminado con exitó',
          style: FlutterFlowTheme.of(context).bodyText2.override(
                fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                color: FlutterFlowTheme.of(context).tertiaryColor,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).bodyText2Family),
              ),
        ),
        backgroundColor: FlutterFlowTheme.of(context).primaryColor,
      ));
      response='ok';
      }));
      return response;
    } on PostgrestException catch (errorPostgres) {
      var error = Utilidades().validarErroresEliminar(
          errorPostgres.code!, 'este activo,',
          objetoLlaveForaneo: 'un funcionario asignado o se prestó a un funcionario');
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
      log(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Ha ocurrido un error inesperado al intentar eliminar el activo, verfique su conexión a internet',
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

  Future<List<ActivoFuncionario>> getFuncionarioAsignado(
      String idActivo) async {
    try {
      final data = await supabase
          .from('FUNCIONARIOS_ACTIVOS')
          .select('*')
          .eq('ID_SERIAL', idActivo) as List<dynamic>;
      Logger().d('Datos funcionarios activos: $data');
      return (data).map((e) => ActivoFuncionario.fromMap(e)).toList();
    } on PostgrestException catch (error) {
      Logger().e(error.message);
      return [];
    } catch (error) {
      Logger().e('Error al cargar ACTIVOS ASIGNADOS: $error');
      return [];
    }
  }

  Future<String> quitarActivoFuncionario(context, String idActivo) async {
    try {
      final data = (await supabase
          .from('FUNCIONARIOS_ACTIVOS')
          .delete()
          .match({'ID_SERIAL': idActivo}).then((value) async {
        await supabase
            .from('ACTIVOS')
            .update({'ESTA_ASIGNADO': false}).match({'ID_SERIAL': idActivo});
      }));
      log('Eliminando:$data');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Se ha desasignado el activo',
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

  Future<String> quitarFuncionarioActivo(
      context, String idFuncionario, int cantidadActivos) async {
    try {
      final data = (await supabase
          .from('FUNCIONARIOS_ACTIVOS')
          .delete()
          .match({'ID_FUNCIONARIO': idFuncionario}).then((value) async {
        if (cantidadActivos < 2) {
          await supabase.from('FUNCIONARIOS').update(
              {'TIENE_ACTIVOS': false}).match({'CEDULA': idFuncionario});
        }
      }));
      log('Eliminando:$data');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Se ha quitado con exitó',
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
}
