import 'dart:developer';
import 'package:desktop_webview_auth/desktop_webview_auth.dart';
import 'package:desktop_webview_auth/google.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_gestion_prestamo_inventario/entidades/usuario.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

const _redirectUri = 'https://accounts.google.com/o/oauth2/auth';
const _googleClientId = '199131897060-0p2gu71h9ap9avuecpp6bj7bspo4icqp.apps.googleusercontent.com';

enum AppOAuthProvider {
  google
}

extension Button on AppOAuthProvider {
  Buttons get button {
    switch (this) {
      case AppOAuthProvider.google:
        return Buttons.Google;
    }
  }
}

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

//retorna un usuario con atributos personalizados basado en un objeto FirebaseUser
  Usuario? usuarioDeFirebase(User? usuario) {
    return (usuario != null) ? Usuario('Anonimo', ' ', usuario.uid) : null;
  }

//Stream con mapeo de usuario
  Stream<Usuario?> get usuario {
    return _auth.authStateChanges().map(usuarioDeFirebase);
  }

//inicio de secion como usuario anonimo
  Future inicioSesionAnonimo() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return user;
    } on FirebaseAuthException catch (e) {
      log('Fallo con el código: ${e.code}');
      log(e.message.toString());
    }
  }

//inicio de sesion con email y contraseña
  Future inicioSesionUarioContrasena(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } on FirebaseAuthException catch (error) {
      log('Error: No se puede iniciar sesión: ${error.message}');
    }
  }

//inicio de sesion con Google
  Future<void> googleSignIn() async {
    String? accessToken;
    String? idToken;

    try {
      // Handle login by a third-party provider based on the platform.
      switch (defaultTargetPlatform) {
        case TargetPlatform.iOS:
        case TargetPlatform.android:
          break;
        case TargetPlatform.macOS:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
          {
            final result = await DesktopWebviewAuth.signIn(
              GoogleSignInArgs(
                clientId: _googleClientId,
                redirectUri: _redirectUri,
                scope: 'https://www.googleapis.com/auth/userinfo.email',
              ),
            );

            idToken = result?.idToken;
            accessToken = result?.accessToken;
          }
          break;
        default:
      }

      if (accessToken != null && idToken != null) {
        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          idToken: idToken,
          accessToken: accessToken,
        );

        // Once signed in, return the UserCredential
        await _auth.signInWithCredential(credential);
      } else {
        return;
      }
    } on FirebaseAuthException catch (_) {
      rethrow;
    }
  }

//Registrarse con usuario y contraseña
  Future registroConUsuarioyContrasena(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return usuarioDeFirebase(result.user);
    } on FirebaseException catch (error) {
      log('Error al crear el usuario: ${error.message}');
    }
  }

//Cerrar sesión
  Future cerrarSesion() async {
    try {
      return _auth.signOut();
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
