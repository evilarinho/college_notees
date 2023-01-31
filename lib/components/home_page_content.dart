import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_notees/components/empty_state_ui.dart';
import 'package:college_notees/firebase/collection_ref.dart';
import 'package:college_notees/responsive/responsive.dart';

import 'package:college_notees/theme/app_theme.dart';
import 'package:college_notees/widgets/drawer_navigation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePageContent extends StatefulWidget {
  final String userId;

  const HomePageContent({super.key, required this.userId});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  TextStyle gridText(double size) {
    return TextStyle(
        color: const Color(0xffeeeeee),
        fontFamily: "Inter",
        fontSize: size,
        fontWeight: FontWeight.bold,
        letterSpacing: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas disciplinas', style: AppTheme.typo.appBar),
      ),
      drawer: const DrawerNavigation(),
      body: SingleChildScrollView(
          child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseCollection.disciplinasRef
                  .where('userId', isEqualTo: widget.userId)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Algo deu errado!'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.data!.size != 0) {
                  return disciplinasGrid(snapshot.data!);
                } else {
                  return const EmptyStateUi();
                }
              }),
        ],
      )),
    );
  }

  Widget disciplinasGrid(QuerySnapshot data) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
          shrinkWrap: true,
          itemCount: data.size,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: Responsive.isDesktop(context) ? 1.4 : 0.75,
            mainAxisSpacing: Responsive.isMobile(context) ? 10 : 20,
            crossAxisSpacing: Responsive.isMobile(context) ? 10 : 20,
            crossAxisCount: Responsive.isDesktop(context)
                ? 4
                : Responsive.isTablet(context)
                    ? 3
                    : 2,
          ),
          itemBuilder: (BuildContext context, int index) {
            final disciplina = data.docs[index]['nome'];
            final userId = data.docs[index]['userId'];
            return InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () => GoRouter.of(context)
                    .push('/activity-list/$disciplina/$userId'),
                child: Container(
                    // alignment: Alignment.center,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.colors.dark,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        disciplina,
                        textAlign: TextAlign.center,
                        style: Responsive.isMobile(context)
                            ? gridText(16)
                            : gridText(19),
                      ),
                    )));
          }),
    );
  }
}
