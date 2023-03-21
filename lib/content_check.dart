import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_notees/firebase/collection_ref.dart';
import 'package:college_notees/responsive/responsive.dart';

import 'package:college_notees/screens/intro/intro.dart';
import 'package:college_notees/services/auth_service.dart';
import 'package:college_notees/widgets/navigation/navigation_bar.dart';
import 'package:college_notees/widgets/navigation/navigation_rail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContentCheck extends StatefulWidget {
  const ContentCheck({super.key});

  @override
  State<ContentCheck> createState() => _ContentCheckState();
}

class _ContentCheckState extends State<ContentCheck> {
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
      return const Responsive(
        desktop: BuildNavigationRail(),
        mobile: BuildNavigationBar(),
      );
    }
  }
}
