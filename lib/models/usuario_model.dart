class Usuario {
  String id; 
  String nome;
  String email;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'email': email,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map, String documentId) {
    return Usuario(
      id: documentId,
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
    );
  }
}