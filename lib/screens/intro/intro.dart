import 'package:college_notees/responsive/responsive.dart';
import 'package:college_notees/screens/intro/intro_desktop.dart';
import 'package:college_notees/screens/intro/intro_mobile.dart';
import 'package:college_notees/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key, required String userId});

  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);

    return Responsive(
        mobile: IntroMobile(
          userId: auth.userId(),
        ),
        desktop: IntroDesktop(
          userId: auth.userId(),
        ));
  }
}
