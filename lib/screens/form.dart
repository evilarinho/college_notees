import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_notees/components/activity_form.dart';
import 'package:college_notees/components/disciplina_form.dart';
import 'package:college_notees/theme/app_theme.dart';
import 'package:college_notees/widgets/drawer_navigation.dart';

import 'package:flutter/material.dart';

class Form extends StatefulWidget {
  final String? title;
  final String? content;
  final String? date;
  final String? disciplina;
  final DocumentSnapshot? docRef;
  final bool isEditing;

  const Form(
      {super.key,
      this.title,
      this.content,
      this.date,
      this.disciplina,
      this.docRef,
      required this.isEditing});

  @override
  State<Form> createState() => _FormState();
}

class _FormState extends State<Form> with TickerProviderStateMixin {
  late TabController _tabController;
  String title = 'Atividades';
  bool isActivityTab = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    getTabIndex();
  }

  getTabIndex() {
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        if (_tabController.index == 0) {
          setState(() {
            title = 'Atividades';
            isActivityTab = true;
          });
        } else {
          setState(() {
            title = 'Disciplinas';
            isActivityTab = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cadastro de $title',
          style: AppTheme.typo.appBar,
        ),
        bottom: TabBar(
            indicatorColor: AppTheme.colors.white,
            indicatorWeight: 4,
            controller: _tabController,
            tabs: const [
              Tab(
                text: 'Atividades',
                icon: ImageIcon(
                  AssetImage("lib/assets/img/assignment.png"),
                ),
              ),
              Tab(
                  text: 'Disciplinas',
                  icon: ImageIcon(
                    AssetImage("lib/assets/img/book.png"),
                  )),
            ]),
      ),
      drawer: const DrawerNavigation(),
      body: TabBarView(
        controller: _tabController,
        children: [
          ActivityForm(
            title: widget.title,
            content: widget.content,
            date: widget.date,
            disciplina: widget.disciplina,
            docRef: widget.docRef,
            isEditing: widget.isEditing,
            tabController: _tabController,
          ),
          const DisciplinaForm()
        ],
      ),
    );
  }
}
