import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_notees/components/editor.dart';
import 'package:college_notees/responsive/responsive.dart';
import 'package:college_notees/services/auth_service.dart';
import 'package:college_notees/theme/app_theme.dart';
import 'package:college_notees/widgets/card_list.dart';
import 'package:college_notees/widgets/utils.dart';
import 'package:college_notees/widgets/validation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DisciplinaForm extends StatefulWidget {
  const DisciplinaForm({super.key});

  @override
  State<DisciplinaForm> createState() => _DisciplinaFormState();
}

class _DisciplinaFormState extends State<DisciplinaForm> {
  final TextEditingController _disciplinaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isEditing = false;
  late DocumentSnapshot docRef;
  final List<String> _listDisciplina = [];
  String oldDisciplina = '';

  //Faz referência a coleção DISCIPLINAS no Firebase
  final disciplinasRef = FirebaseFirestore.instance.collection('DISCIPLINAS');

  //Faz referência a coleção DISCIPLINAS no Firebase
  final activityRef = FirebaseFirestore.instance.collection('ATIVIDADES');

  final titleCard = const TextStyle(
      color: Color(0xff232320),
      fontFamily: "Inter",
      fontSize: 16,
      fontWeight: FontWeight.bold,
      letterSpacing: 0);

  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    EditorTextFormField(
                        controller: _disciplinaController,
                        maxLength: 30,
                        maxLines: 1,
                        readOnly: false,
                        fieldIcon: const Icon(Icons.title_rounded),
                        validator: FormValidation.validateField(),
                        labelText: 'Disciplina',
                        hintText: 'Informe o nome da sua disciplina'),
                  ],
                )),
            Utils.addVerticalSpace(20),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (isEditing) {
                      //Atualiza a disciplina
                      docRef.reference
                          .update({"nome": _disciplinaController.text.trim()});

                      //Chama a função que irá atualizar a atividade com o nome da disciplina nova
                      editActivityDisciplina(
                          auth.userId(), _disciplinaController.text.trim());

                      setState(() {
                        isEditing = false;
                      });

                      debugPrint('Editou: $_listDisciplina');

                      //Limpa o formulário
                      _disciplinaController.clear();
                    } else {
                      // if (_listDisciplina
                      //     .contains(_disciplinaController.text.toLowerCase())) {
                      //   Utils.schowSnackBar(
                      //       'Essa disciplina já foi registrada!');

                      //   return;
                      // }
                      disciplinasRef.add({
                        "userId": auth.userId(),
                        "nome": _disciplinaController.text.trim()
                      });

                      debugPrint('Adicionou: $_listDisciplina');

                      //Limpa o formulário
                      _disciplinaController.clear();
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                    padding: Responsive.isMobile(context)
                        ? const EdgeInsets.all(15)
                        : const EdgeInsets.all(20)),
                child: Text(
                  'Salvar',
                  textAlign: TextAlign.center,
                  style: AppTheme.typo.button,
                )),
            Utils.addVerticalSpace(40),
            StreamBuilder<QuerySnapshot>(
                stream: disciplinasRef
                    .where('userId', isEqualTo: auth.userId())
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Algo deu errado!'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final data = snapshot.requireData;

                  for (var itens in snapshot.data!.docs) {
                    _listDisciplina.add(itens.get('nome').toLowerCase());
                  }

                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.size,
                      itemBuilder: (BuildContext context, int index) {
                        final nome = data.docs[index]['nome'];
                        final document = data.docs[index];

                        return CardList(
                          title: nome,
                          delete: () => deleteDisciplina(
                              context, document, auth.userId(), nome),
                          edit: () {
                            setState(() {
                              _disciplinaController.text = nome;
                              oldDisciplina = nome;
                              docRef = document;
                              isEditing = true;
                            });
                          },
                          hasSubtitle: false,
                          icon: const AssetImage("lib/assets/img/book.png"),
                        );
                      });
                }),
          ],
        ),
      ),
    );
  }

  Future<void> deleteDisciplina(BuildContext context, DocumentSnapshot document,
      String userId, String disciplina) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Deletar'),
            content: const Text(
              'Esta ação excluirá esta disciplina.',
              textAlign: TextAlign.center,
            ),
            backgroundColor: AppTheme.colors.light,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('CANCELAR'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  deleteActivityDisciplina(userId, disciplina);
                  await document.reference.delete();
                },
                child: const Text('PROSSEGUIR'),
              )
            ],
          );
        });
  }

  editActivityDisciplina(String userId, String newDisciplina) async {
    final activity = await activityRef
        .where('userId', isEqualTo: userId)
        .where('disciplina', isEqualTo: oldDisciplina)
        .get();

    for (var document in activity.docs) {
      document.reference.update({"disciplina": newDisciplina});
      debugPrint(document.id);
    }
  }

  deleteActivityDisciplina(String userId, String disciplina) async {
    final activity = await activityRef
        .where('userId', isEqualTo: userId)
        .where('disciplina', isEqualTo: disciplina)
        .get();

    for (var document in activity.docs) {
      document.reference.delete();
    }
  }
}
