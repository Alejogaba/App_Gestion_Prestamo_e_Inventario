import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrincipalUsuarios extends StatefulWidget {
  const PrincipalUsuarios({Key? key}) : super(key: key);

  @override
  _PrincipalUsuariosState createState() => _PrincipalUsuariosState();
}

class _PrincipalUsuariosState extends State<PrincipalUsuarios> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Principal Usuarios'),
      ),
      body: Container(),
    );
  }
}
