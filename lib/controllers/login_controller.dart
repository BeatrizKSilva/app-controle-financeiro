class LoginController {
  String? validarEmail(String? value) {
    if (value!.isEmpty) {
      return 'Por favor, digite o e-mai';
    }
    if (value.length < 5 || !value.contains('@') || !value.contains('.')) {
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
}
