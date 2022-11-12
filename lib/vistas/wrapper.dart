import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:app_gestion_prestamo_inventario/entidades/usuario.dart';
import 'package:app_gestion_prestamo_inventario/vistas/loginScreen/iniciarSesion.dart';
import 'package:app_gestion_prestamo_inventario/vistas/home/principalAdmin.dart';
import 'package:app_gestion_prestamo_inventario/vistas/home/principalUsuarios.dart';

import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final usuario = Provider.of<Usuario?>(context);

    //retorna ya sea el widget de autenticar o el de inicio
    log("Wrapper usuario uid: ${usuario?.uid}");
    if (usuario?.uid == "tksNiNUEgUQYcca3PYkQWjADnv53") {
      return const PrincipalAdmin();
    } else if (usuario != null) {
      return const PrincipalUsuarios();
    } else {
      return const IniciarSesion();
    }
  }
}
