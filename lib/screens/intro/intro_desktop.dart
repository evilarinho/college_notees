import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_notees/responsive/responsive.dart';
import 'package:college_notees/screens/intro/methods.dart';
import 'package:college_notees/theme/app_theme.dart';
import 'package:college_notees/widgets/stream_builder.dart';
import 'package:college_notees/widgets/utils.dart';
import 'package:college_notees/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroDesktop extends StatefulWidget {
  final String userId;

  const IntroDesktop({super.key, required this.userId});

  @override
  State<IntroDesktop> createState() => _IntroDesktopState();
}

class _IntroDesktopState extends State<IntroDesktop> {
  final controller = PageController(initialPage: 0);
  final _disciplinasBasicasRef =
      FirebaseFirestore.instance.collection('DISCIPLINAS_BASICAS').snapshots();
  List<String> selectedDisciplinaList = [];
//Faz referência a coleção DISCIPLINAS no Firebase
  final disciplinasRef = FirebaseFirestore.instance.collection('DISCIPLINAS');
  //Faz referência a coleção de usuário no Firebase
  final usersRef = FirebaseFirestore.instance.collection('USUARIOS');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: [_firstPage(), _secondPage()],
      ),
    );
  }

  Widget _firstPage() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppTheme.colors.blue),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Olá estudante, seja bem vindo \n ao College Notees!',
            textAlign: TextAlign.center,
            style: AppTheme.typo.regular(20, AppTheme.colors.white, 1.5, 1),
          ),
          SizedBox(
              width: Responsive.isDesktop(context) ? 500 : 410,
              child:
                  Lottie.asset("lib/assets/lottie/student-transparent.json")),
          SizedBox(
            width: 500,
            child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    style: AppTheme.typo
                        .regular(16, AppTheme.colors.white, 1.5, 1.5),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'College Notees ',
                        style: AppTheme.typo
                            .bold(16, AppTheme.colors.white, 1.5, 1.5),
                      ),
                      const TextSpan(
                          text:
                              'é um aplicativo destinado aos estudantes que visam organizar suas atividades escolares, buscando melhorar sua produtividade.'),
                    ])),
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                  onPressed: () => controller.nextPage(
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeInOut),
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                      backgroundColor: AppTheme.colors.dark),
                  child: Text(
                    'Prosseguir',
                    textAlign: TextAlign.start,
                    style: AppTheme.typo.bold(16, AppTheme.colors.white, 0, 1),
                  )))
        ],
      ),
    );
  }

  Widget _secondPage() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppTheme.colors.light),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: () => addDisciplinasLater(
                  userId: widget.userId, usersRef: usersRef),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(16),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                backgroundColor: const Color(0xffCFD8DC),
                disabledForegroundColor: Colors.grey.withOpacity(0.38),
              ),
              child: Text(
                textAlign: TextAlign.center,
                'Deseja cadastrar depois?',
                style: AppTheme.typo.bold(16, AppTheme.colors.blue, 0, 1),
              ),
            ),
          ),
          Utils.addVerticalSpace(30),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Comesse sua experiencia selecionando as disciplinas básicas',
                textAlign: TextAlign.start,
                style: AppTheme.typo.medium(18, AppTheme.colors.dark, 0, 1),
              ),
              if (selectedDisciplinaList.length < 3) ...[
                Utils.addVerticalSpace(15),
                Text(
                  'Selecione pelo menos 3 disciplinas.',
                  textAlign: TextAlign.center,
                  style: AppTheme.typo.medium(15, AppTheme.colors.red, 0, 1),
                ),
              ],
              Utils.addVerticalSpace(25),
              StreamBuilderData(
                stream: _disciplinasBasicasRef,
                widget: (snapshot) => MultiSelectChip(
                  disciplinaList: snapshot.data!.docs,
                  onSelectionChanged: (selectedList) {
                    setState(() {
                      selectedDisciplinaList = selectedList;
                    });
                  },
                ),
                emptyStateUi: const Text('sem dados'),
              ),
            ],
          ),
          Utils.addSpace(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: () => controller.previousPage(
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeInOut),
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                      backgroundColor: AppTheme.colors.dark),
                  child: Text(
                    'Voltar',
                    textAlign: TextAlign.start,
                    style: AppTheme.typo.bold(16, AppTheme.colors.white, 0, 1),
                  )),
              ElevatedButton(
                  onPressed: selectedDisciplinaList.length < 3
                      ? null
                      : () => addDisciplinas(
                          userId: widget.userId,
                          disciplinaList: selectedDisciplinaList,
                          usersRef: usersRef,
                          disciplinasRef: disciplinasRef),
                  style: ElevatedButton.styleFrom(
                      disabledBackgroundColor: Colors.grey.withOpacity(0.6),
                      padding: const EdgeInsets.all(20),
                      backgroundColor: AppTheme.colors.blue),
                  child: Text(
                    'Cadastrar',
                    textAlign: TextAlign.start,
                    style: AppTheme.typo.bold(16, AppTheme.colors.white, 0, 1),
                  ))
            ],
          )
        ],
      ),
    );
  }
}
