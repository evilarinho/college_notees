import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_notees/arguments/arguments.dart';
import 'package:college_notees/services/auth_service.dart';
import 'package:college_notees/theme/app_theme.dart';
import 'package:college_notees/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class DrawerNavigation extends StatefulWidget {
  const DrawerNavigation({super.key});

  @override
  State<DrawerNavigation> createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  String userName = '';

  final drawerTitle = const TextStyle(
      fontFamily: "Inter",
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Color(0xffffffff));

  userFirstName(userId) {
    FirebaseFirestore.instance
        .collection('USUARIOS')
        .doc(userId)
        .get()
        .then((DocumentSnapshot value) {
      final name = value.get('nome');

      //Separa cada palavra do nome do usuário
      final splitName = name.split(" ");
      setState(() {
        userName = splitName[0];
      });
    });

    return userName;
  }

  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);
    return Drawer(
      backgroundColor: AppTheme.colors.light,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            padding: const EdgeInsets.all(50),
            decoration: BoxDecoration(
              color: AppTheme.colors.dark,
            ),
            child: Center(
                child: Text(
              'Olá ${userFirstName(auth.userId())}, seja bem-vindo!',
              textAlign: TextAlign.center,
              style: drawerTitle,
            )),
          ),
          ListTileOptions(
              icone: Icons.home_outlined,
              title: 'Página Inicial',
              onTap: () => GoRouter.of(context).push('/home')),
          ListTileOptions(
              icone: Icons.assignment_outlined,
              title: 'Nova Atividade',
              onTap: () => GoRouter.of(context)
                  .push('/form', extra: ActivityArguments(isEditing: false))),
          ListTileOptions(
              icone: Icons.account_circle_outlined,
              title: 'Meu Perfil',
              onTap: () =>
                  GoRouter.of(context).push('/profile/${auth.userId()}')),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Divider(
              color: AppTheme.colors.dark,
              height: 10,
              thickness: 1,
            ),
          ),
          ListTileOptions(
              icone: Icons.logout_rounded,
              title: 'Sair',
              onTap: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Sair'),
                        content: const Text(
                            'Tem certeza que deseja desconectar sua conta desse aplicativo?'),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              debugPrint('O usuário saiu do app');
                              Navigator.of(context).pop();

                              auth.logout();
                              GoRouter.of(context).push('/');
                            },
                            child: const Text('SIM'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('CANCELAR'),
                          ),
                        ],
                      );
                    });
              }),
        ],
      ),
    );
  }
}
