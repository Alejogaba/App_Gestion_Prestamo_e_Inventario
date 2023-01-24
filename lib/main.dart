import 'dart:developer';
import 'dart:io';

import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart' as prefs;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/internationalization.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' as FFIcons;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'flutter_flow/nav/nav.dart';
import 'index.dart';
import 'flutter_flow/custom_icons.dart' as custom_icons;
import 'assets/constantes.dart' as constantes;
import 'vistas/ajustes_page/ajustes_page_widget.dart';
import 'vistas/flutter_flow/customIcons.dart';
import 'vistas/lista_funcionarios_page/lista_funcionarios_page_widget.dart';
import 'vistas/lista_prestamos_page/lista_prestamos_page_widget.dart';
import 'vistas/principal/principal_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  await Supabase.initialize(
    url: constantes.SUPABASE_URL,
    anonKey: constantes.SUPABASE_ANNON_KEY,
  );
  Directory _tempDirectory = await getTemporaryDirectory();
  if (Platform.isAndroid) {
    List<Directory>? _externalCacheDirectories =
        await getExternalCacheDirectories();
    _externalCacheDirectories?.forEach((element) {
      log('Ruta directorios de cache: ${element.path}');
    });
  } else {
    log('Ruta directorio temporal: ${_tempDirectory.path}');
  }
  await FastCachedImageConfig.init(
      path: _tempDirectory.path, clearCacheAfter: const Duration(days: 15));
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterFlowTheme.initialize();
  runApp(MyApp());
}

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
  late GoRouter _router;

  bool displaySplashImage = true;

  @override
  void initState() {
    super.initState();
    _appStateNotifier = AppStateNotifier();
    _router = createRouter(_appStateNotifier);

    Future.delayed(Duration(seconds: 1),
        () => setState(() => _appStateNotifier.stopShowingSplashImage()));
  }
  

  void setLocale(String language) {
    setState(() => _locale = createLocale(language));
  }

  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
             GlobalCupertinoLocalizations.delegate,

      ],
     supportedLocales: [
          const Locale('es','CO'),
      ],
      locale: const Locale('es'),
      title: 'InventariadoApp',
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: _themeMode,
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
    );
  }
}

class NavBarPage extends StatefulWidget {
  NavBarPage({Key? key, this.initialPage, this.page}) : super(key: key);

  final String? initialPage;
  final Widget? page;

  @override
  _NavBarPageState createState() => _NavBarPageState();
}

/// This is the private State class that goes with NavBarPage.
class _NavBarPageState extends State<NavBarPage> {
  String _currentPageName = 'principal';
  late Widget? _currentPage;
  @override
  void initState() {
    super.initState();
    _currentPageName = widget.initialPage ?? _currentPageName;
    _currentPage = widget.page;
  }

  @override
  Widget build(BuildContext context) {
    final tabs = {
      'ListaPrestamosPage': ListaPrestamosPageWidget(),
      'principal': PrincipalWidget(),
      'ListaFuncionariosPage': ListaFuncionariosPageWidget(),
      //'AjustesPage': AjustesPageWidget(),
    };
    final currentIndex = tabs.keys.toList().indexOf(_currentPageName);
    return Scaffold(
      body: _currentPage ?? tabs[_currentPageName],
      extendBody: true,
      bottomNavigationBar: Visibility(
        visible: true,
        child: FloatingNavbar(
          currentIndex: currentIndex,
          onTap: (i) => setState(() {
            _currentPage = null;
            _currentPageName = tabs.keys.toList()[i];
          }),
          backgroundColor: FlutterFlowTheme.of(context).primaryColor,
          selectedItemColor: FlutterFlowTheme.of(context).tertiaryColor,
          unselectedItemColor: FlutterFlowTheme.of(context).secondaryText,
          selectedBackgroundColor: Color(0x00004121),
          borderRadius: 5,
          itemBorderRadius: 15,
          margin: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
          padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
          width: MediaQuery.of(context).size.width * 1,
          elevation: 0,
          items: [
            FloatingNavbarItem(
              customWidget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    currentIndex == 0
                        ? FontAwesomeIcons.handHolding
                        : FontAwesomeIcons.handHolding,
                    color: currentIndex == 0
                        ? FlutterFlowTheme.of(context).tertiaryColor
                        : FlutterFlowTheme.of(context).secondaryText,
                    size: 30,
                  ),
                ],
              ),
            ),
            FloatingNavbarItem(
              customWidget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.boxOpen,
                    color: currentIndex == 1
                        ? FlutterFlowTheme.of(context).tertiaryColor
                        : FlutterFlowTheme.of(context).secondaryText,
                    size: 24,
                  ),
                ],
              ),
            ),
            FloatingNavbarItem(
              customWidget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    currentIndex == 2
                        ? FontAwesomeIcons.userTie
                        : FontAwesomeIcons.userTie,
                    color: currentIndex == 2
                        ? FlutterFlowTheme.of(context).tertiaryColor
                        : FlutterFlowTheme.of(context).secondaryText,
                    size: 30,
                  ),
                ],
              ),
            ),
            /*FloatingNavbarItem(
              customWidget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    currentIndex == 3
                        ? FontAwesomeIcons.gear
                        : FontAwesomeIcons.gear,
                    color: currentIndex == 3
                        ? FlutterFlowTheme.of(context).tertiaryColor
                        : FlutterFlowTheme.of(context).secondaryText,
                    size: 30,
                  ),
                ],
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
