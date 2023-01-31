import 'package:college_notees/theme/app_theme.dart';
import 'package:college_notees/router/router.dart';
import 'package:college_notees/widgets/utils.dart';
import 'package:flutter/material.dart';

class CollegeNotees extends StatelessWidget {
  const CollegeNotees({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      scaffoldMessengerKey: Utils.messengerKey,
      theme: AppTheme.define(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      routerDelegate: routers.routerDelegate,
      routeInformationParser: routers.routeInformationParser,
      routeInformationProvider: routers.routeInformationProvider,
    );
  }
}
