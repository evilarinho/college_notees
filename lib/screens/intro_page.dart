import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_notees/theme/app_theme.dart';
import 'package:college_notees/widgets/utils.dart';
import 'package:college_notees/widgets/widgets.dart';
import 'package:flutter/material.dart';

class IntroPage extends StatefulWidget {
  final String userId;

  const IntroPage({
    super.key,
    required this.userId,
  });

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final introText = const TextStyle(
      color: Color(0xffeeeeee),
      fontFamily: "Inter",
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.5);

  TextStyle boldText(double size, Color color) {
    return TextStyle(
        color: color,
        fontFamily: "Inter",
        fontSize: size,
        fontWeight: FontWeight.bold,
        letterSpacing: 0,
        height: 1.5);
  }

  //String? _disciplinaSelecionada = "";
  List<String> selectedDisciplinaList = [];

  final _disciplinasBasicasStream =
      FirebaseFirestore.instance.collection('DISCIPLINAS_BASICAS').snapshots();

  //Faz referência a coleção DISCIPLINAS no Firebase
  final disciplinasRef = FirebaseFirestore.instance.collection('DISCIPLINAS');
  //Faz referência a coleção de usuário no Firebase
  final usersRef = FirebaseFirestore.instance.collection('USUARIOS');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth < 900) {
            return smallScreen(constraints.maxWidth);
          } else {
            return largeScreen(constraints.maxWidth / 2, constraints.maxHeight);
          }
        },
      ),
    );
  }

  Widget smallScreen(width) {
    return SingleChildScrollView(child: containerSmallScreen(width));
  }

  Widget largeScreen(width, height) {
    return SingleChildScrollView(
      child: Row(
        children: [
          containerLargeScreen1(width, height),
          containerLargeScreen2(width, height)
        ],
      ),
    );
  }

  containerSmallScreen(width) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.colors.light,
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Column(
                children: [
                  Container(
                    height: 300,
                    width: width,
                    decoration: BoxDecoration(
                      color: AppTheme.colors.blue,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Text(
                          'Olá estudante, seja bem vindo \n ao College Notees!',
                          textAlign: TextAlign.center,
                          style: boldText(22, AppTheme.colors.light)),
                    ),
                  ),
                  Container(
                    height: 150,
                    width: width,
                    decoration: BoxDecoration(
                      color: AppTheme.colors.light,
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 150,
                child: Image.asset(
                  'lib/assets/img/brain.png',
                  width: 270,
                  height: 270,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                    'Comesse sua experiencia selecionando as disciplinas básicas',
                    textAlign: TextAlign.center,
                    style: boldText(17, AppTheme.colors.dark)),
                Utils.addVerticalSpace(15),
                TextButton(
                  onPressed: addDisciplinasLater,
                  child: Text(
                    textAlign: TextAlign.center,
                    'Deseja cadastrar depois?',
                    style: AppTheme.typo.button,
                  ),
                ),
                if (selectedDisciplinaList.length < 3) ...[
                  Utils.addVerticalSpace(15),
                  Text('Selecione pelo menos 3 disciplinas.',
                      textAlign: TextAlign.center,
                      style: boldText(13, AppTheme.colors.red)),
                ],
                Utils.addVerticalSpace(25),
                StreamBuilder(
                    stream: _disciplinasBasicasStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Center(child: Text('Algo deu errado!'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return MultiSelectChip(
                        disciplinaList: snapshot.data!.docs,
                        onSelectionChanged: (selectedList) {
                          setState(() {
                            selectedDisciplinaList = selectedList;
                          });
                        },
                      );
                    }),
                Utils.addVerticalSpace(50),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.only(top: 22, bottom: 22),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                      onPressed: selectedDisciplinaList.length < 3
                          ? null
                          : () => addDisciplinas,
                      child: Text(
                        'Prosseguir',
                        textAlign: TextAlign.center,
                        style: AppTheme.typo.button,
                      )),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  containerLargeScreen1(width, height) {
    return Container(
      padding: const EdgeInsets.only(top: 50, bottom: 50),
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.colors.blue,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Olá estudante, seja bem vindo \n ao College Notees!',
              textAlign: TextAlign.center,
              style: boldText(25, AppTheme.colors.light)),
          Utils.addSpace(),
          Image.asset(
            'lib/assets/img/brain.png',
            width: 370,
            height: 370,
          ),
          Utils.addSpace(),
          RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: 'College Notees ',
                    style: boldText(16, AppTheme.colors.light)),
                TextSpan(
                    style: introText,
                    text:
                        'é um aplicativo destinado aos \n estudantes que visam organizar suas atividades \n escolares, buscando melhorar sua produtividade.'),
              ]))
        ],
      ),
    );
  }

  containerLargeScreen2(width, height) {
    return Container(
      padding: const EdgeInsets.all(50),
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.colors.light,
      ),
      child: Column(children: [
        Align(
          alignment: Alignment.topRight,
          child: TextButton(
            onPressed: addDisciplinasLater,
            child: Text(
              'Deseja cadastrar depois?',
              style: AppTheme.typo.button,
            ),
          ),
        ),
        Utils.addSpace(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Comesse sua experiencia selecionando as disciplinas básicas',
                textAlign: TextAlign.left,
                style: boldText(16, AppTheme.colors.dark)),
            if (selectedDisciplinaList.length < 3) ...[
              Utils.addVerticalSpace(15),
              Text('Selecione pelo menos 3 disciplinas.',
                  textAlign: TextAlign.left,
                  style: boldText(13, AppTheme.colors.red)),
            ],
            Utils.addVerticalSpace(25),
            StreamBuilder(
                stream: _disciplinasBasicasStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Algo deu errado!'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return MultiSelectChip(
                    disciplinaList: snapshot.data!.docs,
                    onSelectionChanged: (selectedList) {
                      setState(() {
                        selectedDisciplinaList = selectedList;
                      });
                    },
                  );
                }),
          ],
        ),
        Utils.addSpace(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.only(top: 22, bottom: 22),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0))),
              onPressed:
                  selectedDisciplinaList.length < 3 ? null : addDisciplinas,
              child: Text(
                'Prosseguir',
                textAlign: TextAlign.center,
                style: AppTheme.typo.button,
              )),
        )
      ]),
    );
  }

  addDisciplinas() async {
    //Adiciona as disciplinas selecionadas pelo novo usuário
    for (var value in selectedDisciplinaList) {
      await disciplinasRef
          .add({"userId": widget.userId, "nome": value})
          .then((value) => debugPrint("Disciplina adicionada"))
          .catchError((error) => debugPrint(
              "Falha ao adicionar as disciplinas do usuário: $error"));
    }
    //Atualiza o status do usuário como não sendo um novo usuário
    await usersRef.doc(widget.userId).update({"novo_usuario": false});
  }

  addDisciplinasLater() async {
    //Atualiza o status do usuário como não sendo um novo usuário
    await usersRef.doc(widget.userId).update({"novo_usuario": false});
  }
}
