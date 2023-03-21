import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_notees/theme/app_theme.dart';
import 'package:flutter/material.dart';

class FilterField extends StatefulWidget {
  final String userId;
  final Function(String) currencyValue;

  const FilterField(
      {super.key, required this.userId, required this.currencyValue});

  @override
  State<FilterField> createState() => _FilterFieldState();
}

class _FilterFieldState extends State<FilterField> {
  final disciplinasRef = FirebaseFirestore.instance.collection('DISCIPLINAS');
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: disciplinasRef
            .where("userId", isEqualTo: widget.userId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Algo deu errado!');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          var hint = (snapshot.data!.size == 0)
              ? 'Sem disciplinas'
              : 'Filtrar disciplina';
          return Container(
            width: 250,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 5), // changes position of shadow
                  ),
                ]),
            child: DropdownButtonFormField(
              isExpanded: true,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(right: 6, left: 6),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: AppTheme.colors.dark, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: AppTheme.colors.dark, width: 1),
                  ),
                  filled: true,
                  fillColor: AppTheme.colors.light,
                  hintText: hint),
              items: (snapshot.data!.size != 0)
                  ? snapshot.data!.docs
                      .map((DocumentSnapshot document) =>
                          DropdownMenuItem<String>(
                            value: document['nome'],
                            child: Text(document['nome'],
                                style: AppTheme.typo
                                    .regular(15, AppTheme.colors.dark, 1, 1)),
                          ))
                      .toList()
                  : null,
              onChanged: (currencyValue) {
                setState(() {
                  selectedValue = currencyValue!;
                  widget.currencyValue(currencyValue);
                });
              },
              value: selectedValue,
              borderRadius: BorderRadius.circular(15),
              iconEnabledColor: AppTheme.colors.dark,
              enableFeedback: true,
              dropdownColor: AppTheme.colors.light,
              icon: Icon(
                Icons.keyboard_arrow_down_outlined,
                size: 30,
                color: AppTheme.colors.dark,
              ),
              alignment: Alignment.centerLeft,
            ),
          );
        });
  }
}
