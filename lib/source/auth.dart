import 'package:firebase_auth/firebase_auth.dart';

class Auth{
  Future<void> signInWithGoogle() async {
    // Create a new provider
    GoogleAuthProvider _googleProvider = GoogleAuthProvider();

    _googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
    _googleProvider.setCustomParameters({
      'login_hint': 'user@example.com'
    });

    // Once signed in, return the UserCredential
     await FirebaseAuth.instance.signInWithPopup(_googleProvider);

    // Or use signInWithRedirect
    // await FirebaseAuth.instance.signInWithRedirect(_googleProvider);
  }
}