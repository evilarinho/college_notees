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
          title: Text(title),
          content: SizedBox(
            height: 200,
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
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Utils.addVerticalSpace(15),
                  const Text(
                      'Para continuar, primeiro confirme sua identidade'),
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
              child: const Text('CANCELAR'),
            ),
            TextButton(
              onPressed: onPressed,
              child: const Text('PROSSEGUIR'),
            )
          ],
        );
      });
}
