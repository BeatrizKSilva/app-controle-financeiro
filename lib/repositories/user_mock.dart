class UserMock {
  static String email = "teste@gmail.com";
  static String senha = "123456";

  static void salvarNovoUsuario(String emailNovo, String senhaNova) {
    email = emailNovo;
    senha = senhaNova;
  }

  static bool verificarSenhaAntiga(String senhaDigitada) {
    return senhaDigitada == senha;
  }

  static void atualizarPerfil(String emailNovo, String senhaNova) {
    email = emailNovo;
    if (senhaNova.isEmpty) {
      senha = senhaNova;
    }
  }

  static void excluirConta() {
    email = "";
    senha = "";
  }
}
