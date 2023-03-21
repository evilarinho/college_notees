import 'package:college_notees/theme/app_theme.dart';
import 'package:college_notees/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/assets/img/404.png',
                width: 312,
                height: 312,
              ),
              Utils.addVerticalSpace(30),
              Text(
                'Página não encontrada',
                textAlign: TextAlign.center,
                style: AppTheme.typo.title,
              ),
              Utils.addVerticalSpace(15),
              const Text(
                'Desculpe, não foi possível encontrar a página solicitada por você. Por favor, retorne para a página inicial.',
                textAlign: TextAlign.center,
              ),
              Utils.addVerticalSpace(40),
              OutlinedButton.icon(
                onPressed: () => context.go('/'),
                icon: const Icon(Icons.add),
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    side: BorderSide(width: 1, color: AppTheme.colors.dark)),
                label: Text(
                  'Página Inicial',
                  textAlign: TextAlign.center,
                  style: AppTheme.typo.button,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
