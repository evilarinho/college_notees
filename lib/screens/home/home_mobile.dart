import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_notees/components/empty_state_ui.dart';
import 'package:college_notees/components/filtro.dart';
import 'package:college_notees/services/auth_service.dart';
import 'package:college_notees/theme/app_theme.dart';
import 'package:college_notees/widgets/atividade_card.dart';
import 'package:college_notees/widgets/stream_builder.dart';
import 'package:college_notees/widgets/user_first_name.dart';
import 'package:college_notees/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class HomeMobile extends StatefulWidget {
  const HomeMobile({super.key});

  @override
  State<HomeMobile> createState() => _HomeMobileState();
}

class _HomeMobileState extends State<HomeMobile> {
  final atividadeRef = FirebaseFirestore.instance.collection('ATIVIDADES');
  final userRef = FirebaseFirestore.instance.collection('USUARIOS');

  String selectedDisciplina = "";

  late Stream<QuerySnapshot> stream;
  late String title;
  late String subtitle;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);

    if (selectedDisciplina == "") {
      stream = atividadeRef
          .where("userId", isEqualTo: auth.userId())
          .orderBy("disciplina", descending: false)
          .snapshots();
      title = "Sem disciplinas";
      subtitle = "Você não possui nenhuma disciplina cadastrada";
    } else {
      stream = atividadeRef
          .where("userId", isEqualTo: auth.userId())
          .where("disciplina", isEqualTo: selectedDisciplina)
          .snapshots();
      title = "Resultado não encontrado";
      subtitle =
          "Não foi possível encontrar nenhuma atividade de $selectedDisciplina";
    }

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: UserName(userRef: userRef.doc(auth.userId()).get())),
            ),
            Utils.addVerticalSpace(8),
            Align(
              alignment: Alignment.topLeft,
              child: Text('Verifique todas as suas atividades escolares aqui.',
                  textAlign: TextAlign.start,
                  style:
                      AppTheme.typo.regular(15, AppTheme.colors.dark, 1.5, 1)),
            ),
            Utils.addVerticalSpace(30),
            FilterField(
                userId: auth.userId(),
                currencyValue: (currencyValue) {
                  setState(() {
                    selectedDisciplina = currencyValue;
                  });
                }),
            if (selectedDisciplina.isNotEmpty) ...[
              Utils.addVerticalSpace(8),
              Align(
                alignment: Alignment.topLeft,
                child: InputChip(
                  label: Text(selectedDisciplina),
                  onDeleted: () {
                    setState(() {
                      selectedDisciplina = "";
                    });
                  },
                ),
              ),
            ],
            Utils.addVerticalSpace(20),
            StreamBuilderData(
              stream: stream,
              emptyStateUi: EmptyStateUi(
                  title: title,
                  subtitle: subtitle,
                  titleStyle:
                      AppTheme.typo.bold(15, AppTheme.colors.dark, 1, 1),
                  subtitleStyle:
                      AppTheme.typo.regular(13, AppTheme.colors.dark, 1.5, 1)),
              widget: (snapshot) => ListView(
                  shrinkWrap: true,
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    var generatedColor =
                        Random().nextInt(Utils.backgroundColors.length);

                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return BuildAtividadeCard(
                      disciplina: data["disciplina"],
                      title: data["titulo"],
                      date: data["data_entrega"],
                      description: data["descricao"],
                      docRef: document.reference,
                      userId: data["userId"],
                      backgroundColor:
                          Utils.backgroundColors[generatedColor].primary,
                      chipColor:
                          Utils.backgroundColors[generatedColor].secondary,
                    );
                  }).toList()),
            ),
          ],
        ),
      ),
    );
  }
}
