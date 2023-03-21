import 'package:college_notees/theme/app_theme.dart';
import 'package:flutter/material.dart';

class LoginTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final int maxLength;
  final String labelText;
  final String hint;
  final bool seePassword;
  final FormFieldValidator validator;

  const LoginTextFormField({
    super.key,
    required this.controller,
    required this.maxLength,
    required this.labelText,
    required this.hint,
    required this.validator,
    required this.seePassword,
  });

  @override
  State<LoginTextFormField> createState() => _LoginTextFormFieldState();
}

class _LoginTextFormFieldState extends State<LoginTextFormField> {
  late bool _habilitaVerSenha;
  late bool _verSenha;

  @override
  void initState() {
    super.initState();
    _habilitaVerSenha = widget.seePassword;
    _verSenha = widget.seePassword;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextFormField(
          obscureText: _verSenha,
          controller: widget.controller,
          maxLength: widget.maxLength,
          decoration: selectedDecoration(widget.labelText, widget.hint),
          validator: widget.validator),
    );
  }

  InputDecoration selectedDecoration(String label, String hint) {
    return InputDecoration(
      alignLabelWithHint: true,
      labelText: label,
      hintText: hint,
      suffixIcon: _habilitaVerSenha
          ? (_verSenha
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      //Quando o usuário clicar nesse ícone, ele mudará para falso
                      debugPrint('Você está vendo a sua senha');
                      _verSenha = false;
                    });
                  },
                  icon: const Icon(Icons.lock_outline_rounded))
              : IconButton(
                  onPressed: () {
                    setState(() {
                      //Quando o usuário clicar nesse ícone, ele mudará para verdadeiro
                      debugPrint('Você não está vendo a sua senha');
                      _verSenha = true;
                    });
                  },
                  icon: const Icon(Icons.lock_open_rounded)))
          : null,
      contentPadding:
          const EdgeInsets.only(right: 20, top: 20, bottom: 20, left: 20),
      labelStyle: AppTheme.typo.defaultBoldText,
      prefixIconConstraints: const BoxConstraints(minWidth: 50),
      prefixStyle: TextStyle(color: AppTheme.colors.black),
      errorStyle: const TextStyle(
          fontSize: 13, letterSpacing: 0, fontWeight: FontWeight.w500),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppTheme.colors.blue, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(50))),
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppTheme.colors.red, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(50))),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppTheme.colors.blue, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(50))),
      focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppTheme.colors.red, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(50))),
    );
  }
}

class EditorTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final int maxLength;
  final int maxLines;
  final String labelText;
  final String hintText;
  final Icon fieldIcon;
  final bool readOnly;
  final bool validateField;
  final FormFieldValidator validator;
  final VoidCallback? action;

  const EditorTextFormField(
      {super.key,
      required this.controller,
      required this.maxLength,
      required this.validator,
      required this.labelText,
      required this.hintText,
      required this.maxLines,
      required this.fieldIcon,
      required this.readOnly,
      this.action,
      required this.validateField});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
          decoration: selectedDecoration(),
          onTap: action,
          controller: controller,
          maxLength: maxLength,
          maxLines: maxLines,
          readOnly: readOnly,
          validator: validateField ? validator : null),
    );
  }

  InputDecoration selectedDecoration() {
    return InputDecoration(
      alignLabelWithHint: true,
      labelText: labelText,
      hintText: hintText,
      helperText: hintText,
      icon: fieldIcon,
      contentPadding:
          const EdgeInsets.only(right: 20, top: 20, bottom: 20, left: 20),
      labelStyle: AppTheme.typo.defaultBoldText,
      prefixIconConstraints: const BoxConstraints(minWidth: 50),
      prefixStyle: TextStyle(color: AppTheme.colors.dark),
      errorStyle: const TextStyle(
          fontSize: 13, letterSpacing: 0, fontWeight: FontWeight.w500),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppTheme.colors.blue, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppTheme.colors.red, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppTheme.colors.blue, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppTheme.colors.red, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(5))),
    );
  }
}
