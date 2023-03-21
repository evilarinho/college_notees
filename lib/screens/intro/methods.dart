import 'package:flutter/material.dart';

addDisciplinas(
    {required userId,
    required disciplinaList,
    required usersRef,
    required disciplinasRef}) async {
  //Adiciona as disciplinas selecionadas pelo novo usuário
  for (var value in disciplinaList) {
    await disciplinasRef
        .add({"userId": userId, "nome": value})
        .then((value) => debugPrint("Disciplina adicionada"))
        .catchError((error) =>
            debugPrint("Falha ao adicionar as disciplinas do usuário: $error"));
  }
  //Atualiza o status do usuário como não sendo um novo usuário
  await usersRef.doc(userId).update({"novo_usuario": false});
}

addDisciplinasLater({required userId, required usersRef}) async {
  //Atualiza o status do usuário como não sendo um novo usuário
  await usersRef.doc(userId).update({"novo_usuario": false});
}
