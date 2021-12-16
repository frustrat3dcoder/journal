import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService implements Authentication {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  FirebaseAuth getFirebaseAuth() {
    return _firebaseAuth;
  }

  Future<String> currentUserUid() async {
    User user = _firebaseAuth.currentUser!;
    return user.uid;
  }

  Future<String> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    return userCredential.user!.uid;
  }

  Future<String> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user!.uid;
  }

  @override
  Future<void> sendEmailVerification() async {
    User user = _firebaseAuth.currentUser!;
    user.sendEmailVerification();
  }

  @override
  Future<bool> isEmailVerified() async {
    User user = _firebaseAuth.currentUser!;
    return user.emailVerified;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}

abstract class Authentication {
  Future<void> sendEmailVerification();
  Future<bool> isEmailVerified();
}
