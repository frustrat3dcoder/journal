import 'package:flutter/material.dart';
import 'package:journal/bloc/authentication_bloc.dart';

class AuthenticationBlocProvider extends InheritedWidget {
  final AuthenticationBloc authenticationBloc;
  const AuthenticationBlocProvider(
      {Key? key, required Widget child, required this.authenticationBloc})
      : super(key: key, child: child);

  static AuthenticationBlocProvider of(BuildContext context) {
    return (context
            .dependOnInheritedWidgetOfExactType<AuthenticationBlocProvider>()
        as AuthenticationBlocProvider);
  }

  @override
  bool updateShouldNotify(AuthenticationBlocProvider oldWidget) =>
      authenticationBloc != oldWidget.authenticationBloc;
}
