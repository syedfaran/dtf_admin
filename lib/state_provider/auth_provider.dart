import 'package:dtf_web/source/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

enum ApplicationLoginState { loggedIn, loggedOut }


class AuthProvider extends ChangeNotifier{
  final Auth auth;
  AuthProvider({required this.auth}){
    init();
  }
  String? _email;
  String? get email => _email;
  ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;
  ApplicationLoginState get loginState => _loginState;

  Future<void> init() async {
    await Firebase.initializeApp();

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loginState = ApplicationLoginState.loggedIn;
      } else {
        _loginState = ApplicationLoginState.loggedOut;
      }
      notifyListeners();
    });
  }

  Future<void> signInWithGoogle(void Function(FirebaseAuthException e) errorCallback) async {
    try {
      await auth.signInWithGoogle();
    } on FirebaseAuthException catch (e) {

      errorCallback(e);
    }
  }


}