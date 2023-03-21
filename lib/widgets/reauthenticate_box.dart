import 'package:college_notees/components/editor.dart';
import 'package:college_notees/theme/app_theme.dart';
import 'package:college_notees/widgets/utils.dart';
import 'package:college_notees/widgets/validation.dart';
import 'package:flutter/material.dart';

Future<void> popupBox(BuildContext context, String title, Function() onPressed,
    String label, TextEditingController controller, GlobalKey formKey) {
  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            textAlign: TextAlign.start,
            style: AppTheme.typo.bold(16, AppTheme.colors.dark, 1.5, 1),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Chip(
                    avatar: Icon(
                      Icons.account_circle_outlined,
                      color: AppTheme.colors.dark,
                    ),
                    backgroundColor: AppTheme.colors.lightBlue,
                    label: Text(
                      label,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Utils.addVerticalSpace(15),
                  Text(
                    'Para continuar, primeiro confirme sua identidade',
                    textAlign: TextAlign.start,
                    style:
                        AppTheme.typo.regular(16, AppTheme.colors.dark, 1.5, 1),
                  ),
                  Utils.addVerticalSpace(16),
                  LoginTextFormField(
                      controller: controller,
                      maxLength: 20,
                      labelText: 'Senha',
                      hint: 'Digite sua senha',
                      validator: FormValidation.validateField(),
                      seePassword: true)
                ],
              ),
            ),
          ),
          backgroundColor: AppTheme.colors.light,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'CANCELAR',
                style: AppTheme.typo.medium(15, AppTheme.colors.blue, 1.5, 1),
              ),
            ),
            TextButton(
              onPressed: onPressed,
              child: Text(
                'PROSSEGUIR',
                style: AppTheme.typo.medium(15, AppTheme.colors.blue, 1.5, 1),
              ),
            )
          ],
        );
      });
}
