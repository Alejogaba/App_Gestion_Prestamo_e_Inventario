import 'dart:developer';
import 'package:desktop_webview_auth/desktop_webview_auth.dart';
import 'package:desktop_webview_auth/google.dart';
import 'package:app_gestion_prestamo_inventario/entidades/usuario.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import '../../assets/constantes.dart' as constantes;

const _redirectUri = 'https://accounts.google.com/o/oauth2/auth';
const _googleClientId =
    '199131897060-0p2gu71h9ap9avuecpp6bj7bspo4icqp.apps.googleusercontent.com';


enum AppOAuthProvider { google }

extension Button on AppOAuthProvider {
  Buttons get button {
    switch (this) {
      case AppOAuthProvider.google:
        return Buttons.Google;
    }
  }
}

class AuthService {
  final client = SupabaseClient(constantes.SUPABASE_URL, constantes.SUPABASE_ANNON_KEY);

  //retorna un usuario con atributos personalizados basado en un objeto FirebaseUser
  Usuario? usuarioDeFirebase(User? usuario) {
    return (usuario != null) ? Usuario('Anonimo', ' ', usuario.id) : null;
  }

//Stream con mapeo de usuario
  String? get usuarioID {
    return client.auth.currentUser?.id;
  }

//Registrarse con usuario y contraseña
  Future<void> registroUsuarioContrasena(context, String correo, String contrasena) async {
    debugPrint("email:$correo password:$contrasena");
    final result =
        await client.auth.signUp(email: correo, password: contrasena, emailRedirectTo:
            kIsWeb ? null : 'io.supabase.flutterquickstart://login-callback/');

    debugPrint(result.toString());

    if (result.user != null) {
      log('Registration Success');
    } else {
      log('Error al registrar');
    }
  }

//inicio de sesion con email y contraseña
  Future<User?> inicioSesionUarioContrasena(context, String email, String? password) async {
    debugPrint("email:$email password:$password");
    final result = await client.auth
        .signInWithPassword(email: email, password: password!);
    debugPrint(result.session?.toJson().toString());

    if (result.session != null) {
      log('Login Success');
      return result.user;
    } else {
      return null;
    }
  }

//Cerrar sesión
  Future cerrarSesion() async {
    try {
      await client.auth.signOut();
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
