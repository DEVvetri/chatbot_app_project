import 'package:chatbot_app_project/chatBot_project/folder_module/cloud_storage/files_screen.dart';
import 'package:chatbot_app_project/chatBot_project/folder_module/cloud_storage/widgets/file_count.dart';
import 'package:chatbot_app_project/firebase/cloud_folder_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FoldersScreen extends StatefulWidget {
  const FoldersScreen({super.key});

  @override
  State<FoldersScreen> createState() => _FoldersScreenState();
}

class _FoldersScreenState extends State<FoldersScreen> {
  TextEditingController folderNameControler = TextEditingController();
  TextEditingController renameFolderControler = TextEditingController();
  TextEditingController sharedUsersControler = TextEditingController();
  final currentUserEmail = FirebaseAuth.instance.currentUser!.email;
  final renameFoldereFormkey = GlobalKey<FormState>();
  final addFoldereFormkey = GlobalKey<FormState>();
  final shareFoldereFormkey = GlobalKey<FormState>();
  var cloudFirebase = FirebaseFirestore.instance.collection('Cloud-Storage');
  CloudStorageDataReferance cloudStorageFirestore = CloudStorageDataReferance();

  List<Map<String, dynamic>> userData = [];
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          label: const Text(
            'New Folder',
          ),
          onPressed: () {
            newFolderMethod(context);
          },
        ),
        appBar: AppBar(
          title: const Text('Cloud Storage'),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.label,
                isScrollable: true,
                labelPadding: EdgeInsets.only(right: 20, left: 20),
                dividerColor: Colors.transparent,
                tabs: [
                  Tab(
                    child: Text(
                      'My Drive',
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Shared',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            //My Drive
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                child: SizedBox(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Cloud-Storage')
                        .where('created_by', isEqualTo: currentUserEmail)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                            'Error',
                          ),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: calculateCrossAxisCount(context),
                          childAspectRatio: 1 / 1,
                        ),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final data = snapshot.data!.docs[index];

                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: InkWell(
                              onTap: () {
                                Get.to(
                                  () => FilesScreen(
                                    documentID: data,
                                  ),
                                  transition: Transition.cupertino,
                                );
                              },
                              child: AspectRatio(
                                aspectRatio: 1 / 1,
                                child: Card(
                                  elevation: 0,
                                  surfaceTintColor:
                                      Theme.of(context).colorScheme.background,
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(
                                            totalWidth < 800 ? 10.0 : 5.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const SizedBox(),
                                            Icon(
                                              Icons.folder,
                                              size: 50,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                            Text(
                                              data["folder_name"],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                FilesDocumentCount(
                                                  foldersCollection:
                                                      'Cloud-Storage',
                                                  documentId: data.id,
                                                  filescollection: 'Files',
                                                  iscount: true,
                                                ),
                                                FilesDocumentCount(
                                                  foldersCollection:
                                                      'Cloud-Storage',
                                                  documentId: data.id,
                                                  filescollection: 'Files',
                                                  iscount: false,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: PopupMenuButton<String>(
                                          itemBuilder: (BuildContext context) {
                                            return <PopupMenuEntry<String>>[
                                              PopupMenuItem<String>(
                                                value: 'Rename',
                                                child: const Text('Rename'),
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      title: const Text(
                                                        'Rename Folder',
                                                      ),
                                                      content: SizedBox(
                                                        width: 350,
                                                        child: Form(
                                                          key:
                                                              renameFoldereFormkey,
                                                          child: TextFormField(
                                                            autofocus: true,
                                                            controller: renameFolderControler =
                                                                TextEditingController(
                                                                    text: data[
                                                                        'folder_name']),
                                                            decoration:
                                                                InputDecoration(
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                              ),
                                                            ),
                                                            validator: (value) {
                                                              RegExp regex =
                                                                  RegExp(
                                                                      r'^.{1,}$');
                                                              if (value!
                                                                  .isEmpty) {
                                                                return "Folder Name cannot be empty";
                                                              }
                                                              if (!regex
                                                                  .hasMatch(
                                                                      value)) {
                                                                return ("Please enter valid Folder Namer");
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
                                                            renameFolderControler
                                                                .clear();
                                                            Get.back();
                                                          },
                                                          child: const Text(
                                                            'Cancel',
                                                          ),
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () async {
                                                            if (renameFoldereFormkey
                                                                .currentState!
                                                                .validate()) {
                                                              try {
                                                                await cloudStorageFirestore
                                                                    .updateFolderName(
                                                                  documentID:
                                                                      data.id,
                                                                  folderName:
                                                                      renameFolderControler
                                                                          .text,
                                                                )
                                                                    .whenComplete(
                                                                  () {
                                                                    renameFolderControler
                                                                        .clear();
                                                                    Get.back();
                                                                  },
                                                                );
                                                              } catch (e) {
                                                                debugPrint(
                                                                  e.toString(),
                                                                );
                                                              }
                                                            }
                                                          },
                                                          child: const Text(
                                                            'Update',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                              PopupMenuItem<String>(
                                                value: 'AddUser',
                                                child: const Text('Share With'),
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      title: const Text(
                                                        'Share with',
                                                      ),
                                                      content: SizedBox(
                                                        width: 350,
                                                        child: Form(
                                                          key:
                                                              shareFoldereFormkey,
                                                          child: TextFormField(
                                                            controller:
                                                                sharedUsersControler,
                                                            autofocus: true,
                                                            decoration:
                                                                InputDecoration(
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                              ),
                                                            ),
                                                            validator: (value) {
                                                              if (value!
                                                                  .isEmpty) {
                                                                return "Email cannot be empty";
                                                              }
                                                              if (!RegExp(
                                                                      "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                                                  .hasMatch(
                                                                      value)) {
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
                                                            sharedUsersControler
                                                                .clear();
                                                            Get.back();
                                                          },
                                                          child: const Text(
                                                            'Cancel',
                                                          ),
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            if (shareFoldereFormkey
                                                                .currentState!
                                                                .validate()) {
                                                              try {
                                                                cloudStorageFirestore
                                                                    .addUser(
                                                                        documentID: data
                                                                            .id
                                                                            .toString(),
                                                                        userEmail:
                                                                            sharedUsersControler
                                                                                .text,
                                                                        dataNow:
                                                                            DateTime
                                                                                .now())
                                                                    .whenComplete(
                                                                        () {
                                                                  sharedUsersControler
                                                                      .clear();
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
                                              ),
                                              PopupMenuItem<String>(
                                                value: 'Delete',
                                                child: const Text('Delete'),
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      title: const Text(
                                                        'Delete Folder',
                                                      ),
                                                      content: Text(
                                                        ' Are You Sure to delete "${data["folder_name"]}" Folder?',
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                      actions: [
                                                        OutlinedButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: const Text(
                                                            'Cancel',
                                                          ),
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () async {
                                                            cloudStorageFirestore
                                                                .deleteFolder(
                                                                    documentId:
                                                                        data.id);
                                                            Get.back();
                                                          },
                                                          child: const Text(
                                                            'Yes',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ];
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            //Shared Folder
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                child: SizedBox(
                    child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Cloud-Storage')
                      .where("created_by", isNotEqualTo: currentUserEmail)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'Error',
                        ),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: calculateCrossAxisCount(context),
                        childAspectRatio: 1 / 1,
                      ),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final data = snapshot.data!.docs[index];

                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: InkWell(
                            onTap: () {
                              Get.to(
                                () => FilesScreen(
                                  documentID: data,
                                ),
                                transition: Transition.cupertino,
                              );
                            },
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: Card(
                                elevation: 0,
                                surfaceTintColor:
                                    Theme.of(context).colorScheme.background,
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const SizedBox(),
                                          Icon(
                                            Icons.folder_shared,
                                            size: 50,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                          Text(
                                            data["folder_name"],
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              FilesDocumentCount(
                                                foldersCollection:
                                                    'Cloud-Storage',
                                                documentId: data.id,
                                                filescollection: 'Files',
                                                iscount: true,
                                              ),
                                              FilesDocumentCount(
                                                foldersCollection:
                                                    'Cloud-Storage',
                                                documentId: data.id,
                                                filescollection: 'Files',
                                                iscount: false,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> newFolderMethod(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'New Folder',
        ),
        content: SizedBox(
          width: 350,
          child: Form(
            key: addFoldereFormkey,
            child: TextFormField(
              autofocus: true,
              controller: folderNameControler,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              validator: (value) {
                RegExp regex = RegExp(r'^.{1,}$');
                if (value!.isEmpty) {
                  return "Folder Name cannot be empty";
                }
                if (!regex.hasMatch(value)) {
                  return ("Please enter valid Folder Name");
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
              folderNameControler.clear();
              Get.back();
            },
            child: const Text(
              'Cancel',
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (addFoldereFormkey.currentState!.validate()) {
                try {
                  await cloudStorageFirestore
                      .addFolder(
                    folderName: folderNameControler.text,
                    createdBy: currentUserEmail.toString(),
                  )
                      .whenComplete(() {
                    folderNameControler.clear();
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
              'Create',
            ),
          ),
        ],
      ),
    );
  }

  int calculateCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = (screenWidth / 200).floor();
    return crossAxisCount > 0 ? crossAxisCount : 1;
  }
}
