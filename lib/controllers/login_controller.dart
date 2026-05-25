import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vinta_financas/models/usuario_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
        email: email.trim(),
        password: senha,
      );

      User? usuarioFirebase = credencial.user;

      if (usuarioFirebase != null) {

        Usuario novoUsuario = Usuario(
          id: usuarioFirebase.uid,
          nome: nome,
          email: email.trim(),
        );

        await _firestore
          .collection('usuarios')
          .doc(usuarioFirebase.uid)
          .set(novoUsuario.toMap());

        return null;

      }

      return 'Erro inesperado: O utilizador não foi retornado pelo servidor.';

    } on FirebaseAuthException catch (e) {

      if (e.code == 'weak-password') {

        return 'A senha é muito fraca.';

      } else if (e.code == 'email-already-in-use') {

        return 'O e-mail já está em uso.';

      }

      return 'Erro de autenticação: ${e.message}';
      
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
        email: email.trim(),
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

      await GoogleSignIn.instance.signOut(); 
      
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

  String? obterEmailUsuario() {
    return _auth.currentUser?.email;
  }

  Future<String?> atualizarSenha(String senhaAntiga, String senhaNova) async {
    try {

      User? usuario = _auth.currentUser;

      if (usuario != null && usuario.email != null) {

        AuthCredential credencial = EmailAuthProvider.credential(
          email: usuario.email!,
          password: senhaAntiga,
        );
        await usuario.reauthenticateWithCredential(credencial);
        
        await usuario.updatePassword(senhaNova);
        return null;

      }
      return 'Nenhum utilizador logado.';

    } on FirebaseAuthException catch (e) {

      if (e.code == 'wrong-password' || e.code == 'invalid-credential') return 'A senha antiga está incorreta.';

      return 'Erro: ${e.message}';

    }
  }

  Future<String?> excluirConta(String senhaAtual) async {

    try {

      User? usuario = _auth.currentUser;

      if (usuario != null && usuario.email != null) {

        AuthCredential credencial = EmailAuthProvider.credential(
          email: usuario.email!,
          password: senhaAtual,
        );
        await usuario.reauthenticateWithCredential(credencial);
        
        await _firestore.collection('usuarios').doc(usuario.uid).delete();
        
        await usuario.delete();
        return null;

      }
      return 'Nenhum utilizador logado.';

    } on FirebaseAuthException catch (e) {

      if (e.code == 'wrong-password' || e.code == 'invalid-credential') return 'A senha está incorreta.';
      return 'Erro ao excluir: ${e.message}';
      
    }
  }

  Future<String?> loginComGoogle() async {
    
    try {

      final googleSignIn = GoogleSignIn.instance;

      try {
        await googleSignIn.initialize();
      } catch (_) {}

      final GoogleSignInAccount? googleUser = await googleSignIn.authenticate();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credencial = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      UserCredential userCred = await _auth.signInWithCredential(credencial);
      User? usuarioFirebase = userCred.user;

      if (usuarioFirebase != null && userCred.additionalUserInfo?.isNewUser == true) {

        Usuario novoUsuario = Usuario(
          id: usuarioFirebase.uid,
          nome: usuarioFirebase.displayName ?? 'Usuário Google',
          email: usuarioFirebase.email!,
        );

        await _firestore
          .collection('usuarios')
          .doc(usuarioFirebase.uid)
          .set(novoUsuario.toMap());

      }

      return null;
    
    } catch (e) {

      return 'Erro ao fazer login com Google: $e';

    }
  }

}
