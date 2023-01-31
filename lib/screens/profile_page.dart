import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_notees/arguments/arguments.dart';
import 'package:college_notees/services/auth_service.dart';
import 'package:college_notees/theme/app_theme.dart';
import 'package:college_notees/widgets/drawer_navigation.dart';
import 'package:college_notees/widgets/reauthenticate_box.dart';
import 'package:college_notees/widgets/utils.dart';
import 'package:college_notees/widgets/validation.dart';
import 'package:college_notees/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final String userId;

  const ProfilePage({super.key, required this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meu Perfil', style: AppTheme.typo.appBar),
      ),
      drawer: const DrawerNavigation(),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('USUARIOS')
                    .doc(widget.userId)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final userInfo = snapshot.data!;
                  return BuildUserPage(
                      name: userInfo['nome'],
                      email: userInfo['email'],
                      photo: userInfo['photo_url'],
                      docId: userInfo['_id']);
                },
              )
            ],
          )),
    );
  }
}

class BuildUserPage extends StatefulWidget {
  final String name;
  final String email;
  final String photo;
  final String docId;

  const BuildUserPage(
      {super.key,
      required this.name,
      required this.email,
      required this.photo,
      required this.docId});

  @override
  State<BuildUserPage> createState() => _BuildUserPageState();
}

class _BuildUserPageState extends State<BuildUserPage> {
  final title = const TextStyle(
      fontFamily: "Inter",
      fontSize: 18,
      fontWeight: FontWeight.bold,
      letterSpacing: 0);

  final TextEditingController _userProvidedPassword = TextEditingController();
  final _formPasswordKey = GlobalKey<FormState>();

  //Faz referência a coleção DISCIPLINAS no Firebase
  final activityRef = FirebaseFirestore.instance.collection('ATIVIDADES');

  //Faz referência a coleção DISCIPLINAS no Firebase
  final disciplinasRef = FirebaseFirestore.instance.collection('DISCIPLINAS');

  //Faz referência a coleção DISCIPLINAS no Firebase
  final userRef = FirebaseFirestore.instance.collection('USUARIOS');

  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: AppTheme.colors.light,
          backgroundImage: const AssetImage('lib/assets/img/user.png'),
        ),
        Utils.addVerticalSpace(30),
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Informações Básicas', style: title),
        ),
        Utils.addVerticalSpace(10),
        Options(
            title: 'Foto:',
            titleContent: 'Selecionar uma foto',
            onTap: () {},
            editImage: true,
            isDeleteAccountOption: false),
        Options(
            title: 'Nome:',
            titleContent: widget.name,
            onTap: () => GoRouter.of(context).push(
                '/profile/${widget.docId}/edit/nome',
                extra: EditInfoUserArguments(
                    'Nome',
                    widget.name,
                    'Nome',
                    'Informe o seu nome',
                    FormValidation.validateField(),
                    widget.docId,
                    'nome')),
            editImage: false,
            isDeleteAccountOption: false),
        Options(
            title: 'E-mail:',
            titleContent: widget.email,
            onTap: () => popupBox(context, 'Atualizar E-mail', () {
                  if (_formPasswordKey.currentState!.validate()) {
                    auth.reauthenticateUser(
                        _userProvidedPassword.text,
                        context,
                        () => GoRouter.of(context).push(
                            '/profile/${widget.docId}/edit/email',
                            extra: EditInfoUserArguments(
                                'E-mail',
                                widget.email,
                                'E-mail',
                                'Informe o seu novo email',
                                FormValidation.validateEmail(),
                                widget.docId,
                                'email')));
                    _userProvidedPassword.clear();
                  }
                }, widget.email, _userProvidedPassword, _formPasswordKey),
            editImage: false,
            isDeleteAccountOption: false),
        Utils.addVerticalSpace(30),
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Mais opções', style: title),
        ),
        Utils.addVerticalSpace(10),
        Options(
            title: 'Deletar:',
            titleContent: 'Excluir sua conta do College Notees',
            onTap: () => popupBox(context, 'Deletar conta', () {
                  if (_formPasswordKey.currentState!.validate()) {
                    auth.reauthenticateUser(_userProvidedPassword.text, context,
                        () => confirmBox(context, auth.userId(), auth.usuario));
                    _userProvidedPassword.clear();
                  }
                }, widget.email, _userProvidedPassword, _formPasswordKey),
            editImage: false,
            isDeleteAccountOption: true),
      ],
    );
  }

  confirmBox(BuildContext context, String userId, User? usuario) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Confirmação',
              textAlign: TextAlign.start,
            ),
            content: const Text('Tem certeza que deseja excluir sua conta?'),
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
                onPressed: () => deleteAccount(context, userId, usuario),
                child: const Text('DELETAR'),
              )
            ],
          );
        });
  }

  deleteAccount(BuildContext context, String userId, User? usuario) async {
    //Referências das coleções do banco de dados
    final activity = await activityRef.where("userId", isEqualTo: userId).get();

    final disciplina =
        await disciplinasRef.where("userId", isEqualTo: userId).get();

    final user = await userRef.where("_id", isEqualTo: userId).get();

    //Deletando os dados do usuário
    for (var activityDocs in activity.docs) {
      activityDocs.reference.delete();
    }

    for (var disciplinaDocs in disciplina.docs) {
      disciplinaDocs.reference.delete();
    }

    for (var userDocs in user.docs) {
      userDocs.reference.delete();
    }

    // ignore: use_build_context_synchronously
    GoRouter.of(context).push("/");

    //Deletando a conta do usuário
    await usuario!.delete();
  }
}
