import 'package:chatbot_app_project/chatBot_project/home_module/home_screen.dart';
import 'package:chatbot_app_project/chatBot_project/login_module/bloc/login_bloc_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBlocBloc, LoginBlocState>(
      listener: (context, state) {
        if (state is LoginBlocLoaded) {
          if (state.isloged) {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => HomeScreen()));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Invalid credentials!")),
            );
          }
        }
        if (state is LoginBlocError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${state.message}")),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.blue,
          body: SingleChildScrollView(
            child: Container(
              color: Colors.blue,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 80,
                      ),
                      Container(
                        height: 350,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/images/login.png"))),
                      ),
                      TextFormField(
                        controller: userName,
                        decoration: InputDecoration(
                          hintText: "Username",
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: password,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: "Password",
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: 250,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              foregroundColor:
                                  WidgetStatePropertyAll(Colors.white),
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.black)),
                          onPressed: () {
                            // Trigger the login event
                            final email = userName.text.trim();
                            final pwd = password.text.trim();
                            if (email.isNotEmpty && pwd.isNotEmpty) {
                              context.read<LoginBlocBloc>().add(
                                    LoginEvent(email: email, password: pwd),
                                  );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text("Please fill all fields")),
                              );
                            }
                          },
                          child: const Text("Login"),
                        ),
                      ),
                      const SizedBox(height: 15),
                      if (state is LoginBlocLoading)
                        CircularProgressIndicator(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
