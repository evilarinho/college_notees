import 'package:college_notees/theme/app_theme.dart';
import 'package:college_notees/widgets/utils.dart';
import 'package:flutter/material.dart';

class CardList extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool hasSubtitle;
  final ImageProvider icon;
  final Function() delete;
  final Function() edit;

  final titleCard = const TextStyle(
      color: Color(0xff232320),
      fontFamily: "Inter",
      fontSize: 16,
      fontWeight: FontWeight.bold,
      letterSpacing: 0);

  final subtitleCard = const TextStyle(
      color: Color(0xff232320),
      fontFamily: "Inter",
      fontSize: 15,
      fontWeight: FontWeight.w400,
      letterSpacing: 0);

  const CardList(
      {super.key,
      required this.title,
      this.subtitle,
      required this.delete,
      required this.edit,
      required this.icon,
      required this.hasSubtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        color: AppTheme.colors.lightBlue,
        elevation: 6,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: ImageIcon(
                icon,
                color: AppTheme.colors.dark,
              ),
              title: Text(title, style: titleCard),
              subtitle:
                  hasSubtitle ? Text(subtitle!, style: subtitleCard) : null,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.edit, color: AppTheme.colors.dark),
                    onPressed: edit,
                  ),
                  Utils.addHorizontalSpace(8),
                  IconButton(
                    icon: Icon(Icons.delete, color: AppTheme.colors.dark),
                    onPressed: delete,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
