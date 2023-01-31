import 'package:college_notees/arguments/arguments.dart';
import 'package:college_notees/theme/app_theme.dart';
import 'package:college_notees/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmptyStateUi extends StatelessWidget {
  const EmptyStateUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/assets/img/empty-box.png',
                width: 312,
                height: 312,
              ),
              Utils.addVerticalSpace(25),
              Text(
                'Sem disciplinas',
                style: AppTheme.typo.title,
                textAlign: TextAlign.center,
              ),
              Utils.addVerticalSpace(10),
              Text(
                'Comesse cadastrando suas disciplinas escolares',
                textAlign: TextAlign.center,
                style: AppTheme.typo.homeText,
              ),
              Utils.addVerticalSpace(40),
              OutlinedButton.icon(
                onPressed: () => GoRouter.of(context)
                    .push('/form', extra: ActivityArguments(isEditing: false)),
                icon: const Icon(Icons.add),
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    side: BorderSide(width: 1, color: AppTheme.colors.dark)),
                label: Text(
                  'Adicionar minhas disciplinas',
                  textAlign: TextAlign.center,
                  style: AppTheme.typo.button,
                ),
              )
            ]),
      ),
    );
  }
}
