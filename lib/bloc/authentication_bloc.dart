import 'dart:async';
import 'package:journal/services/authentication.dart';

class AuthenticationBloc {
  final AuthenticationService authenticationService;
  final StreamController<String> _authenticationController =
      StreamController<String>.broadcast();
  Sink<String> get addUser => _authenticationController.sink;
  Stream<String> get user => _authenticationController.stream;

  //logoutController
  final StreamController<bool> _logoutController =
      StreamController<bool>.broadcast();
  Sink<bool> get logoutUser => _logoutController.sink;
  Stream<bool> get listLogoutUser => _logoutController.stream;

  AuthenticationBloc(this.authenticationService) {
    onAuthChanged();
  }

  void onAuthChanged() {
    authenticationService.getFirebaseAuth().authStateChanges().listen((user) {
      if (user != null) {
        final String uid = user.uid;
        addUser.add(uid);
      } else {}
    });
    _logoutController.stream.listen((logout) {
      if (logout == true) {
        _signOut();
      }
    });
  }

  void _signOut() {
    authenticationService.signOut();
  }

  void dispose() {
    _authenticationController.close();
    _logoutController.close();
  }
}
