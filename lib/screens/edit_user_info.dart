import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_notees/components/editor.dart';
import 'package:college_notees/services/auth_service.dart';
import 'package:college_notees/theme/app_theme.dart';
import 'package:college_notees/widgets/utils.dart';
import 'package:college_notees/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditInfoUser extends StatefulWidget {
  final String title;
  final String content;
  final String label;
  final String hint;
  final FormFieldValidator validator;
  final String docId;
  final String dbName;

  const EditInfoUser(
      {super.key,
      required this.title,
      required this.content,
      required this.label,
      required this.hint,
      required this.validator,
      required this.docId,
      required this.dbName});

  @override
  State<EditInfoUser> createState() => _EditInfoUserState();
}

class _EditInfoUserState extends State<EditInfoUser> {
  final TextEditingController _controller = TextEditingController();
  bool editandoInfo = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    setState(() {
      _controller.text = widget.content;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: AppTheme.typo.appBar),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            editandoInfo
                ? Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        EditorTextFormField(
                          controller: _controller,
                          fieldIcon: const Icon(Icons.title_rounded),
                          maxLength: 50,
                          maxLines: 1,
                          readOnly: false,
                          validator: widget.validator,
                          labelText: widget.label,
                          hintText: widget.hint,
                          validateField: true,
                        ),
                        Utils.addVerticalSpace(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    editandoInfo = false;
                                  });
                                },
                                child: const Text('Cancelar')),
                            Utils.addHorizontalSpace(10),
                            ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    final doc = await FirebaseFirestore.instance
                                        .collection('USUARIOS')
                                        .doc(widget.docId)
                                        .get();

                                    //Atualiza a informação no banco de dados
                                    doc.reference.update(
                                        {widget.dbName: _controller.text});

                                    if (widget.dbName == 'email') {
                                      auth.usuario!
                                          .updateEmail(_controller.text);
                                    }

                                    // ignore: use_build_context_synchronously
                                    Navigator.pop(context);
                                  }
                                },
                                child: const Text('Salvar'))
                          ],
                        )
                      ],
                    ),
                  )
                : CardInfo(
                    title: widget.title,
                    content: widget.content,
                    onTap: () {
                      setState(() {
                        editandoInfo = true;
                      });
                    })
          ],
        ),
      ),
    );
  }
}
