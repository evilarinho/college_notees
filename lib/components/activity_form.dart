import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_notees/components/editor.dart';
import 'package:college_notees/responsive/responsive.dart';
import 'package:college_notees/services/auth_service.dart';
import 'package:college_notees/theme/app_theme.dart';
import 'package:college_notees/widgets/utils.dart';
import 'package:college_notees/widgets/validation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActivityForm extends StatefulWidget {
  final TabController tabController;
  final String? title;
  final String? content;
  final String? date;
  final String? disciplina;
  final DocumentSnapshot? docRef;
  final bool isEditing;

  const ActivityForm(
      {super.key,
      required this.tabController,
      this.title,
      this.disciplina,
      this.content,
      this.date,
      this.docRef,
      required this.isEditing});

  @override
  State<ActivityForm> createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _selectedDisciplina = '';

  final boldText = const TextStyle(
      color: Color(0xff232320),
      fontFamily: "Inter",
      fontSize: 17,
      fontWeight: FontWeight.bold,
      letterSpacing: 0,
      height: 1.5);

  //Faz referência a coleção DISCIPLINAS no Firebase
  final disciplinasRef = FirebaseFirestore.instance.collection('DISCIPLINAS');

  //Faz referência a coleção DISCIPLINAS no Firebase
  final activityRef = FirebaseFirestore.instance.collection('ATIVIDADES');

  @override
  void initState() {
    // Retornando os valores para os campos de texto
    widget.title != null ? _titleController.text = widget.title! : '';
    widget.content != null ? _contentController.text = widget.content! : '';
    widget.date != null ? _dateController.text = widget.date! : '';
    widget.disciplina != null ? _selectedDisciplina = widget.disciplina : '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selecione uma disciplina',
                    style: boldText,
                    textAlign: TextAlign.start,
                  ),
                  Utils.addVerticalSpace(16),
                  StreamBuilder<QuerySnapshot>(
                      stream: disciplinasRef
                          .where('userId', isEqualTo: auth.userId())
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Center(child: Text('Algo deu errado!'));
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        final data = snapshot.requireData;

                        if (data.size == 0) {
                          return OutlinedButton(
                              onPressed: () => widget.tabController.animateTo(1,
                                  duration: const Duration(seconds: 1)),
                              style: OutlinedButton.styleFrom(
                                  padding: Responsive.isMobile(context)
                                      ? const EdgeInsets.all(15)
                                      : const EdgeInsets.all(20)),
                              child: Text(
                                'Cadastrar disciplinas',
                                textAlign: TextAlign.start,
                                style: AppTheme.typo.button,
                              ));
                        } else {
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
                        }
                      }),
                  Utils.addVerticalSpace(30),
                  EditorTextFormField(
                      controller: _titleController,
                      maxLength: 50,
                      maxLines: 1,
                      readOnly: false,
                      fieldIcon: const Icon(Icons.title_rounded),
                      validator: FormValidation.validateField(),
                      labelText: 'Título',
                      hintText: 'Informe o título da sua atividade'),
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
                      hintText: 'Informe o conteúdo da sua atividade'),
                ],
              )),
          Utils.addVerticalSpace(20),
          ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (_selectedDisciplina == '') {
                    Utils.schowSnackBar('Selecione uma disciplina! ');
                  } else {
                    if (widget.isEditing) {
                      widget.docRef!.reference.update({
                        "userId": auth.userId(),
                        "titulo": _titleController.text.trim(),
                        "conteudo": _contentController.text,
                        "disciplina": _selectedDisciplina,
                        "data_entrega": _dateController.text.trim()
                      });
                      Navigator.of(context).pop();
                      Utils.schowSnackBar('Atividade atualizada com sucesso! ');
                    } else {
                      activityRef.add({
                        "userId": auth.userId(),
                        "titulo": _titleController.text.trim(),
                        "conteudo": _contentController.text,
                        "disciplina": _selectedDisciplina,
                        "data_entrega": _dateController.text.trim()
                      });

                      Utils.schowSnackBar('Atividade cadastrada com sucesso! ');
                    }

                    //Limpa o formulário
                    _cleanForm();
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                  padding: Responsive.isMobile(context)
                      ? const EdgeInsets.all(15)
                      : const EdgeInsets.all(20)),
              child: Text(
                'Salvar',
                textAlign: TextAlign.center,
                style: AppTheme.typo.button,
              )),
        ],
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
    _titleController.clear();
    _dateController.clear();
    _contentController.clear();
    _selectedDisciplina = '';
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
