import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_notees/components/empty_state_ui.dart';
import 'package:college_notees/firebase/collection_ref.dart';
import 'package:college_notees/screens/form/widgets/buttons.dart';
import 'package:college_notees/services/auth_service.dart';
import 'package:college_notees/theme/app_theme.dart';
import 'package:college_notees/widgets/disciplina_card.dart';
import 'package:college_notees/widgets/stream_builder.dart';
import 'package:college_notees/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Disciplina extends StatefulWidget {
  const Disciplina({super.key});

  @override
  State<Disciplina> createState() => _DisciplinaState();
}

class _DisciplinaState extends State<Disciplina> {
  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);
    final size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          (size.width > 430)
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Suas disciplinas',
                      textAlign: TextAlign.start,
                      style:
                          AppTheme.typo.medium(18, AppTheme.colors.dark, 1, 1),
                    ),
                    const DisciplinaButton(),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Suas disciplinas',
                      textAlign: TextAlign.start,
                      style:
                          AppTheme.typo.medium(18, AppTheme.colors.dark, 1, 1),
                    ),
                    Utils.addVerticalSpace(20),
                    const DisciplinaButton()
                  ],
                ),
          Utils.addVerticalSpace(20),
          Expanded(
            child: StreamBuilderData(
                stream: FirebaseCollection.disciplinasRef
                    .where('userId', isEqualTo: auth.userId())
                    .orderBy('nome', descending: false)
                    .snapshots(),
                widget: (snapshot) {
                  return ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                    var generatedColor =
                        Random().nextInt(Utils.backgroundColors.length);

                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return BuildDisciplinaCard(
                      disciplina: data['nome'],
                      userId: data['userId'],
                      docRef: document.reference,
                      backgroundColor:
                          Utils.backgroundColors[generatedColor].primary,
                      iconColor:
                          Utils.backgroundColors[generatedColor].secondary,
                      tutor: data['tutor'],
                    );
                  }).toList());
                },
                emptyStateUi: EmptyStateUi(
                    title: 'Sem disciplinas',
                    subtitle: 'Você ainda não cadastrou nenhuma disciplina. ',
                    titleStyle:
                        AppTheme.typo.bold(15, AppTheme.colors.dark, 1, 1),
                    subtitleStyle: AppTheme.typo
                        .regular(13, AppTheme.colors.dark, 1.5, 1))),
          )
        ],
      ),
    );
  }
}
