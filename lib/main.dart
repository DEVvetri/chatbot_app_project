// ignore_for_file: library_private_types_in_public_api, sort_child_properties_last

import 'package:chatbot_app_project/chatBot_project/login_module/bloc/login_bloc_bloc.dart';
import 'package:chatbot_app_project/chatBot_project/login_module/login_screen.dart';
import 'package:chatbot_app_project/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBlocBloc(),
          child: Container(),
        )
      ],
      child: MaterialApp(
        title: 'chatBot Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: LoginScreen(),
      ),
    );
  }
}
