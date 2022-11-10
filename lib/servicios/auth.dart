import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_gestion_prestamo_inventario/entidades/usuario.dart';

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
