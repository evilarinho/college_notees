import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_notees/arguments/arguments.dart';

import 'package:college_notees/theme/app_theme.dart';
import 'package:college_notees/widgets/card_list.dart';
import 'package:college_notees/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ActivityList extends StatefulWidget {
  final String? title;
  final String? userId;

  const ActivityList({super.key, required this.title, required this.userId});

  @override
  State<ActivityList> createState() => _ActivityListState();
}

class _ActivityListState extends State<ActivityList> {
  //Faz referência a coleção DISCIPLINAS no Firebase
  final activityRef = FirebaseFirestore.instance.collection('ATIVIDADES');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              IconButton(
                  onPressed: () => GoRouter.of(context).push("/home"),
                  icon: const Icon(Icons.arrow_back_outlined)),
              Utils.addHorizontalSpace(20),
              Text(
                'Atividades de ${widget.title}',
                textAlign: TextAlign.left,
                style: AppTheme.typo.appBar,
              )
            ],
          )),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                  stream: activityRef
                      .where('userId', isEqualTo: widget.userId)
                      .where('disciplina', isEqualTo: widget.title)
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
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: data.size,
                        itemBuilder: (BuildContext context, int index) {
                          final title = data.docs[index]['titulo'];
                          final content = data.docs[index]['conteudo'];
                          final date = data.docs[index]['data_entrega'];
                          final disciplina = data.docs[index]['disciplina'];
                          final document = data.docs[index];

                          return CardList(
                            title: title,
                            delete: () => deleteActivity(context, document),
                            edit: () => GoRouter.of(context).push('/form',
                                extra: ActivityArguments(
                                    isEditing: true,
                                    title: title,
                                    content: content,
                                    date: date,
                                    disciplina: disciplina,
                                    docRef: document)),
                            hasSubtitle: true,
                            subtitle: content,
                            icon: const AssetImage(
                                "lib/assets/img/assignment.png"),
                          );
                        });
                  }),
            ],
          )),
    );
  }

  Future<void> deleteActivity(BuildContext context, DocumentSnapshot document) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Deletar'),
            content: const Text(
              'Esta ação excluirá esta atividade.',
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
                  await document.reference.delete();
                },
                child: const Text('PROSSEGUIR'),
              )
            ],
          );
        });
  }
}
