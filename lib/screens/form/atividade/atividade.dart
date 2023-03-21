import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_notees/components/editor.dart';
import 'package:college_notees/firebase/collection_ref.dart';
import 'package:college_notees/services/auth_service.dart';
import 'package:college_notees/theme/app_theme.dart';
import 'package:college_notees/widgets/stream_builder.dart';
import 'package:college_notees/widgets/utils.dart';
import 'package:college_notees/widgets/validation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Atividade extends StatefulWidget {
  final Function() disciplinasPage;

  const Atividade({super.key, required this.disciplinasPage});

  @override
  State<Atividade> createState() => _AtividadeState();
}

class _AtividadeState extends State<Atividade> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _selectedDisciplina = '';

  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 40),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Selecione uma disciplina',
                style: AppTheme.typo.medium(18, AppTheme.colors.dark, 1, 1)),
            Utils.addVerticalSpace(12),
            StreamBuilderData(
                stream: FirebaseCollection.disciplinasRef
                    .where("userId", isEqualTo: auth.userId())
                    .orderBy('nome', descending: false)
                    .snapshots(),
                widget: (snapshot) {
                  final data = snapshot.requireData;
                  return Wrap(
                    spacing: 8.0,
                    runSpacing: 5.0,
                    children: List.generate(
                      data.size,
                      (int index) {
                        return buildChip(index, data);
                      },
                    ).toList(),
                  );
                },
                emptyStateUi: OutlinedButton.icon(
                  onPressed: widget.disciplinasPage,
                  icon: Icon(
                    Icons.add_rounded,
                    color: AppTheme.colors.dark,
                  ),
                  label: Text('Cadastrar disciplinas',
                      textAlign: TextAlign.start,
                      style:
                          AppTheme.typo.medium(13, AppTheme.colors.dark, 1, 1)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(13),
                  ),
                )),
            Utils.addVerticalSpace(30),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EditorTextFormField(
                    controller: _titleController,
                    maxLength: 50,
                    maxLines: 1,
                    readOnly: false,
                    fieldIcon: const Icon(Icons.title_rounded),
                    validator: FormValidation.validateField(),
                    labelText: 'Título',
                    hintText: 'Informe o título da sua atividade',
                    validateField: true,
                  ),
                  Utils.addVerticalSpace(16),
                  EditorTextFormField(
                    controller: _dateController,
                    maxLength: 10,
                    maxLines: 1,
                    readOnly: true,
                    fieldIcon: const Icon(Icons.calendar_today),
                    validator: FormValidation.validateField(),
                    labelText: 'Data',
                    hintText: 'Data de entrega/realização da atividade',
                    action: () {
                      _selectDate();
                    },
                    validateField: true,
                  ),
                  Utils.addVerticalSpace(16),
                  EditorTextFormField(
                    controller: _contentController,
                    maxLength: 200,
                    maxLines: 3,
                    readOnly: false,
                    fieldIcon: const Icon(Icons.topic_rounded),
                    validator: FormValidation.validateField(),
                    labelText: 'Conteúdo',
                    hintText: 'Informe o conteúdo da sua atividade',
                    validateField: true,
                  ),
                  Utils.addVerticalSpace(20),
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (_selectedDisciplina == '') {
                            Utils.schowSnackBar('Selecione uma disciplina! ');
                          } else {
                            FirebaseCollection.atividadeRef.add({
                              "userId": auth.userId(),
                              "titulo": _titleController.text.trim(),
                              "descricao": _contentController.text,
                              "disciplina": _selectedDisciplina,
                              "data_entrega": _dateController.text.trim()
                            });

                            Utils.schowSnackBar(
                                'Atividade cadastrada com sucesso! ');

                            //Limpa o formulário
                            _cleanForm();
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 10)),
                      child: Text('Salvar',
                          textAlign: TextAlign.center,
                          style: AppTheme.typo
                              .bold(15, AppTheme.colors.light, 1, 1)))
                ],
              ),
            )
          ],
        ),
      ),
    );
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

  _cleanForm() {
    setState(() {
      _titleController.clear();
      _dateController.clear();
      _contentController.clear();
      _selectedDisciplina = null;
    });
  }

  Widget buildChip(int index, QuerySnapshot data) {
    return ChoiceChip(
      tooltip: data.docs[index]['nome'],
      label: Text(data.docs[index]['nome']),
      selected: _selectedDisciplina == data.docs[index]['nome'],
      onSelected: (bool selected) {
        setState(() {
          _selectedDisciplina = selected ? data.docs[index]['nome'] : null;
          debugPrint(_selectedDisciplina);
        });
      },
    );
  }
}
