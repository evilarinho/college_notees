import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_notees/widgets/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? usuario;
  UserCredential? userCredential;
  bool isLoading = true;

  //Faz referência a coleção de usuário no Firebase
  final usersRef = FirebaseFirestore.instance.collection('USUARIOS');

  // Verifica se o usuário está logado
  bool isLoggedIn() {
    return _auth.currentUser != null;
  }

  // Pega o ID do usuário
  userId() {
    return _auth.currentUser?.uid;
  }

  // Pega o email do usuário
  userEmail() {
    return _auth.currentUser?.email;
  }

  AuthService() {
    _authCheck();
  }

  _authCheck() {
    _auth.authStateChanges().listen((User? user) {
      usuario = (user == null) ? null : user;
      isLoading = false;
      notifyListeners();
    });
  }

//"Pega" o usuário que cadastrou-se
  _getUser() {
    usuario = _auth.currentUser;
    notifyListeners();
  }

//Método de cadastro de usuário
  register(String email, String password, String name) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      _getUser();
      //Adiciona o novo usuário a coleção USUARIOS
      addUser(email, name, userCredential.additionalUserInfo!.isNewUser);
    } on FirebaseAuthException catch (e) {
      handleAuthError(e);
    }
  }

//Método de login do usuário
  login(String email, String password) async {
    try {
      userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      _getUser();
    } on FirebaseAuthException catch (e) {
      handleAuthError(e);
    }
  }

  logout() async {
    await _auth.signOut();
    _getUser();
  }

  handleAuthError(FirebaseException error) {
    switch (error.code) {
      case 'invalid-email':
        Utils.schowSnackBar('Email inválido');

        break;
      case 'user-not-found':
        Utils.schowSnackBar('Usuário não encontrado');
        break;
      case 'wrong-password':
        Utils.schowSnackBar('Senha incorreta');
        break;
      case 'email-already-in-use':
        Utils.schowSnackBar('Este email já está sendo usado por outro usuário');
        break;
      case 'weak-password':
        Utils.schowSnackBar('A senha precisa ter no mínimo 6 caracteres');
        break;
      default:
        Utils.schowSnackBar('Erro desconhecido');
        break;
    }
  }

  addUser(String email, String name, bool isNewUser) async {
    await usersRef
        .doc(userId())
        .set({
          "_id": userId(),
          "nome": name,
          "email": email,
          "photo_url": "",
          "novo_usuario": isNewUser
        })
        .then((value) => debugPrint("Usuário adicionado"))
        .catchError((error) =>
            debugPrint("Falha ao adicionar usuário na coleção: $error"));
  }

  Future<void> reauthenticateUser(
      String password, BuildContext context, Function action) async {
    try {
      final user = _auth.currentUser;
      AuthCredential credential =
          EmailAuthProvider.credential(email: userEmail(), password: password);

      await user!.reauthenticateWithCredential(credential);

      // ignore: use_build_context_synchronously
      Navigator.of(context).pop(true);
      action();
    } catch (error) {
      debugPrint('$error');
      Navigator.of(context).pop(true);

      Utils.schowSnackBar(
          'Credenciais incorretas. Por favor, verifique-as e tente novamente.');
      debugPrint('Erro na reautenticação do usuário !!!');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);

      String message =
          'Pronto! Um link para criação de uma nova senha foi enviado para o seu e-mail.';
      debugPrint(message);

      //SNACKBAR
      Utils.schowSnackBar(message);
    } catch (e) {
      debugPrint('$e');

      Utils.schowSnackBar('Erro no envio do e-mail!');
    }
  }
}
