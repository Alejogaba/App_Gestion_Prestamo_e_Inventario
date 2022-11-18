// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:app_gestion_prestamo_inventario/flutter_flow/flutter_flow_util.dart';
import 'package:desktop_webview_auth/google.dart';
import 'package:flutter/material.dart';
import 'package:app_gestion_prestamo_inventario/servicios/auth.dart';
import 'package:app_gestion_prestamo_inventario/vistas/CommonWidgets/loading.dart';
import 'package:app_gestion_prestamo_inventario/vistas/home/principalAdmin.dart';
import 'package:app_gestion_prestamo_inventario/vistas/home/principalUsuarios.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import '../CommonWidgets/animated_error_widget.dart';
import '../CommonWidgets/customTextField.dart';
import '../../assets/constantes.dart' as constantes;
import 'package:desktop_webview_auth/desktop_webview_auth.dart';

class IniciarSesion extends StatefulWidget {
  const IniciarSesion([Key? key]) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _IniciarSesionState createState() => _IniciarSesionState();
}

class _IniciarSesionState extends State<IniciarSesion> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;
  void setIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  void resetError() {
    if (error.isNotEmpty) {
      setState(() {
        error = '';
      });
    }
  }

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
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: SizedBox(
                      width: 400,
                      child: Form(
                        key: formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedError(text: error, show: error.isNotEmpty),
                            const SizedBox(height: 20),
                            const SizedBox(height: 20),
                            const SizedBox(height: 20),
                            ...AppOAuthProvider.values.map((provider) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: SignInButton(
                                    provider.button,
                                    onPressed: () {
                                      if (!isLoading) {
                                        switch (provider) {
                                          case AppOAuthProvider.google:
                                            _googleSignIn();
                                            break;
                                        }
                                      }
                                    },
                                  ),
                                ),
                              );
                            }).toList(),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: isLoading
                      ? Container(
                          color: Colors.black.withOpacity(0.8),
                          child: const Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                        )
                      : const SizedBox(),
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

  Future<void> _googleSignIn() async {}

  inicioSesion(BuildContext context, TextEditingController controladorNombre,
      TextEditingController controladorContrasena) async {
    loading = false;
    AuthService authService = AuthService();
    dynamic resultado = await authService.inicioSesionUarioContrasena(context,
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
        

        // ignore: use_build_context_synchronously
       
        context.go( 'principal',extra: <String,dynamic>{
          // ignore: prefer_const_constructors
          kTransitionInfoKey:TransitionInfo(
          hasTransition:true,
          transitionType:PageTransitionType.rightToLeft,),
                                                                        },
                                                                      );
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PrincipalAdmin()));
          
          
        }
      }
    }
  }

  registro(BuildContext context, TextEditingController controladorNombre,
      TextEditingController controladorContrasena) async {
    loading = false;
    AuthService authService = AuthService();
    authService.registroUsuarioContrasena(context, controladorNombre.text, controladorContrasena.text);
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
