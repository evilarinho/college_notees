import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_notees/responsive/responsive.dart';
import 'package:college_notees/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  final Widget text;
  final VoidCallback onPressed;

  const CustomOutlinedButton(
      {super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Responsive.isMobile(context)
          ? 200
          : Responsive.isTablet(context)
              ? 230
              : 250,
      child: OutlinedButton(
          style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.all(25),
              side: BorderSide(width: 3.0, color: AppTheme.colors.light),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0))),
          onPressed: onPressed,
          child: text),
    );
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<QueryDocumentSnapshot> disciplinaList;
  final Function(List<String>) onSelectionChanged;

  const MultiSelectChip(
      {super.key,
      required this.disciplinaList,
      required this.onSelectionChanged});

  @override
  State<MultiSelectChip> createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  List<String> selectedDisciplinas = [];

  _buildDisciplinaList() {
    List<Widget> disciplinas = [];

    for (var item in widget.disciplinaList) {
      disciplinas.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(
            item.get('nome'),
            style: AppTheme.typo.medium(15, AppTheme.colors.dark, 0, 1),
          ),
          selected: selectedDisciplinas.contains(item.get('nome')),
          backgroundColor: AppTheme.colors.lightBlue,
          onSelected: (selected) {
            setState(() {
              selectedDisciplinas.contains(item.get('nome'))
                  ? selectedDisciplinas.remove(item.get('nome'))
                  : selectedDisciplinas.add(item.get('nome'));
              widget.onSelectionChanged(selectedDisciplinas);
            });
          },
        ),
      ));
    }

    return disciplinas;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildDisciplinaList(),
    );
  }
}

class ListTileOptions extends StatelessWidget {
  final IconData icone;
  final String title;
  final VoidCallback onTap;

  const ListTileOptions(
      {super.key,
      required this.icone,
      required this.title,
      required this.onTap});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ListTile(
          leading: Icon(icone),
          title: Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                  fontSize: 15)),
          onTap: onTap,
          iconColor: AppTheme.colors.blue,
          textColor: AppTheme.colors.dark,
        ),
      );
}

class Options extends StatelessWidget {
  final String title;
  final String titleContent;
  final Function()? onTap;
  final bool editImage;
  final bool isDeleteAccountOption;
  final bool isLogoutOption;

  const Options(
      {super.key,
      required this.title,
      required this.titleContent,
      required this.onTap,
      required this.editImage,
      required this.isDeleteAccountOption,
      required this.isLogoutOption});

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.only(bottom: 15),
        color: AppTheme.colors.light,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(
            color: isDeleteAccountOption
                ? AppTheme.colors.red
                : AppTheme.colors.blue,
            width: 2.0,
          ),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListTile(
            onTap: onTap,
            title: Text(
              titleContent,
              style: AppTheme.typo.regular(16, AppTheme.colors.dark, 1.5, 1),
              textAlign: TextAlign.left,
            ),
            leading: Text(
              title,
              style: AppTheme.typo.medium(17, AppTheme.colors.dark, 1.5, 1),
            ),
            trailing: editImage
                ? Icon(
                    Icons.camera_alt_rounded,
                    color: AppTheme.colors.dark,
                  )
                : isDeleteAccountOption
                    ? Icon(
                        Icons.delete_forever_rounded,
                        color: AppTheme.colors.red,
                      )
                    : isLogoutOption
                        ? Icon(
                            Icons.logout_rounded,
                            color: AppTheme.colors.dark,
                          )
                        : Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: AppTheme.colors.dark,
                          ),
          ),
        ));
  }
}

class CardInfo extends StatefulWidget {
  final String title;
  final String content;
  final Function() onTap;

  const CardInfo(
      {super.key,
      required this.title,
      required this.content,
      required this.onTap});

  @override
  State<CardInfo> createState() => _CardInfoState();
}

class _CardInfoState extends State<CardInfo> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: AppTheme.colors.light,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(
          color: AppTheme.colors.blue,
          width: 2.0,
        ),
      ),
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: AppTheme.typo.bold(17, AppTheme.colors.dark, 1.5, 1),
            ),
            ListTile(
                title: Text(
                  widget.content,
                  style:
                      AppTheme.typo.regular(17, AppTheme.colors.dark, 1.5, 1),
                ),
                trailing: Icon(
                  Icons.edit,
                  color: AppTheme.colors.dark,
                ),
                onTap: widget.onTap)
          ],
        ),
      ),
    );
  }
}
