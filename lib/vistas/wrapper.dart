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
    if (usuario?.uid == "gHMt8BxVC3hmLWiil5B9JAs4bfH2")
      return PrincipalAdmin();
    else if (usuario != null) {
      return PrincipalUsuarios();
    } else {
      return IniciarSesion();
    }
  }
}
