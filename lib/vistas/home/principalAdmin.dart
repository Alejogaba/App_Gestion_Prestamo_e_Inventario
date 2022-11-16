import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrincipalAdmin extends StatefulWidget {
  const PrincipalAdmin({Key? key}) : super(key: key);

  @override
  _PrincipalAdminState createState() => _PrincipalAdminState();
}

class _PrincipalAdminState extends State<PrincipalAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Principal Admin'),
      ),
      body: Container(),
    );
  }
}
