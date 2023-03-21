import 'package:college_notees/theme/colors.dart';
import 'package:college_notees/theme/typo.dart';
import 'package:flutter/material.dart';

@immutable
class AppTheme {
  static const colors = AppColors();
  static const typo = AppTypo();

  const AppTheme._();

  static ThemeData define() {
    return ThemeData(
      fontFamily: "Inter",
      scaffoldBackgroundColor: AppTheme.colors.light,
      inputDecorationTheme: InputDecorationTheme(
        prefixIconColor: colors.greyText,
      ),
      colorScheme: ThemeData()
          .colorScheme
          .copyWith(primary: colors.blue, error: colors.red)
          .copyWith(error: colors.red),
    );
  }
}
