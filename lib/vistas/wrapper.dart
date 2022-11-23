import 'dart:developer';

import 'package:app_gestion_prestamo_inventario/vistas/login_page/login_page_widget.dart';
import 'package:app_gestion_prestamo_inventario/vistas/principal/principal_widget.dart';
import 'package:flutter/material.dart';
import 'package:app_gestion_prestamo_inventario/entidades/usuario.dart';
import '../../assets/constantes.dart' as constantes;
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final usuario = Provider.of<Usuario?>(context);

    //retorna ya sea el widget de autenticar o el de inicio
    log("Wrapper usuario uid: ${usuario?.uid}");
    if (usuario?.uid == constantes.ADMIN_UID) {
      return const PrincipalWidget();
    } else if (usuario != null) {
      return const PrincipalWidget();
    } else {
      return const PrincipalWidget();
    }
  }
}
