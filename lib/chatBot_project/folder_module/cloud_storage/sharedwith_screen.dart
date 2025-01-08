import 'package:chatbot_app_project/firebase/cloud_folder_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SharedwithScreen extends StatefulWidget {
  final DocumentSnapshot documentID;

  const SharedwithScreen({super.key, required this.documentID});

  @override
  State<SharedwithScreen> createState() => _SharedwithScreenState();
}

class _SharedwithScreenState extends State<SharedwithScreen> {
  List<Map<String, dynamic>> userData = [];
  final currentUser = FirebaseAuth.instance.currentUser;
  final currentUserEmail = FirebaseAuth.instance.currentUser!.email;
  String createdBy = '';
  final shareFoldereFormkey = GlobalKey<FormState>();
  TextEditingController sharedUsersControler = TextEditingController();
  CloudStorageDataReferance cloudStorageFirestore = CloudStorageDataReferance();
  @override
  void initState() {
    createdBy = widget.documentID.get('created_by');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Shared With",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (createdBy == currentUserEmail)
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text(
                                'Share With',
                              ),
                              content: SizedBox(
                                width: 350,
                                child: Form(
                                  key: shareFoldereFormkey,
                                  child: TextFormField(
                                    autofocus: true,
                                    controller: sharedUsersControler,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Email cannot be empty";
                                      }
                                      if (!RegExp(
                                              "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                          .hasMatch(value)) {
                                        return ("Please enter a valid email");
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                              ),
                              actions: [
                                OutlinedButton(
                                  onPressed: () {
                                    sharedUsersControler.clear();
                                    Get.back();
                                  },
                                  child: const Text(
                                    'Cancel',
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (shareFoldereFormkey.currentState!
                                        .validate()) {
                                      try {
                                        cloudStorageFirestore
                                            .addUser(
                                                documentID:
                                                    widget.documentID.id,
                                                userEmail:
                                                    sharedUsersControler.text,
                                                dataNow: DateTime.now())
                                            .whenComplete(() {
                                          sharedUsersControler.clear();
                                          Get.back();
                                        });
                                      } catch (e) {
                                        debugPrint(
                                          e.toString(),
                                        );
                                      }
                                    }
                                  },
                                  child: const Text(
                                    'Share',
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text(
                          "Share",
                        ),
                      ),
                  ],
                ),
                Expanded(
                    child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Cloud-Storage')
                      .doc(widget.documentID.id)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(child: CircularProgressIndicator());
                      default:
                        Map<String, dynamic> data =
                            snapshot.data!.data() as Map<String, dynamic>;

                        return ListView.builder(
                          itemCount: data['sharing'].length,
                          itemBuilder: (context, index) {
                            var addedTime = data['sharing'][index]["added_time"]
                                as Timestamp;
                            var splitTimeDate =
                                TimeOfDay.fromDateTime(addedTime.toDate());

                            return ListTile(
                                title: Text(data['sharing'][index]["user_name"]
                                    .toString()),
                                subtitle: Text(splitTimeDate.format(context)),
                                trailing: IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text(
                                                'Note',
                                              ),
                                              content: Text(
                                                ' Are You Sure to Remove "${data['sharing'][index]["user_name"].toString()}" from sharing list?',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                              //     Row(
                                              //   children: [
                                              //     const Text("Sure to Remove "),
                                              //     Text(
                                              //       '"${data['sharing'][index]["user_name"].toString()}"',
                                              //       style: const TextStyle(fontWeight: FontWeight.bold),
                                              //     ),
                                              //     const Text(" from sharing list?")
                                              //   ],
                                              // ),
                                              actions: [
                                                OutlinedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text(
                                                    'Cancel',
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    cloudStorageFirestore
                                                        .removeUser(
                                                            folderDocumentID:
                                                                widget
                                                                    .documentID
                                                                    .id,
                                                            sharedSetData: {
                                                          'user_name':
                                                              data['sharing']
                                                                      [index]
                                                                  ['user_name'],
                                                          'email':
                                                              data['sharing']
                                                                      [index]
                                                                  ['email'],
                                                          'added_time': data[
                                                                      'sharing']
                                                                  [index]
                                                              ['added_time'],
                                                        });
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text(
                                                    'Remove',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.cancel))
                                    );
                          },
                        );
                    }
                  },
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
