import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_notees/screens/form/widgets/buttons.dart';
import 'package:college_notees/theme/app_theme.dart';
import 'package:college_notees/widgets/utils.dart';
import 'package:flutter/material.dart';

enum Action { delete, update }

class BuildDisciplinaCard extends StatefulWidget {
  final String disciplina;
  final String tutor;
  final String userId;
  final DocumentReference docRef;
  final Color backgroundColor;
  final Color iconColor;

  const BuildDisciplinaCard({
    super.key,
    required this.disciplina,
    required this.tutor,
    required this.backgroundColor,
    required this.iconColor,
    required this.userId,
    required this.docRef,
  });

  @override
  State<BuildDisciplinaCard> createState() => _BuildDisciplinaCardState();
}

class _BuildDisciplinaCardState extends State<BuildDisciplinaCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Card(
        color: widget.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 15,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListTile(
            title: Text(widget.disciplina),
            subtitle: widget.tutor.isNotEmpty ? Text(widget.tutor) : null,
            leading: ImageIcon(
              const AssetImage("lib/assets/img/books.png"),
              color: widget.iconColor,
            ),
            trailing: PopupMenuButton<Action>(
                onSelected: (Action item) {
                  if (item == Action.delete) {
                    deleteDisciplina();
                  } else {
                    openFormDialog(
                        context: context,
                        isEditing: true,
                        userId: widget.userId,
                        docId: widget.docRef.id,
                        disciplina: widget.disciplina,
                        tutor: widget.tutor,
                        title: 'Editar disciplina');
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<Action>>[
                      PopupMenuItem<Action>(
                        value: Action.update,
                        child: Text(
                          'Editar',
                          style: AppTheme.typo
                              .regular(12, AppTheme.colors.dark, 1, 1),
                        ),
                      ),
                      PopupMenuItem<Action>(
                        value: Action.delete,
                        child: Text(
                          'Deletar',
                          style: AppTheme.typo
                              .regular(12, AppTheme.colors.dark, 1, 1),
                        ),
                      ),
                    ]),
          ),
        ),
      ),
    );
  }

  Future<void> deleteDisciplina() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Deletar disciplina',
            style: AppTheme.typo.medium(18, AppTheme.colors.dark, 1, 1),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Esta ação realizará a exclusão da disciplina de ${widget.disciplina}.',
                  textAlign: TextAlign.start,
                  style:
                      AppTheme.typo.regular(15, AppTheme.colors.dark, 1.5, 1),
                ),
                Utils.addVerticalSpace(8),
                Text(
                  'Você tem certeza que desejas continuar?',
                  textAlign: TextAlign.start,
                  style:
                      AppTheme.typo.regular(15, AppTheme.colors.dark, 1.5, 1),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCELAR'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('DELETAR'),
              onPressed: () async {
                await widget.docRef.delete();
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();

                Utils.schowSnackBar('Atividade deletada com sucesso!');
              },
            ),
          ],
        );
      },
    );
  }
}
