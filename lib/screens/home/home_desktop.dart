import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_notees/components/empty_state_ui.dart';
import 'package:college_notees/components/filtro.dart';
import 'package:college_notees/services/auth_service.dart';
import 'package:college_notees/theme/app_theme.dart';
import 'package:college_notees/widgets/atividade_card.dart';
import 'package:college_notees/widgets/stream_builder.dart';
import 'package:college_notees/widgets/user_first_name.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/utils.dart';

class HomeDesktop extends StatefulWidget {
  const HomeDesktop({super.key});

  @override
  State<HomeDesktop> createState() => _HomeDesktopState();
}

class _HomeDesktopState extends State<HomeDesktop> {
  final atividadeRef = FirebaseFirestore.instance.collection('ATIVIDADES');
  final userRef = FirebaseFirestore.instance.collection('USUARIOS');
  String selectedDisciplina = "";

  late Stream<QuerySnapshot> stream;
  late String title;
  late String subtitle;

  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);
    double width = MediaQuery.of(context).size.width;

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

    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(30),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
            Align(
              alignment: Alignment.topRight,
              child: FilterField(
                  userId: auth.userId(),
                  currencyValue: (currencyValue) {
                    setState(() {
                      selectedDisciplina = currencyValue;
                    });
                  }),
            ),
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
              widget: (snapshot) => GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: (width > 1290)
                      ? 1.4
                      : (width > 1200 && width < 1290)
                          ? 1.3
                          : (width > 1070 && width < 1200)
                              ? 1
                              : (width > 860 && width < 1070)
                                  ? 0.95
                                  : (width > 750 && width < 860)
                                      ? 0.8
                                      : (width > 700 && width < 750)
                                          ? 0.71
                                          : (width > 650 && width < 700)
                                              ? 0.63
                                              : 0.59,
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
