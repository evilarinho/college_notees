import 'package:college_notees/theme/app_theme.dart';
import 'package:flutter/material.dart';

class UserName extends StatelessWidget {
  final Future userRef;

  const UserName({super.key, required this.userRef});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: userRef,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Algo deu errado");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final name = snapshot.data!.get('nome');

          //Separa cada palavra do nome do usuário
          final firstName = name.split(" ")[0];

          return Text('Olá $firstName',
              textAlign: TextAlign.start,
              style: AppTheme.typo.medium(20, AppTheme.colors.dark, 1, 1));
        });
  }
}
