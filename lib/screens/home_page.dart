import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_notees/components/home_page_content.dart';
import 'package:college_notees/firebase/collection_ref.dart';
import 'package:college_notees/screens/intro_page.dart';
import 'package:college_notees/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseCollection.usersRef.doc(auth.userId()).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          return isNewUser(snapshot.data!, auth.userId());
        }
        return const LinearProgressIndicator();
      },
    );
  }

  Widget isNewUser(DocumentSnapshot snapshot, String userId) {
    if (snapshot.get('novo_usuario')) {
      return IntroPage(userId: userId);
    } else {
      return HomePageContent(userId: userId);
    }
  }
}
