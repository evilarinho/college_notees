import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_notees/theme/app_theme.dart';
import 'package:college_notees/widgets/utils.dart';
import 'package:college_notees/widgets/validation.dart';
import 'package:flutter/material.dart';

enum Action { delete, update }

class BuildAtividadeCard extends StatefulWidget {
  final String disciplina;
  final String title;
  final String date;
  final String description;
  final Color backgroundColor;
  final Color chipColor;
  final DocumentReference docRef;
  final String userId;

  const BuildAtividadeCard(
      {super.key,
      required this.disciplina,
      required this.title,
      required this.date,
      required this.description,
      required this.backgroundColor,
      required this.chipColor,
      required this.docRef,
      required this.userId});

  @override
  State<BuildAtividadeCard> createState() => _BuildAtividadeCardState();
}

class _BuildAtividadeCardState extends State<BuildAtividadeCard> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _disciplinaController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool readOnly = true;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.title;
    _contentController.text = widget.description;
    _dateController.text = widget.date;
    _disciplinaController.text = widget.disciplina;
  }

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
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: disciplinaChip()),
                      readOnly
                          ? PopupMenuButton<Action>(
                              onSelected: (Action item) {
                                if (item == Action.delete) {
                                  deleteAtividade();
                                } else {
                                  setState(() {
                                    readOnly = false;
                                  });
                                }
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<Action>>[
                                    PopupMenuItem<Action>(
                                      value: Action.update,
                                      child: Text(
                                        'Editar',
                                        style: AppTheme.typo.regular(
                                            12, AppTheme.colors.dark, 1, 1),
                                      ),
                                    ),
                                    PopupMenuItem<Action>(
                                      value: Action.delete,
                                      child: Text(
                                        'Deletar',
                                        style: AppTheme.typo.regular(
                                            12, AppTheme.colors.dark, 1, 1),
                                      ),
                                    ),
                                  ])
                          : IconButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  //Editar as informações da atividade
                                  await widget.docRef.update({
                                    "userId": widget.userId,
                                    "titulo": _titleController.text.trim(),
                                    "descricao": _contentController.text,
                                    "disciplina": _disciplinaController.text,
                                    "data_entrega": _dateController.text.trim()
                                  });
                                  setState(() {
                                    readOnly = true;
                                  });

                                  Utils.schowSnackBar(
                                      'Atividade editada com sucesso! ');
                                }
                              },
                              icon: const Icon(Icons.done_rounded))
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      textFieldCard(
                          controller: _titleController,
                          maxLines: 2,
                          isDateField: false,
                          style: AppTheme.typo
                              .bold(15, AppTheme.colors.dark, 1, 1)),
                      Utils.addVerticalSpace(20),
                      Text(
                        'Finalizar até',
                        textAlign: TextAlign.start,
                        style: AppTheme.typo
                            .regular(12, AppTheme.colors.dark, 1, 1),
                      ),
                      textFieldCard(
                          controller: _dateController,
                          style: AppTheme.typo
                              .bold(12, AppTheme.colors.dark, 1, 1),
                          isDateField: true,
                          action: readOnly
                              ? null
                              : () {
                                  _selectDate();
                                },
                          maxLines: 1),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Divider(
                      color: Colors.black26,
                      height: 10,
                      thickness: 2,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Descrição',
                        textAlign: TextAlign.start,
                        style:
                            AppTheme.typo.bold(12, AppTheme.colors.dark, 1, 1),
                      ),
                      Utils.addVerticalSpace(10),
                      textFieldCard(
                          controller: _contentController,
                          maxLines: 3,
                          isDateField: false,
                          style: AppTheme.typo
                              .regular(12, AppTheme.colors.dark, 1, 1)),
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }

  Widget textFieldCard(
      {required TextEditingController controller,
      required TextStyle style,
      required int maxLines,
      required bool isDateField,
      VoidCallback? action}) {
    return TextFormField(
      readOnly: isDateField ? true : readOnly,
      controller: controller,
      onTap: action,
      textAlign: TextAlign.start,
      style: style,
      maxLines: maxLines,
      validator: FormValidation.validateField(),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: widget.backgroundColor, width: 0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: widget.backgroundColor, width: 0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: widget.backgroundColor, width: 0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: widget.backgroundColor, width: 0),
        ),
      ),
    );
  }

  Widget disciplinaChip() {
    return TextFormField(
        readOnly: readOnly,
        controller: _disciplinaController,
        textAlign: TextAlign.center,
        maxLines: 1,
        keyboardType: TextInputType.text,
        style: AppTheme.typo.bold(12, AppTheme.colors.dark, 1, 1),
        validator: FormValidation.validateField(),
        decoration: InputDecoration(
          filled: true,
          fillColor: widget.chipColor,
          constraints: const BoxConstraints(
            maxHeight: 30,
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: widget.chipColor, width: 0),
              borderRadius: const BorderRadius.all(Radius.circular(50))),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: widget.chipColor, width: 0),
              borderRadius: const BorderRadius.all(Radius.circular(50))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: widget.chipColor, width: 0),
              borderRadius: const BorderRadius.all(Radius.circular(50))),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: widget.chipColor, width: 0),
              borderRadius: const BorderRadius.all(Radius.circular(50))),
        ));
  }

  _selectDate() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      helpText: 'Selecione uma data',
    );

    if (newDate != null) {
      setState(() {
        _dateController.text =
            '${newDate.day}/${newDate.month}/${newDate.year}';
        debugPrint(_dateController.text);
      });
    }
  }

  Future<void> deleteAtividade() {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Deletar atividade',
            style: AppTheme.typo.medium(18, AppTheme.colors.dark, 1, 1),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Esta ação realizará a exclusão dessa atividade.',
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
                debugPrint(widget.docRef.id);
                //await widget.docRef.delete();
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
