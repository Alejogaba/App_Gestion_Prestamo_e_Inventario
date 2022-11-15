import 'package:flutter/material.dart';
import 'package:app_gestion_prestamo_inventario/entidades/usuario.dart';
import 'package:app_gestion_prestamo_inventario/servicios/auth.dart';
import 'package:app_gestion_prestamo_inventario/vistas/CommonWidgets/themeData.dart';
import 'package:app_gestion_prestamo_inventario/vistas/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../assets/constantes.dart' as constantes;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: constantes.SUPABASE_URL,
    anonKey: constantes.SUPABASE_ANNON_KEY,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: MiTema().tema(),
      home: const Wrapper(),
    );
  }
}
