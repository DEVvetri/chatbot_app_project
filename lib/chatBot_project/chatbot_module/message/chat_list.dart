import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatListContainer extends StatefulWidget {
  const ChatListContainer({super.key});

  @override
  State<ChatListContainer> createState() => _ChatListContainerState();
}

class _ChatListContainerState extends State<ChatListContainer> {
  final currentUser = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Chat",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const Spacer(),
                PopupMenuButton(
                  child: const Icon(Icons.note_alt_outlined),
                  itemBuilder: (context) {
                    return <PopupMenuEntry<String>>[
                      const PopupMenuItem(child: Text("Group"))
                    ];
                  },
                ),
                const SizedBox(
                  width: 8,
                ),
                PopupMenuButton(
                  child: const Icon(Icons.filter_list_rounded),
                  itemBuilder: (context) {
                    return <PopupMenuEntry<String>>[
                      const PopupMenuItem(
                          child: Row(
                        children: [
                          Icon(Icons.person_2),
                          Text("Group"),
                        ],
                      ))
                    ];
                  },
                )
              ],
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: SizedBox(
                  height: 40,
                  child: TextFormField(
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        enabledBorder: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder()),
                  ),
                )),
              ],
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          Expanded(
              child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("Users").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Error');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final data = snapshot.data!.docs[index];
                  if (data["email"] == currentUser) {
                    return const SizedBox();
                  }
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 25,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data["name"],
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17),
                              ),
                              Text(
                                data.id,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 12),
                              )
                            ],
                          ),
                          const Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              const Text("Time"),
                              const SizedBox(
                                height: 5,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  width: 15,
                                  height: 15,
                                  color: Colors.green,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          )),
        ],
      ),
    );
  }
}
