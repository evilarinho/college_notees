import 'package:college_notees/components/editor.dart';
import 'package:college_notees/firebase/collection_ref.dart';
import 'package:college_notees/services/auth_service.dart';
import 'package:college_notees/theme/app_theme.dart';
import 'package:college_notees/widgets/utils.dart';
import 'package:college_notees/widgets/validation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AtividadeButtonMobile extends StatelessWidget {
  const AtividadeButtonMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _openAtividadeForm(isEditing: false),
      child: Icon(
        Icons.add_rounded,
        color: AppTheme.colors.light,
      ),
    );
  }
}

void _openAtividadeForm({required bool isEditing}) async {
  if (!isEditing) {
  } else {}
}

class DisciplinaButton extends StatelessWidget {
  const DisciplinaButton({super.key});

  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);
    return ElevatedButton.icon(
      onPressed: () => openFormDialog(
          context: context,
          isEditing: false,
          userId: auth.userId(),
          title: 'Cadastrar disciplinas'),
      icon: Icon(
        Icons.add_rounded,
        color: AppTheme.colors.light,
      ),
      label: Text('Nova disciplina',
          style: AppTheme.typo.medium(13, AppTheme.colors.light, 1, 1)),
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(13),
          backgroundColor: AppTheme.colors.blue),
    );
  }
}

Future<void> openFormDialog(
    {required BuildContext context,
    required bool isEditing,
    String? disciplina,
    String? tutor,
    String? docId,
    required String userId,
    required String title}) {
  final disciplinaController = TextEditingController();
  final tutorController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  isEditing
      ? disciplinaController.text = disciplina!
      : disciplinaController.text = '';
  isEditing ? tutorController.text = tutor! : tutorController.text = '';

  return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            textAlign: TextAlign.start,
            style: AppTheme.typo.medium(18, AppTheme.colors.dark, 1, 1),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: ListBody(
                children: [
                  EditorTextFormField(
                    controller: disciplinaController,
                    maxLength: 50,
                    validator: FormValidation.validateField(),
                    labelText: 'Disciplina',
                    hintText: 'Nome da disciplina',
                    maxLines: 1,
                    fieldIcon: const Icon(Icons.title_rounded),
                    readOnly: false,
                    validateField: true,
                  ),
                  EditorTextFormField(
                    controller: tutorController,
                    maxLength: 50,
                    validator: FormValidation.validateField(),
                    labelText: 'Tutor',
                    hintText: 'Nome do(a) tutor(a)/professor(a)',
                    maxLines: 1,
                    fieldIcon: const Icon(Icons.person_rounded),
                    readOnly: false,
                    validateField: false,
                  )
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('CANCELAR'),
            ),
            TextButton(
              onPressed: () => _openDisciplinaForm(
                  context: context,
                  isEditing: isEditing,
                  userId: userId,
                  docId: docId,
                  formKey: formKey,
                  disciplinaController: disciplinaController,
                  tutorController: tutorController),
              child: const Text('SALVAR'),
            )
          ],
        );
      });
}

void _openDisciplinaForm(
    {required BuildContext context,
    required bool isEditing,
    String? docId,
    required String userId,
    required GlobalKey<FormState> formKey,
    required TextEditingController disciplinaController,
    required TextEditingController tutorController}) async {
  if (formKey.currentState!.validate()) {
    //Verifica se o usuário irá editar ou criar uma disciplina
    if (!isEditing) {
      //Cadastrar disciplina
      await FirebaseCollection.disciplinasRef.add({
        "nome": disciplinaController.text,
        "tutor": tutorController.text,
        "userId": userId
      });

      Utils.schowSnackBar('Disciplina cadastrada com sucesso! ');
    } else {
      //Editar disciplina
      await FirebaseCollection.disciplinasRef.doc(docId).update({
        "nome": disciplinaController.text,
        "tutor": tutorController.text,
        "userId": userId
      });
      Utils.schowSnackBar('Disciplina editada com sucesso! ');
    }

    //Limpar formulário
    disciplinaController.clear();
    tutorController.clear();

    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }
}
