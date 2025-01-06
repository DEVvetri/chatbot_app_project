// Integration of the EditProfileBloc with the Edit Page

import 'package:chatbot_app_project/chatBot_project/bloc_module/profile_bloc/profile_bloc.dart';
import 'package:chatbot_app_project/chatBot_project/bloc_module/profile_bloc/profile_event.dart';
import 'package:chatbot_app_project/chatBot_project/bloc_module/profile_bloc/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController areaOfInterestController =
      TextEditingController();
  final TextEditingController wantToBecomeController = TextEditingController();
  bool isPrivate = false;
  File? avatar;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditProfileBloc(),
      child: BlocBuilder<EditProfileBloc, EditProfileState>(
        builder: (context, state) {
          if (state is EditProfileUpdated) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Edit Profile'),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          // Implement image picker logic
                          // Example: avatar = await pickImage();
                          context
                              .read<EditProfileBloc>()
                              .add(UpdateAvatar(avatar));
                        },
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              avatar != null ? FileImage(avatar!) : null,
                          child: avatar == null
                              ? const Icon(Icons.person, size: 50)
                              : null,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                        ),
                        onChanged: (value) {
                          context
                              .read<EditProfileBloc>()
                              .add(UpdateName(value));
                        },
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                        ),
                        onChanged: (value) {
                          context
                              .read<EditProfileBloc>()
                              .add(UpdateUsername(value));
                        },
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                        obscureText: true,
                        onChanged: (value) {
                          context
                              .read<EditProfileBloc>()
                              .add(UpdatePassword(value));
                        },
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: areaOfInterestController,
                        decoration: const InputDecoration(
                          labelText: 'Area of Interest',
                        ),
                        onChanged: (value) {
                          context
                              .read<EditProfileBloc>()
                              .add(UpdateAreaOfInterest(value));
                        },
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: wantToBecomeController,
                        decoration: const InputDecoration(
                          labelText: 'Want to Become',
                        ),
                        onChanged: (value) {
                          context
                              .read<EditProfileBloc>()
                              .add(UpdateWantToBecome(value));
                        },
                      ),
                      const SizedBox(height: 20),
                      SwitchListTile(
                        title: const Text('Private'),
                        value: isPrivate,
                        onChanged: (value) {
                          setState(() {
                            isPrivate = value;
                          });
                          context
                              .read<EditProfileBloc>()
                              .add(UpdatePrivate(value));
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          context.read<EditProfileBloc>().add(SaveProfileEvent(
                                name: nameController.text,
                                username: usernameController.text,
                                password: passwordController.text,
                                areaOfInterest: areaOfInterestController.text,
                                wantToBecome: wantToBecomeController.text,
                                isPrivate: isPrivate,
                                avatar: avatar,
                              ));
                          Navigator.pop(
                              context); // Go back to the Profile View Screen
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
