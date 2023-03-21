import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_notees/screens/intro/methods.dart';
import 'package:college_notees/theme/app_theme.dart';
import 'package:college_notees/widgets/stream_builder.dart';
import 'package:college_notees/widgets/utils.dart';
import 'package:college_notees/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroMobile extends StatefulWidget {
  final String userId;

  const IntroMobile({super.key, required this.userId});

  @override
  State<IntroMobile> createState() => _IntroMobileState();
}

class _IntroMobileState extends State<IntroMobile> {
  final controller = PageController();
  int paginaAtual = 0;

  final _disciplinasBasicasRef =
      FirebaseFirestore.instance.collection('DISCIPLINAS_BASICAS').snapshots();
  List<String> selectedDisciplinaList = [];
//Faz referência a coleção DISCIPLINAS no Firebase
  final disciplinasRef = FirebaseFirestore.instance.collection('DISCIPLINAS');
  //Faz referência a coleção de usuário no Firebase
  final usersRef = FirebaseFirestore.instance.collection('USUARIOS');

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  setPaginaAtual(pagina) {
    setState(() {
      paginaAtual = pagina;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: controller,
          onPageChanged: setPaginaAtual,
          children: [_firstPage(), _secondPage()],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
                onPressed: () => addDisciplinasLater(
                    userId: widget.userId, usersRef: usersRef),
                child: Text(
                  "Pular",
                  style: AppTheme.typo.bold(16, AppTheme.colors.dark, 0, 0),
                )),
            SmoothPageIndicator(
              controller: controller,
              count: 2,
              effect: WormEffect(
                  spacing: 16,
                  dotColor: Colors.black26,
                  activeDotColor: AppTheme.colors.blue),
              onDotClicked: (index) => controller.animateToPage(index,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOut),
            ),
            (paginaAtual == 0)
                ? TextButton(
                    onPressed: () => controller.nextPage(
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeInOut),
                    child: Text(
                      "Prosseguir",
                      style: AppTheme.typo.bold(16, AppTheme.colors.dark, 0, 0),
                    ))
                : TextButton(
                    onPressed: selectedDisciplinaList.length < 3
                        ? null
                        : () => addDisciplinas(
                            userId: widget.userId,
                            disciplinaList: selectedDisciplinaList,
                            usersRef: usersRef,
                            disciplinasRef: disciplinasRef),
                    style: TextButton.styleFrom(
                        disabledBackgroundColor: Colors.grey.withOpacity(0.6),
                        padding: const EdgeInsets.all(20),
                        backgroundColor: AppTheme.colors.blue),
                    child: Text(
                      "Cadastrar",
                      style: AppTheme.typo.bold(16, AppTheme.colors.dark, 0, 0),
                    ))
          ],
        ),
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
            style: AppTheme.typo.regular(16, AppTheme.colors.white, 1.5, 1),
          ),
          SizedBox(
              width: 350,
              child:
                  Lottie.asset("lib/assets/lottie/student-transparent.json")),
          SizedBox(
            width: 500,
            child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    style: AppTheme.typo
                        .regular(14, AppTheme.colors.white, 1.5, 1.5),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'College Notees ',
                        style: AppTheme.typo
                            .bold(14, AppTheme.colors.white, 1.5, 1.5),
                      ),
                      const TextSpan(
                          text:
                              'é um aplicativo destinado aos estudantes que visam organizar suas atividades escolares, buscando melhorar sua produtividade.'),
                    ])),
          ),
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Comesse sua experiencia selecionando as disciplinas básicas',
            textAlign: TextAlign.start,
            style: AppTheme.typo.medium(16, AppTheme.colors.dark, 0, 1),
          ),
          if (selectedDisciplinaList.length < 3) ...[
            Utils.addVerticalSpace(15),
            Text(
              'Selecione pelo menos 3 disciplinas.',
              textAlign: TextAlign.center,
              style: AppTheme.typo.medium(13, AppTheme.colors.red, 0, 1),
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
    );
  }
}
