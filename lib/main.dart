import 'package:app_gestion_prestamo_inventario/vistas/add_item/add_item_widget.dart';
import 'package:app_gestion_prestamo_inventario/vistas/flutter_flow/flutter_flow_theme.dart';
import 'package:app_gestion_prestamo_inventario/vistas/lista/lista_widget.dart';
import 'package:app_gestion_prestamo_inventario/vistas/login_page/login_page_widget.dart';
import 'package:app_gestion_prestamo_inventario/vistas/principal/home_screen.dart';
import 'package:app_gestion_prestamo_inventario/vistas/principal/principal_widget.dart';
import 'package:flutter/material.dart';

import 'package:app_gestion_prestamo_inventario/vistas/wrapper.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../assets/constantes.dart' as constantes;
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:go_router/go_router.dart';
import 'flutter_flow/internationalization.dart';
import 'flutter_flow/nav/nav.dart';
import 'index.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: constantes.SUPABASE_URL,
    anonKey: constantes.SUPABASE_ANNON_KEY,
  );
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterFlowTheme.initialize();
  runApp(MyApp());
}

final GoRouter g_router = GoRouter(
      routes: [
        GoRoute(
          name: '_initialize',
          path: '/',
          builder: (context, params) => Wrapper(),
          routes: [
            GoRoute(
              name: 'principal',
              path: 'principal',
              builder: (context, params) => PrincipalWidget(),
            ),
            GoRoute(
              name: 'lista',
              path: 'lista',
              builder: (context, params) => ListaWidget(),
            ),
            GoRoute(
              name: 'loginPage',
              path: 'loginPage',
              builder: (context, params) => LoginPageWidget(),
            ),
            GoRoute(
              name: 'addItem',
              path: 'addItem',
              builder: (context, params) => AddItemWidget(),
            )
          ]
        )
      ],
    );

final GoRouter l_router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const Wrapper();
      },
      routes: [
        GoRoute(
          path: 'principal',
          builder: (BuildContext context, GoRouterState state) {
            return const PrincipalWidget();
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}



class _MyAppState extends State<MyApp> {
  Locale? _locale;
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  late AppStateNotifier _appStateNotifier;


  @override
  void initState() {
    super.initState();
    _appStateNotifier = AppStateNotifier();

  }

  void setLocale(String language) =>
      setState(() => _locale = createLocale(language));
  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });
  


  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: g_router,
      title: 'InventariadoApp',
      // ignore: prefer_const_literals_to_create_immutables
      localizationsDelegates: [
        const FFLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: _locale,
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: _themeMode,
    );
  }

  
}


