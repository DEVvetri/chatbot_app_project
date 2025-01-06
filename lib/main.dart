// ignore_for_file: library_private_types_in_public_api, sort_child_properties_last

import 'package:chatbot_app_project/auth/checking_auth.dart';
import 'package:chatbot_app_project/chatBot_project/Profile_module/profile_view_screen.dart';
import 'package:chatbot_app_project/chatBot_project/bloc_module/profile_bloc/profile_bloc.dart';
import 'package:chatbot_app_project/chatBot_project/bloc_module/login_bloc/login_bloc_bloc.dart';
import 'package:chatbot_app_project/chatBot_project/navigation_section/main_app_navigation.dart';
import 'package:chatbot_app_project/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

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
        ),
        BlocProvider(
          create: (context) => EditProfileBloc(),
          child: ProfileViewScreen(),
        )
      ],
      child: GetMaterialApp(
        title: 'chatBot Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: CheckingAuth(),
      ),
    );
  }
}
