import 'dart:async';

import 'package:app_gestion_prestamo_inventario/vistas/ajustes_page/actualizar.dart';
import 'package:app_gestion_prestamo_inventario/vistas/lista_funcionarios_page/lista_seleccion_funcionarios_page_widget.dart';
import 'package:flutter/material.dart';

import 'package:go_router_flow/go_router_flow.dart';
import 'package:page_transition/page_transition.dart';

import '../../vistas/resgistrar_activo_page/resgistrar_activo_computo_page_widget.dart';
import '../flutter_flow_theme.dart';

import '../../index.dart';
import '../../main.dart';

import 'serialization_util.dart';

export 'package:go_router_flow/go_router_flow.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

class AppStateNotifier extends ChangeNotifier {
  bool showSplashImage = true;

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      errorBuilder: (context, _) => appStateNotifier.showSplashImage
          ? Builder(
              builder: (context) => Container(
                color: FlutterFlowTheme.of(context).primaryColor,
                child: Center(
                  child: Image.asset(
                    'assets/images/Jc18_ESCUDO_LA_JAGUA_DE_IBIRICO.png',
                    width: MediaQuery.of(context).size.width * 0.5,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            )
          : NavBarPage(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => appStateNotifier.showSplashImage
              ? Builder(
                  builder: (context) => Container(
                    color: FlutterFlowTheme.of(context).primaryColor,
                    child: Center(
                      child: Image.asset(
                        'assets/images/Jc18_ESCUDO_LA_JAGUA_DE_IBIRICO.png',
                        width: MediaQuery.of(context).size.width * 0.5,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                )
              : NavBarPage(),
          routes: [
            FFRoute(
              name: 'principal',
              path: 'principal',
              builder: (context, params) => params.isEmpty
                  ? NavBarPage(initialPage: 'principal')
                  : PrincipalWidget(
                      selectMode: params.getParam('selectMode', ParamType.bool),
                    ),
            ),
            FFRoute(
              name: 'loginPage',
              path: 'loginPage',
              builder: (context, params) => LoginPageWidget(),
            ),
            FFRoute(
              name: 'AjustesPage',
              path: 'ajustesPage',
              builder: (context, params) => params.isEmpty
                  ? NavBarPage(initialPage: 'AjustesPage')
                  : AjustesPageWidget(),
            ),
            FFRoute(
              name: 'ActualizarPage',
              path: 'actualizarPage',
              builder: (context, params) => ActualizarPageWidget(
                  url: params.getParam('url', ParamType.String)),
            ),
            FFRoute(
              name: 'ListaFuncionariosPage',
              path: 'listaFuncionariosPage',
              builder: (context, params) => params.isEmpty
                  ? NavBarPage(initialPage: 'ListaFuncionariosPage')
                  : ListaFuncionariosPageWidget(),
            ),
            FFRoute(
              name: 'ListaSeleccionFuncionariosPage',
              path: 'listaSeleccionFuncionariosPage',
              builder: (context, params) =>
                  ListaSeleccionFuncionariosPageWidget(),
            ),
            FFRoute(
              name: 'RegistrarCategoriaPage',
              path: 'registrarCategoriaPage',
              builder: (context, params) => RegistrarCategoriaPageWidget(),
            ),
            FFRoute(
              name: 'RegistrarFuncionarioPage',
              path: 'registrarFuncionarioPage',
              builder: (context, params) => RegistrarFuncionarioPageWidget(),
            ),
            FFRoute(
              name: 'FuncionarioPerfilPage',
              path: 'funcionarioPerfilPage',
              builder: (context, params) => FuncionarioPerfilPageWidget(
                  funcionario:
                      params.getParam('funcionario', ParamType.Funcionario)),
            ),
            FFRoute(
              name: 'ActivoPerfilPage',
              path: 'activoPerfilPage',
              builder: (context, params) => ActivoPerfilPageWidget(
                  activo: params.getParam('miActivo', ParamType.Activo),
                  selectMode: params.getParam('selectMode', ParamType.bool),
                  esPrestamo: params.getParam('esPrestamo', ParamType.bool)),
            ),
            FFRoute(
              name: 'ListaActivosPage',
              path: 'listaActivosPage',
              builder: (context, params) => ListaActivosPageWidget(
                  idCategoria: params.getParam('idCategoria', ParamType.int),
                  selectMode: params.getParam('selectMode', ParamType.bool),
                  esPrestamo: params.getParam('esPrestamo', ParamType.bool)),
            ),
            FFRoute(
              name: 'ListaPrestamosPage',
              path: 'listaPrestamosPage',
              builder: (context, params) => params.isEmpty
                  ? NavBarPage(initialPage: 'ListaPrestamosPage')
                  : ListaPrestamosPageWidget(),
            ),
            FFRoute(
              name: 'ResgistrarPrestamosPage',
              path: 'resgistrarPrestamosPage',
              builder: (context, params) => RegistrarPrestamoPageWidget(),
            ),
            FFRoute(
              name: 'RegistrarActivoPage',
              path: 'registrarActivoPage',
              builder: (context, params) => ResgistrarActivoPageWidget(
                operacionaRealizar:
                    params.getParam('operacionaRealizar', ParamType.String),
                idSerial: params.getParam('idSerial', ParamType.String),
                idCategoria: params.getParam('idCategoria', ParamType.int),
                activoEditar: params.getParam('activoEditar', ParamType.Activo),
              ),
            ),
            
          ].map((r) => r.toRoute(appStateNotifier)).toList(),
        ).toRoute(appStateNotifier),
      ],
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(params)
    ..addAll(queryParams)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.extraMap.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, [
    bool isList = false,
  ]) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        pageBuilder: (context, state) {
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder: PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).transitionsBuilder,
                )
              : MaterialPage(key: state.pageKey, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: false);
}
