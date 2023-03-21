import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_notees/arguments/arguments.dart';
import 'package:college_notees/firebase/collection_ref.dart';
import 'package:college_notees/services/auth_service.dart';
import 'package:college_notees/theme/app_theme.dart';
import 'package:college_notees/widgets/reauthenticate_box.dart';
import 'package:college_notees/widgets/utils.dart';
import 'package:college_notees/widgets/validation.dart';
import 'package:college_notees/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);
    return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream:
                  FirebaseCollection.usersRef.doc(auth.userId()).snapshots(),
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
        ));
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
  final TextEditingController _userProvidedPassword = TextEditingController();
  final _formPasswordKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: AppTheme.colors.light,
            backgroundImage: const AssetImage('lib/assets/img/user.png'),
          ),
          Utils.addVerticalSpace(30),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Informações Básicas',
                style: AppTheme.typo.bold(18, AppTheme.colors.dark, 1.5, 1)),
          ),
          Utils.addVerticalSpace(10),
          Options(
              title: 'Foto:',
              titleContent: 'Selecionar uma foto',
              onTap: () {},
              editImage: true,
              isLogoutOption: false,
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
              isLogoutOption: false,
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
              isLogoutOption: false,
              isDeleteAccountOption: false),
          Utils.addVerticalSpace(30),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Mais opções',
                style: AppTheme.typo.bold(18, AppTheme.colors.dark, 1.5, 1)),
          ),
          Utils.addVerticalSpace(10),
          Options(
              title: 'Sair',
              titleContent: 'Desconectar sua conta do College Notees',
              onTap: () => logout(auth),
              editImage: false,
              isLogoutOption: true,
              isDeleteAccountOption: false),
          Options(
              title: 'Deletar:',
              titleContent: 'Excluir sua conta do College Notees',
              onTap: () => popupBox(context, 'Deletar conta', () {
                    if (_formPasswordKey.currentState!.validate()) {
                      auth.reauthenticateUser(
                          _userProvidedPassword.text,
                          context,
                          () =>
                              confirmBox(context, auth.userId(), auth.usuario));
                      _userProvidedPassword.clear();
                    }
                  }, widget.email, _userProvidedPassword, _formPasswordKey),
              editImage: false,
              isLogoutOption: false,
              isDeleteAccountOption: true),
        ],
      ),
    );
  }

  Future<void> logout(AuthService auth) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Sair',
            style: AppTheme.typo.medium(18, AppTheme.colors.dark, 1, 1),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Desejas sair da sua conta?',
                  textAlign: TextAlign.start,
                  style:
                      AppTheme.typo.regular(15, AppTheme.colors.dark, 1.5, 1),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCELAR'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('SAIR'),
              onPressed: () {
                Navigator.of(context).pop();
                auth.logout();
              },
            ),
          ],
        );
      },
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
    final activity = await FirebaseCollection.atividadeRef
        .where("userId", isEqualTo: userId)
        .get();

    final disciplina = await FirebaseCollection.disciplinasRef
        .where("userId", isEqualTo: userId)
        .get();

    final user =
        await FirebaseCollection.usersRef.where("_id", isEqualTo: userId).get();

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
