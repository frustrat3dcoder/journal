import 'package:flutter/material.dart';
import 'package:journal/bloc/login_bloc.dart';
import 'package:journal/services/authentication.dart';
import 'package:journal/utils/const.dart';
import 'package:journal/utils/pallete.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late LoginBloc _loginBloc;
  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc(AuthenticationService());
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.asset("assets/images/logo.gif", height: 300, width: 300),
              StreamBuilder<String>(
                stream: _loginBloc.email,
                builder: (BuildContext context, AsyncSnapshot snapshot) =>
                    TextField(
                  keyboardType: TextInputType.emailAddress,
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: Palette.kToDark),
                  decoration: InputDecoration(
                      labelText: 'Email Address',
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Palette.kToDark,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Palette.kToDark,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Palette.kToDark,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Palette.kToDark,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: const Icon(Icons.mail_outline),
                      focusColor: secondaryColor,
                      errorStyle: TextStyle(
                        color: snapshot.error != null
                            ? primaryColor
                            : secondaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      // ignore: prefer_null_aware_operators
                      errorText: snapshot.error == null
                          ? null
                          : snapshot.error.toString()),
                  onChanged: _loginBloc.emailChanged.add,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder<String>(
                stream: _loginBloc.password,
                builder: (BuildContext context, AsyncSnapshot snapshot) =>
                    TextField(
                  obscureText: true,
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: Palette.kToDark),
                  decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.security),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Palette.kToDark,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Palette.kToDark,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Palette.kToDark,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Palette.kToDark,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusColor: secondaryColor,
                      errorStyle: TextStyle(
                        color: snapshot.error != null
                            ? primaryColor
                            : secondaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      // ignore: prefer_null_aware_operators
                      errorText: snapshot.error != null
                          ? snapshot.error.toString()
                          : null),
                  onChanged: _loginBloc.passwordChanged.add,
                ),
              ),
              const SizedBox(height: 20.0),
              _buildLoginAndCreateButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginAndCreateButtons() {
    return StreamBuilder(
      initialData: 'Login',
      stream: _loginBloc.loginOrCreateButton,
      builder: ((BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == 'Login') {
          return _buttonsLogin();
        } else if (snapshot.data == 'Create Account') {
          return _buttonsCreateAccount();
        }
        return Container();
      }),
    );
  }

  Column _buttonsLogin() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        StreamBuilder(
          initialData: false,
          stream: _loginBloc.enableLoginCreateButton,
          builder: (BuildContext context, AsyncSnapshot snapshot) =>
              ElevatedButton(
            child: const Text('Login'),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(primaryColor),
                padding: MaterialStateProperty.all(const EdgeInsets.all(20))),
            onPressed: snapshot.data
                ? () => setState(() {
                      _loginBloc.loginOrCreateChanged.add('Login');
                    })
                : null,
          ),
        ),
        TextButton(
          child: const Text('Create Account'),
          onPressed: () {
            _loginBloc.loginOrCreateButtonChanged.add('Create Account');
          },
        ),
      ],
    );
  }

  Column _buttonsCreateAccount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        StreamBuilder(
          initialData: false,
          stream: _loginBloc.enableLoginCreateButton,
          builder: (BuildContext context, AsyncSnapshot snapshot) =>
              ElevatedButton(
            child: const Text('Create Account'),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(primaryColor),
                padding: MaterialStateProperty.all(const EdgeInsets.all(20))),
            onPressed: snapshot.data
                ? () => setState(() {
                      _loginBloc.loginOrCreateChanged.add('Create Account');
                    })
                : null,
          ),
        ),
        TextButton(
          child: const Text('Login'),
          onPressed: () {
            _loginBloc.loginOrCreateButtonChanged.add('Login');
          },
        ),
      ],
    );
  }
}
