import 'dart:async';
import 'dart:developer';
import 'package:app_gestion_prestamo_inventario/assets/utilidades.dart';
import 'package:app_gestion_prestamo_inventario/entidades/activo_funcionario.dart';
import 'package:app_gestion_prestamo_inventario/entidades/activo.dart';
import 'package:app_gestion_prestamo_inventario/entidades/area.dart';
import 'package:app_gestion_prestamo_inventario/entidades/funcionario.dart';
import 'package:app_gestion_prestamo_inventario/servicios/storageController.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
//import 'package:sqflite/sqflite.dart';
// ignore: implementation_imports
import 'package:supabase/src/supabase_stream_builder.dart';
import 'package:supabase/supabase.dart';
import '../../assets/constantes.dart' as constantes;
import '../flutter_flow/flutter_flow_theme.dart';

class FuncionariosController {
  Utilidades utilidades = Utilidades();
  final supabase =
      SupabaseClient(constantes.SUPABASE_URL, constantes.SUPABASE_ANNON_KEY);

  Future<String> addFuncionario(
      {context,
      String? cedula,
      String? apellidos,
      String? nombres,
      String? correo,
      String? cargo,
      String? urlImagen,
      int idArea = 0,
      String? telefono1,
      String? telefono2,
      String? enlaceSIGEP,
      bool editar = false}) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Registrando al funcionario...",
          style: FlutterFlowTheme.of(context).bodyText2.override(
                fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                color: FlutterFlowTheme.of(context).tertiaryColor,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).bodyText2Family),
              ),
        ),
        backgroundColor: FlutterFlowTheme.of(context).primaryColor,
      ));
      log('Registrando nuevo funcionario...');
      Utilidades utilidades = Utilidades();
      if (editar) {
        await supabase
            .from('FUNCIONARIOS')
            .update({
              'NOMBRES': utilidades.mayusculaTodasPrimerasLetras(nombres!),
              'APELLIDOS': (apellidos == null)
                  ? ''
                  : utilidades.mayusculaTodasPrimerasLetras(apellidos),
              'CARGO': utilidades.mayusculaPrimeraLetraFrase(cargo!),
              'CORREO': (correo == null)
                  ? ''
                  : utilidades.mayusculaPrimeraLetraFrase(correo),
              'URL_IMAGEN': urlImagen,
              'ID_AREA': idArea,
              'TELEFONO_1': telefono1,
              'TELEFONO_2': (telefono2 == null) ? '' : telefono2,
              'ENLACE_SIGEP': enlaceSIGEP,
            })
            .eq('CEDULA', cedula)
            .then((value) {
              log("Registrado con exito");
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  "Funcionario actualizado con exitó",
                  style: FlutterFlowTheme.of(context).bodyText2.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).bodyText2Family,
                        color: FlutterFlowTheme.of(context).tertiaryColor,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                            FlutterFlowTheme.of(context).bodyText2Family),
                      ),
                ),
                backgroundColor: FlutterFlowTheme.of(context).primaryColor,
              ));
              return 'ok';
            });
      } else {
        await supabase.from('FUNCIONARIOS').insert({
          'CEDULA': cedula,
          'NOMBRES': utilidades.mayusculaTodasPrimerasLetras(nombres!),
          'APELLIDOS': (apellidos == null)
              ? ''
              : utilidades.mayusculaTodasPrimerasLetras(apellidos),
          'CARGO': utilidades.mayusculaPrimeraLetraFrase(cargo!),
          'CORREO': (correo == null)
              ? ''
              : utilidades.mayusculaPrimeraLetraFrase(correo),
          'URL_IMAGEN': urlImagen,
          'ID_AREA': idArea,
          'TELEFONO_1': telefono1,
          'TELEFONO_2': (telefono2 == null) ? '' : telefono2,
          'ENLACE_SIGEP': enlaceSIGEP,
        }).then((value) {
          log("Registrado con exito");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Funcionario registrado con exitó",
              style: FlutterFlowTheme.of(context).bodyText2.override(
                    fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                    color: FlutterFlowTheme.of(context).tertiaryColor,
                    useGoogleFonts: GoogleFonts.asMap().containsKey(
                        FlutterFlowTheme.of(context).bodyText2Family),
                  ),
            ),
            backgroundColor: FlutterFlowTheme.of(context).primaryColor,
          ));
          return 'ok';
        });
      }

      return 'ok';
    } on PostgrestException catch (errorPostgres) {
      StorageController storageController = StorageController();
      var error = Utilidades().validarErroresInsertar(
          errorPostgres.code!, 'Este funcionario',
          objetoLlaveForaneo: 'esa area');
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

  Future<List<Area>> getAreas() async {
    try {
      final data = await supabase
          .from('AREAS')
          .select('*')
          .order('ID', ascending: true) as List<dynamic>;
      log('Datos de areas: $data');
      return (data).map((e) => Area.fromMap(e)).toList();
    } on PostgrestException catch (error) {
      log("Error al cargar las areas: ${error.message}");
      return [];
    } catch (error) {
      log('Error al cargar las areas: $error');
      return [];
    }
  }

  Stream<SupabaseStreamEvent> getFuncionarioStream(
      String? idArea, String? terminoBusqueda) {
    final response = (idArea != null && idArea.length > 3)
        ? supabase
            .from('FUNCIONARIOS')
            .stream(primaryKey: ['CEDULA'])
            .eq('ID_AREA', idArea)
            .order('FECHA_CREADO', ascending: false)
        : supabase.from('FUNCIONARIOS').stream(
            primaryKey: ['CEDULA']).order('FECHA_CREADO', ascending: false);
    return response;
  }

  Future<Funcionario> buscarFuncionarioIndividual(String cedula) async {
    Funcionario funcionarioVacio = Funcionario(tieneActivos: false);
    try {
      final data = (await supabase
          .from('FUNCIONARIOS')
          .select()
          .match({'CEDULA': cedula}).maybeSingle()) as Map<String, dynamic>?;
      if (data == null) {
        return funcionarioVacio;
      } else {
        return Funcionario.fromMap(data);
      }
    } catch (e) {
      log(e.toString());
      return funcionarioVacio;
    }
  }

  Future<Area> buscarArea(String id) async {
    Area vacio = Area();
    try {
      final data = (await supabase
          .from('AREAS')
          .select()
          .match({'ID': id}).maybeSingle()) as Map<String, dynamic>?;
      if (data == null) {
        return vacio;
      } else {
        return Area.fromMap(data);
      }
    } catch (e) {
      log(e.toString());
      return vacio;
    }
  }

  Future<List<Funcionario>> getFuncionarios(String? terminoBusqueda) async {
    try {
      if (terminoBusqueda != null && terminoBusqueda.length > 2) {
        final data = await supabase
            .from('FUNCIONARIOS')
            .select('*')
            .ilike('NOMBRES', '%$terminoBusqueda%').order('NOMBRES', ascending: true) as List<dynamic>;
        log('Datos: $data');
        return (data).map((e) => Funcionario.fromMap(e)).toList();
      } else {
        final data =
            await supabase.from('FUNCIONARIOS').select('*').order('NOMBRES', ascending: true) as List<dynamic>;
        log('Datos: $data');
        return (data).map((e) => Funcionario.fromMap(e)).toList();
      }
    } on PostgrestException catch (error) {
      log(error.message);
      return [];
    } catch (error) {
      log('Error al cargar categorias: $error');
      return [];
    }
  }

  Future<List<ActivoFuncionario>> getActivosAsignados(String cedula) async {
    try {
      final data = await supabase
          .from('FUNCIONARIOS_ACTIVOS')
          .select('*')
          .eq('ID_FUNCIONARIO', cedula) as List<dynamic>;
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

  Future<String> eliminar(context, String id) async {
    try {
      late String response;
      (await supabase.from('PRESTAMOS').delete().match(
          {'ID_FUNCIONARIO': id, 'ENTREGADO': true}).then((value) async {
        final data =
            (await supabase.from('FUNCIONARIOS').delete().eq('CEDULA', id));
        log('Eliminando:$data');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Eliminado con exitó',
            style: FlutterFlowTheme.of(context).bodyText2.override(
                  fontFamily: FlutterFlowTheme.of(context).bodyText2Family,
                  color: FlutterFlowTheme.of(context).tertiaryColor,
                  useGoogleFonts: GoogleFonts.asMap().containsKey(
                      FlutterFlowTheme.of(context).bodyText2Family),
                ),
          ),
          backgroundColor: FlutterFlowTheme.of(context).primaryColor,
        ));
        response = 'ok';
      }));
      return response;
    } on PostgrestException catch (errorPostgres) {
      var error = Utilidades().validarErroresEliminar(
          errorPostgres.code!, 'este funcionario',
          objetoLlaveForaneo: 'uno o más activos asignados o prestados');
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
          'Ha ocurrido un error inesperado al intentar eliminar el activo',
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

  Future<String> eliminarFuncionario(context, String id) async {
    try {
      final data =
          (await supabase.from('FUNCIONARIOS').delete().eq('CEDULA', id));
      log('Eliminando:$data');
      return 'ok';
    } on PostgrestException catch (errorPostgres) {
      var error = Utilidades().validarErroresEliminar(
          errorPostgres.code!, 'Este funcionario',
          objetoLlaveForaneo: 'activos asignados');
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
          'Ha ocurrido un error inesperado al intentar eliminar al funcionario',
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
