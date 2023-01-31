import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCollection {
  static final CollectionReference usersRef =
      FirebaseFirestore.instance.collection('USUARIOS');

  static final CollectionReference disciplinasRef =
      FirebaseFirestore.instance.collection('DISCIPLINAS');

  static final CollectionReference disciplinasBasicasRef =
      FirebaseFirestore.instance.collection('DISCIPLINAS_BASICAS');
}
