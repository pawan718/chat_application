import 'package:chat_application/bloc/authentication_bloc.dart';
import 'package:chat_application/screens/FirstScreen.dart';
import 'package:chat_application/screens/HomeScreen.dart';
import 'package:chat_application/user_data_bloc/user_data_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  FirebaseAuth auth = FirebaseAuth.instance;

  Widget checkuser() {
    if (auth.currentUser != null) {
      return HomeScreen();
    }
    return FirstScreen();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(),
        ),
        BlocProvider<UserDataBloc>(
          create: (context) => UserDataBloc(),
        ),
      ],
      child: MaterialApp(
        home: checkuser(),
      ),
    );
  }
}
