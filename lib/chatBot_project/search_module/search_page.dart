import 'package:chatbot_app_project/chatBot_project/search_module/profile_view_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  // Debounce to reduce Firestore reads
  void _onSearchChanged(String value) {
    setState(() {
      searchQuery = value.trim(); // Update search query
    });
  }

  Stream<QuerySnapshot> _searchUsers(String query) {
    return FirebaseFirestore.instance
        .collection("Users")
        .where('username', isGreaterThanOrEqualTo: query)
        .where('username', isLessThanOrEqualTo: '$query\uf8ff')
        .snapshots();
  }

  String currentUserName = "";
  Future getCurrentUserName() async {
    final user = FirebaseAuth.instance.currentUser!.email;
    final data = await FirebaseFirestore.instance
        .collection("Users")
        .where("email", isEqualTo: user)
        .get();
    DocumentSnapshot dataFiles = data.docs.first;
    currentUserName = dataFiles["username"];
  }

  @override
  void initState() {
    super.initState();
    getCurrentUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Search Users"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Search Field
              TextField(
                controller: searchController,
                onChanged: _onSearchChanged, // Trigger on every keystroke
                decoration: InputDecoration(
                  hintText: "Search by username",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      searchController.clear();
                      _onSearchChanged(""); // Clear search
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // User List
              searchController.text.isEmpty
                  ? const SizedBox(
                      height: 500,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text("Enter userName to get result")]),
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.height - 200,
                      width: MediaQuery.of(context).size.width,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _searchUsers(searchQuery),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return const Center(
                                child: Text("Error fetching users"));
                          }

                          final users = snapshot.data?.docs ?? [];
                          if (users.isEmpty) {
                            return const Center(child: Text("No users found"));
                          }
                          for (var i = 0; i < users.length; i++) {
                            if (users[i]["username"] == currentUserName) {
                              users.removeAt(i);
                              break;
                            }
                          }
                          return ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              final user = users[index];

                              return ListTile(
                                onTap: () {
                                  Get.to(
                                      () => SelectedProfileView(
                                            email: user["email"] ?? '',
                                          ),
                                      transition: Transition.rightToLeft);
                                },
                                title: Text(user['username']),
                                subtitle: Text(user['email'] ?? ''),
                                leading: const Icon(Icons.person),
                              );
                            },
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
