import 'package:college_notees/theme/app_theme.dart';
import 'package:college_notees/widgets/utils.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';

class EmptyStateUi extends StatelessWidget {
  final String title;
  final TextStyle titleStyle;
  final TextStyle subtitleStyle;
  final String subtitle;

  const EmptyStateUi(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.titleStyle,
      required this.subtitleStyle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset("lib/assets/lottie/search-not-found.json"),
                Utils.addVerticalSpace(10),
                Text(
                  "Animação de Mohamed Aksham",
                  style: AppTheme.typo.medium(12, Colors.black26, 1, 1),
                )
              ],
            ),
            Utils.addVerticalSpace(25),
            Text(
              title,
              textAlign: TextAlign.center,
              style: titleStyle,
            ),
            Utils.addVerticalSpace(10),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: subtitleStyle,
            ),
          ]),
    );
  }
}
