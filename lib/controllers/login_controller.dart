import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vinta_financas/models/usuario_model.dart';

class LoginController {
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? validarEmail(String? value) {
    String emailTratado = value!.trim();

    if (emailTratado.isEmpty) {
      return 'Por favor, digite o e-mail';
    }
    if (emailTratado.length < 5 ||
        !emailTratado.contains('@') ||
        !emailTratado.contains('.')) {
      return 'E-mail inválido';
    }
    return null;
  }

  String? validarSenha(String? value) {
    if (value!.isEmpty) {
      return 'Por favor digite a senha';
    }
    if (value.length < 6) {
      return 'A senha deve conter no mínimo 6 caracteres';
    }
    return null;
  }

  Future<String?>registrarUsuario({
    
    required String nome,
    required String email,
    required String senha,    

  }) async {
    try {

      UserCredential credencial = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      User? usuarioFirebase = credencial.user;

      if (usuarioFirebase != null) {

        Usuario novoUsuario = Usuario(
          id: usuarioFirebase.uid,
          nome: nome,
          email: email,
        );

        await _firestore
          .collection('usuarios')
          .doc(usuarioFirebase.uid)
          .set(novoUsuario.toMap());

        return null;

      }
    } on FirebaseAuthException catch (e) {

      if (e.code == 'weak-password') {

        return 'A senha é muito fraca.';

      } else if (e.code == 'email-already-in-use') {

        return 'O e-mail já está em uso.';

      }
    } catch (e) {

      return 'Erro desconhecido ao criar a conta.';

    }
  }

  Future<String?> fazerLogin({
    required String email,
    required String senha,
  }) async {

    try {

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
        );

        return null;
    
    } on FirebaseAuthException catch (e) {

      if (e.code == 'user-not-found') {

        return 'Usuario não encontrado.';

      } else if (e.code == 'wrong-password') {

        return 'senha incorreta.';

      } else if (e.code == 'invalid-email') {

        return 'E-mail inválido.';

      } else if (e.code == 'user-disabled') {

        return 'Este usuário foi desabilitado.';

      }
      return 'Erro ao entrar: ${e.message}';

    } catch (e) {

      return 'Erro desconhecido ao entrar.';

    }
  }

  Future<void> fazerLogout() async {

    try {
      await _auth.signOut();
    
    } catch (e) {

      print('Erro ao fazer logout: $e');

    }

  }

  Future<String?> recuperarSenha(String email) async {

    try {

      if (email.trim().isEmpty) {
        return 'Por favor, digite o seu e-mail para recuperar a senha.';
      }

      await _auth.sendPasswordResetEmail(email: email.trim());

      return null;

    } on FirebaseAuthException catch (e) {

      if (e.code == 'user-not-found') {

        return 'Não encontrámos nenhuma conta associada a este e-mail.';
        
      } if (e.code == 'invalid-email') {

        return 'O e-mail fornecido não é válido.';

      }
      return 'Erro ao pedir recuperação: ${e.message}';

    } catch (e) {

      return 'Erro inesperado ao tentar recuperar senha: $e';

    }

  }

}
