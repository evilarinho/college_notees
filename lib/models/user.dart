class Usuario {
  Usuario(
      {required this.id,
      required this.email,
      required this.nome,
      required this.isNewUser});

  Usuario.fromJson(Map<String, Object?> json)
      : this(
          id: json['_id']! as String,
          email: json['email']! as String,
          nome: json['nome']! as String,
          isNewUser: json['novo_usuario']! as bool,
        );

  final String id;
  final String email;
  final String nome;
  final bool isNewUser;

  Map<String, Object?> toJson() {
    return {
      '_id': id,
      'email': email,
      'nome': nome,
      'novo_usuario': isNewUser,
    };
  }
}
