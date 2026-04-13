import 'package:vinta_financas/repositories/user_mock.dart';

class LoginController {
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

  bool fazerLoginMock(String email, String senha) {
    if (email == UserMock.email && senha == UserMock.senha) {
      return true;
    } else {
      return false;
    }
  }
}
