import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_notees/theme/app_theme.dart';
import 'package:college_notees/widgets/utils.dart';
import 'package:flutter/material.dart';

class StreamBuilderData extends StatelessWidget {
  final Stream<QuerySnapshot> stream;
  final Function(AsyncSnapshot<QuerySnapshot>) widget;
  final Widget emptyStateUi;

  const StreamBuilderData(
      {super.key,
      required this.stream,
      required this.widget,
      required this.emptyStateUi});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: stream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_rounded,
                    color: AppTheme.colors.red,
                  ),
                  Utils.addHorizontalSpace(10),
                  Text(
                    'Algo deu errado!',
                    style:
                        AppTheme.typo.regular(12, AppTheme.colors.dark, 1, 1),
                  )
                ]);
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.size != 0) {
            return widget(snapshot);
          } else {
            return emptyStateUi;
          }
        });
  }
}
