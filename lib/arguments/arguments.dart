import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditInfoUserArguments {
  final String title;
  final String content;
  final String label;
  final String hint;
  final FormFieldValidator validator;
  final String docId;
  final String dbName;

  EditInfoUserArguments(this.title, this.content, this.label, this.hint,
      this.validator, this.docId, this.dbName);
}

class ActivityArguments {
  final String? title;
  final String? content;
  final String? date;
  final String? disciplina;
  final DocumentSnapshot? docRef;
  final bool isEditing;

  ActivityArguments(
      {this.title,
      this.disciplina,
      this.content,
      this.date,
      required this.isEditing,
      this.docRef});
}
