import 'package:college_notees/screens/form/atividade/atividade.dart';
import 'package:college_notees/screens/form/disciplina/disciplina.dart';

import 'package:college_notees/screens/home/home_mobile.dart';
import 'package:college_notees/screens/profile/profile.dart';
import 'package:college_notees/theme/app_theme.dart';
import 'package:flutter/material.dart';

class BuildNavigationBar extends StatefulWidget {
  const BuildNavigationBar({super.key});

  @override
  State<BuildNavigationBar> createState() => _BuildNavigationBarState();
}

class _BuildNavigationBarState extends State<BuildNavigationBar> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            icon: ImageIcon(
              const AssetImage("lib/assets/img/home.png"),
              color: AppTheme.colors.dark,
            ),
            label: 'Início',
          ),
          NavigationDestination(
            icon: ImageIcon(
              const AssetImage("lib/assets/img/book.png"),
              color: AppTheme.colors.dark,
            ),
            label: 'Disciplina',
          ),
          NavigationDestination(
            icon: ImageIcon(
              const AssetImage("lib/assets/img/assignment.png"),
              color: AppTheme.colors.dark,
            ),
            label: 'Atividade',
          ),
          NavigationDestination(
            icon: ImageIcon(
              const AssetImage("lib/assets/img/account.png"),
              color: AppTheme.colors.dark,
            ),
            label: 'Perfil',
          ),
        ],
      ),
      body: IndexedStack(index: currentPageIndex, children: <Widget>[
        const HomeMobile(),
        const Disciplina(),
        Atividade(
            disciplinasPage: () => setState(() {
                  currentPageIndex = 1;
                })),
        const Profile()
      ]),
    );
  }
}
