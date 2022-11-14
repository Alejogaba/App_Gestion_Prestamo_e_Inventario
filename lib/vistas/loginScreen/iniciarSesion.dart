import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:app_gestion_prestamo_inventario/servicios/auth.dart';
import 'package:app_gestion_prestamo_inventario/vistas/CommonWidgets/loading.dart';
import 'package:app_gestion_prestamo_inventario/vistas/home/principalAdmin.dart';
import 'package:app_gestion_prestamo_inventario/vistas/home/principalUsuarios.dart';
import '../CommonWidgets/customTextField.dart';
import '../../assets/constantes.dart' as constantes;

class IniciarSesion extends StatefulWidget {
  const IniciarSesion([Key? key]) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _IniciarSesionState createState() => _IniciarSesionState();
}

class _IniciarSesionState extends State<IniciarSesion> {
  List<String> credenciales = [];
  bool loading = true;
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  String error = '';

  //final AuthService _auth = AuthService();

  @override
  void initState() {
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    var scafold = Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        backgroundColor: Colors.green[600],
        title: const Text('Inicio de sesión'),
        /* actions: <Widget>[
          TextButton.icon(
            style: TextButton.styleFrom(primary: Colors.black),
            icon: Icon(Icons.person),
            label: Text('Registro'),
            onPressed: () => {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => Registro()))
            },
          ),
        ],*/
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                const SizedBox(height: 50.0),
                Image.asset('images/flutter.png'),
                const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                ),
                CustomTextField(
                  customController: usernameController,
                  labelText: "Nombre de usuario",
                  isPassword: false,
                ),
                CustomTextField(
                  customController: passwordController,
                  labelText: "Contraseña",
                  isPassword: true,
                ),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                            if (states.contains(MaterialState.disabled)) {
                              return Colors.red;
                            }
                            return Colors.green[600]!;
                          }),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      side: const BorderSide(
                                          color: Colors.lightGreen)))),
                      onPressed: () {
                        inicioSesion(
                            context, usernameController, passwordController);
                      },
                      child: const Text(
                        "Iniciar sesión",
                        style: TextStyle(fontSize: 25),
                      )),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: FittedBox(
                      fit: BoxFit.contain,
                      child:
                          null /*TextButton(
                      child: (Text("Iniciar sesión como usuario anonimo",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.green,
                              fontSize: 15,
                              fontWeight: FontWeight.bold))),
                      onPressed: () {
                        inicioSesionAnonimo(context);
                      },
                    ),*/
                      ),
                ),
                const SizedBox(height: 20.0),
                Text(
                  error,
                  style: const TextStyle(color: Colors.red, fontSize: 14.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    return loading ? scafold : const Loading();
  }

  inicioSesion(BuildContext context, TextEditingController controladorNombre,
      TextEditingController controladorContrasena) async {
    loading = false;
    AuthService authService = AuthService();
    dynamic resultado = await authService.inicioSesionUarioContrasena(
        controladorNombre.text, controladorContrasena.text);
    log('Funcion iniciar sesion');

    if (controladorNombre.text.isEmpty || controladorNombre.text.isEmpty) {
      log("No deje campos vacios");
      setState(() {
        loading = true;
        error = "No deje campos vacios";
      });
    } else {
      if (controladorNombre.text.contains(' ') ||
          controladorContrasena.text.contains(' ')) {
        log("No ingrese espacios en blanco");
        setState(() {
          loading = true;
          error = "No ingrese espacios en blanco";
        });
      } else {
        if (resultado.toString().contains("Error")) {
          log("No se pudo iniciar sesión");
          setState(() {
            cajaAdvertencia(context, resultado.toString());
            loading = true;
            error = "No se pudo iniciar sesión";
          });
        } else {
          log(authService.usuarioDeFirebase(resultado)!.uid);
          if (authService.usuarioDeFirebase(resultado)!.uid ==
              constantes.ADMIN_UID) {
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => PrincipalAdmin()));
          } else {
            log("No es administrador");
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => PrincipalUsuarios()));
          }
        }
      }
    }
  }
/*
  inicioSesionAnonimo(BuildContext context) async {
    AuthService authService = new AuthService();
    dynamic resultado = await authService.inicioSesionAnonimo();
    print('Funcion iniciar sesion anonimo');
    print(authService.usuarioDeFirebase(resultado).uid);

    if (resultado == null) {
      print("No se pudo iniciar sesión");
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => Principal()));
    }
  */

  cajaAdvertencia(BuildContext context, String msg) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(children: [
            Image.network(
              'https://www.lineex.es/wp-content/uploads/2018/06/alert-icon-red-11-1.png',
              width: 50,
              height: 50,
              fit: BoxFit.contain,
            ),
            const Text('  Advertencia ')
          ]),
          content: Text(msg),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.grey),
              child: const Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
