import 'package:flutter/material.dart';
import 'package:app_gestion_prestamo_inventario/entidades/usuario.dart';
import 'package:app_gestion_prestamo_inventario/servicios/auth.dart';
import 'package:app_gestion_prestamo_inventario/vistas/CommonWidgets/themeData.dart';
import 'package:app_gestion_prestamo_inventario/vistas/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Usuario?>.value(
      value: AuthService().usuario,
      initialData: null,
      child: MaterialApp(
        theme: MiTema().tema(),
        home: const Wrapper(),
      ),
    );
  }
}
