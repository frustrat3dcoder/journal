import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:journal/pages/home.dart';
import 'package:journal/bloc/authentication_bloc.dart';
import 'package:journal/bloc/authentication_bloc_provider.dart';
import 'package:journal/bloc/home_bloc.dart';
import 'package:journal/bloc/home_bloc_provider.dart';
import 'package:journal/services/authentication.dart';
import 'package:journal/services/db_firestore.dart';
import 'package:journal/pages/login.dart';
import 'package:journal/utils/ads_state.dart';
import 'package:journal/utils/const.dart';
import 'package:journal/utils/pallete.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initFuture = MobileAds.instance.initialize();
  final adState = AdState(initialization: initFuture);
  await Firebase.initializeApp();
  runApp(
    Provider.value(
      value: adState,
      builder: (context, child) => const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    final AuthenticationService _authenticationService =
        AuthenticationService();
    final AuthenticationBloc _authenticationBloc =
        AuthenticationBloc(_authenticationService);
    return AuthenticationBlocProvider(
      authenticationBloc: _authenticationBloc,
      child: StreamBuilder(
        initialData: null,
        stream: _authenticationBloc.user,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return HomeBlocProvider(
              homeBloc: HomeBloc(DbFirestoreService(), _authenticationService),
              uid: snapshot.data,
              child: _buildMaterialApp(const Home()),
            );
          } else {
            return _buildMaterialApp(const Login());
          }
        },
      ),
    );
  }

  MaterialApp _buildMaterialApp(Widget homepage) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Journal',
      theme: ThemeData(
        fontFamily: "Wondershine",
        textTheme: ThemeData.light().textTheme.copyWith(
              subtitle1: const TextStyle(
                  fontFamily: "DavidLibre",
                  fontSize: 20,
                  color: Colors.white54),
              button: const TextStyle(
                  fontFamily: "DavidLibre",
                  fontSize: 20,
                  color: Colors.white54),
              headline6: const TextStyle(
                  fontFamily: "DavidLibre",
                  fontSize: 20,
                  color: Colors.white54),
              headline5: const TextStyle(
                  fontFamily: "DavidLibre",
                  fontSize: 20,
                  color: Colors.white54),
              caption: const TextStyle(
                  fontFamily: "DavidLibre",
                  fontSize: 20,
                  color: Colors.white54),
              headline3: const TextStyle(
                  fontFamily: "DavidLibre",
                  fontSize: 20,
                  color: Colors.white54),
              bodyText1: const TextStyle(
                  fontFamily: "Wondershine",
                  fontSize: 40,
                  color: Colors.white60),
              bodyText2: const TextStyle(
                fontFamily: "Wondershine",
                fontSize: 20,
              ),
            ),
        canvasColor: Colors.white,
        bottomAppBarColor: secondaryColor,
        primarySwatch: Palette.kToDark,
      ),
      home: homepage,
    );
  }
}
