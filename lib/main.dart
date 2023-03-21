import 'package:college_notees/college_notees.dart';
import 'package:college_notees/config.dart';
import 'package:college_notees/services/auth_service.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  //Arquivo de configuração
  await initConfigurations();

  setPathUrlStrategy();

  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (context) => AuthService())],
    child: const CollegeNotees(),
  ));
}
