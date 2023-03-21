import 'package:college_notees/screens/form/atividade/atividade.dart';

import 'package:college_notees/screens/form/disciplina/disciplina.dart';
import 'package:college_notees/screens/home/home_desktop.dart';
import 'package:college_notees/screens/profile/profile.dart';
import 'package:college_notees/theme/app_theme.dart';
import 'package:flutter/material.dart';

class BuildNavigationRail extends StatefulWidget {
  const BuildNavigationRail({super.key});

  @override
  State<BuildNavigationRail> createState() => _BuildNavigationRailState();
}

class _BuildNavigationRailState extends State<BuildNavigationRail> {
  var selectedIndex = 0;
  late Widget page;

  @override
  void initState() {
    super.initState();
    setNavigationPage(0);
  }

  setNavigationPage(index) {
    setState(() {
      selectedIndex = index;
    });
    switch (selectedIndex) {
      case 0:
        page = const HomeDesktop();
        break;
      case 1:
        page = const Disciplina();

        break;
      case 2:
        page = Atividade(
            disciplinasPage: () => setState(() {
                  selectedIndex = 1;
                }));
        break;
      case 3:
        page = const Profile();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 1000,
                backgroundColor: AppTheme.colors.white, // ← Here.
                destinations: [
                  NavigationRailDestination(
                    icon: ImageIcon(
                      const AssetImage("lib/assets/img/home.png"),
                      color: AppTheme.colors.dark,
                    ),
                    label: const Text('Início'),
                  ),
                  NavigationRailDestination(
                    icon: ImageIcon(
                      const AssetImage("lib/assets/img/book.png"),
                      color: AppTheme.colors.dark,
                    ),
                    label: const Text('Disciplina'),
                  ),
                  NavigationRailDestination(
                    icon: ImageIcon(
                      const AssetImage("lib/assets/img/assignment.png"),
                      color: AppTheme.colors.dark,
                    ),
                    label: const Text('Atividade'),
                  ),
                  NavigationRailDestination(
                    icon: ImageIcon(
                      const AssetImage("lib/assets/img/account.png"),
                      color: AppTheme.colors.dark,
                    ),
                    label: const Text('Perfil'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) => setNavigationPage(value),
              ),
            ),
            Expanded(
              child: page,
            ),
          ],
        ),
      );
    });
  }
}
