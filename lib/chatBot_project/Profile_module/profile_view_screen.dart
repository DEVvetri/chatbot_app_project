// ignore_for_file: must_be_immutable

import 'package:chatbot_app_project/chatBot_project/Profile_module/profile_edit_screen.dart';
import 'package:chatbot_app_project/chatBot_project/bloc_module/profile_bloc/profile_bloc.dart';
import 'package:chatbot_app_project/chatBot_project/bloc_module/profile_bloc/profile_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileViewScreen extends StatelessWidget {
  DocumentSnapshot profileId;
  ProfileViewScreen({super.key, required this.profileId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileBloc, EditProfileState>(
      builder: (context, state) {
        if (state is EditProfileUpdated) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Profile"),
              centerTitle: true,
              backgroundColor: Colors.blueAccent,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // Avatar and Name Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: state.avatar != null
                              ? FileImage(state.avatar!) as ImageProvider
                              : const AssetImage('assets/default_avatar.png'),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          state.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          state.username,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Profile Details
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.lock),
                            title: const Text("Password"),
                            subtitle: Text(
                              state.password.isNotEmpty
                                  ? "********"
                                  : "No password set",
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.interests),
                            title: const Text("Area of Interest"),
                            subtitle: Text(
                              state.areaOfInterest,
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.school),
                            title: const Text("Want to Become"),
                            subtitle: Text(
                              state.wantToBecome,
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            leading: Icon(
                              state.isPrivate
                                  ? Icons.lock_outline
                                  : Icons.public,
                            ),
                            title: const Text("Account Privacy"),
                            subtitle: Text(
                              state.isPrivate ? "Private" : "Public",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Edit Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileEditScreen(
                              docId: profileId.id,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text("Edit Profile"),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
