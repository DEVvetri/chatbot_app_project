import 'dart:io';
import 'package:chatbot_app_project/chatBot_project/folder_module/cloud_storage/files_views/audio_player_screen.dart';
import 'package:chatbot_app_project/chatBot_project/folder_module/cloud_storage/files_views/image_view_screen.dart';
import 'package:chatbot_app_project/chatBot_project/folder_module/cloud_storage/files_views/pdf_view_screen.dart';
import 'package:chatbot_app_project/firebase/cloud_folder_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';

class MyFilesScreen extends StatefulWidget {
  final DocumentSnapshot documentID;
  const MyFilesScreen({super.key, required this.documentID});

  @override
  State<MyFilesScreen> createState() => _MyFilesScreenState();
}

class _MyFilesScreenState extends State<MyFilesScreen> {
  List<dynamic> filesArray = [];

  TextEditingController fileControler = TextEditingController();
  TextEditingController sharedUsersControler = TextEditingController();
  String folderDocumentID = '';
  String folderName = '';
  String createdBy = '';

  bool documentUploadLoading = false;
  int documentTotalBytes = 0;
  int documentOverallProgress = 0;

  List<UploadTask?> documentUploadTasks = [];

  String fileSize = 'Loading...';
  List<String?> documentDownloadUrls = [];
  List<String?> documentUploadedFileNames = [];
  List<int?> documentUploadedFileSizes = [];
  List<File> documentFiles = [];
  final currentUserEmail = FirebaseAuth.instance.currentUser!.email;
  final shareFoldereFormkey = GlobalKey<FormState>();
  List<dynamic> usersArray = [];

  CloudStorageDataReferance cloudStorageFirestore = CloudStorageDataReferance();

  List<Map<String, dynamic>> userData = [];
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    folderDocumentID = widget.documentID.id;
    folderName = widget.documentID.get('folder_name');
    createdBy = widget.documentID.get('created_by');
 
  }

 

  Future<void> pickAndUploadDocuments() async {
    try {
      FilePickerResult? results =
          await FilePicker.platform.pickFiles(allowMultiple: true);

      if (results != null && results.files.isNotEmpty) {
        documentFiles = results.files.map((file) => File(file.path!)).toList();
        await uploadDocuments(documentFiles);
      } else {}
    } catch (e) {
      debugPrint("Error picking and uploading documents: $e");
    }
  }

  Future<void> uploadDocuments(documentFiles) async {
    try {
      setState(() {
        documentUploadLoading = true;
      });

      for (File documentFile in documentFiles) {
        double documentProgress = 0;
        String? currentUserEmail = FirebaseAuth.instance.currentUser!.email;
        String documentFileName = basename(documentFile.path);
        Reference documentStorageReference = FirebaseStorage.instance
            .ref()
            .child('$currentUserEmail/$folderName/$documentFileName');

        UploadTask documentUploadTask =
            documentStorageReference.putFile(documentFile);

        documentUploadTasks.add(documentUploadTask);

        documentUploadTask.snapshotEvents.listen(
          (event) {
            documentProgress =
                (event.bytesTransferred / event.totalBytes) * 100;

            setState(() {
              documentOverallProgress = documentProgress.toInt();
            });
          },
          onError: (dynamic error) {
            debugPrint('Error during document upload: $error');
          },
          onDone: () async {
            if (documentOverallProgress >= 1) {
              setState(() {
                documentOverallProgress = 0;
              });
            }
          },
        );

        await documentUploadTask.whenComplete(() async {
          debugPrint('Document uploaded');

          String documentDownloadURL =
              await documentStorageReference.getDownloadURL();

          String documentUploadedFileName =
              getUploadedDocumentName(documentDownloadURL);
          setState(() {
            documentDownloadUrls.add(documentDownloadURL);
            documentUploadedFileNames.add(documentUploadedFileName);
          });

          debugPrint('Uploaded Document Name: $documentUploadedFileName');

          File uploadedDocument = File(documentFile.path);
          int documentFileSizeInBytes = await uploadedDocument.length();
          String formattedDocumentFileSize =
              formatFileSize(documentFileSizeInBytes);

          setState(() {
            documentUploadedFileSizes.add(documentFileSizeInBytes);
          });

          debugPrint('Uploaded Document Size: $formattedDocumentFileSize');
          await updateFirestoreWithUrl(
              documentDownloadURL, documentFileSizeInBytes);
        });
      }

      setState(() {
        documentUploadLoading = false;
      });
    } catch (e) {
      debugPrint("Error uploading documents: $e");
      setState(() {
        documentUploadLoading = false;
      });
    }
  }

  Future<void> updateFirestoreWithUrl(
      String downloadUrl, int documentFileSizeInBytes) async {
    try {
      await cloudStorageFirestore.addFiles(
          documentID: widget.documentID.id,
          downloadUrl: downloadUrl,
          fileSize: documentFileSizeInBytes);
      debugPrint('Firestore updated with URL: $downloadUrl');
    } catch (e) {
      debugPrint('Error updating Firestore: $e');
    }
  }

  String getUploadedDocumentName(String url) {
    String documentFileName = basename(Uri.parse(url).path);
    List<String> documentFileNameParts = documentFileName.split('%2F');
    if (documentFileNameParts.length > 1) {
      documentFileName = Uri.decodeComponent(documentFileNameParts.last);
    }

    documentDownloadUrls.add(url);

    return documentFileName;
  }

  String formatFileSize(int fileSizeInBytes) {
    const int sizeKB = 1024;
    const int sizeMB = sizeKB * 1024;
    const int sizeGB = sizeMB * 1024;

    if (fileSizeInBytes >= sizeGB) {
      return '${(fileSizeInBytes / sizeGB).toStringAsFixed(2)} GB';
    } else if (fileSizeInBytes >= sizeMB) {
      return '${(fileSizeInBytes / sizeMB).toStringAsFixed(2)} MB';
    } else if (fileSizeInBytes >= sizeKB) {
      return '${(fileSizeInBytes / sizeKB).toStringAsFixed(2)} KB';
    } else {
      return '$fileSizeInBytes bytes';
    }
  }

  Future getUsers() async {
    await FirebaseFirestore.instance
        .collection('Cloud-Storage')
        .doc(widget.documentID.id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        debugPrint(data['users_email']);
        return data['users_email'];
      } else {
        debugPrint('Document does not exist on the database');
      }
    });
  }

  String getDownloadedFileName(String url) {
    String fileName = basename(Uri.parse(url).path);
    fileName = Uri.decodeComponent(fileName.split('%2F').last);
    return fileName;
  }

  List<String> forListView = [];
  getListDate() async {
    var data = await FirebaseFirestore.instance
        .collection('Cloud-Storage')
        .doc(widget.documentID.id)
        .get();
    var userData = data.data()!['sharing'];
    for (var user in userData) {
      forListView.add(user['user_name']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          if (documentUploadLoading)
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Uploading...',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          if (documentUploadTasks.isNotEmpty)
                            Text(
                              '${(documentOverallProgress).toStringAsFixed(2)}%',
                            ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      for (int i = 0; i < documentUploadTasks.length; i++)
                        ListTile(
                          leading: (!documentUploadLoading &&
                                  documentDownloadUrls.isNotEmpty)
                              ? Icon(
                                  Icons.check_circle_rounded,
                                  color: Theme.of(context).colorScheme.primary,
                                )
                              : const Icon(
                                  Icons.pending_rounded,
                                ),
                          title: Text((!documentUploadLoading &&
                                  documentDownloadUrls.isNotEmpty)
                              ? '${documentUploadedFileNames[i]}'
                              : 'Select PDF Book file'),
                          subtitle: (documentUploadLoading)
                              ? LinearProgressIndicator(
                                  value: documentUploadTasks[i] != null
                                      ? (documentUploadTasks[i]!
                                              .snapshot
                                              .bytesTransferred /
                                          documentUploadTasks[i]!
                                              .snapshot
                                              .totalBytes)
                                      : null,
                                )
                              : (!documentUploadLoading &&
                                      documentDownloadUrls.isNotEmpty)
                                  ? Text(
                                      formatFileSize(
                                        documentUploadedFileSizes[i] ?? 0,
                                      ),
                                    )
                                  : null,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Card(
                                  child: StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('Cloud-Storage')
                                        .doc(widget.documentID.id)
                                        .collection("Files")
                                        .snapshots(),
                                    builder: (
                                      context,
                                      snapshot,
                                    ) {
                                      if (snapshot.hasError) {
                                        return const Center(
                                          child: Text(
                                            'Something went wrong',
                                          ),
                                        );
                                      }
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }

                                      return ListView.builder(
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index) {
                                          final data =
                                              snapshot.data!.docs[index];
                                          String fileName =
                                              getDownloadedFileName(
                                            data['file_url'],
                                          );
                                          final listBool = fileName.split(".");
                                          return ListTile(
                                            onTap: () => Get.to(
                                              () => listBool[listBool.length -
                                                          1] ==
                                                      "pdf"
                                                  ? PDfViewScreen(
                                                      documentID: data,
                                                      fileName: fileName)
                                                  : listBool[listBool.length -
                                                              1] ==
                                                          "mp3"
                                                      ? AudioPlayerForFile(
                                                          documentID: data,
                                                          audioName: fileName)
                                                      : ImageViewScreen(
                                                          documentID: data,
                                                          fileName: fileName),
                                              transition: Transition.cupertino,
                                            ),
                                            leading: Icon(
                                              listBool[listBool.length - 1] ==
                                                      "pdf"
                                                  ? Icons.picture_as_pdf
                                                  : listBool[listBool.length -
                                                              1] ==
                                                          "docx"
                                                      ? Icons.edit_document
                                                      : listBool[listBool
                                                                      .length -
                                                                  1] ==
                                                              "mp4"
                                                          ? Icons.video_file
                                                          : listBool[listBool
                                                                          .length -
                                                                      1] ==
                                                                  "mp3"
                                                              ? Icons.music_note
                                                              : Icons.image,
                                              size: 30,
                                            ),
                                            title: Text(
                                              fileName,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            subtitle: Text(
                                              formatFileSize(data['file_size']),
                                            ),
                                            trailing: (userData.isNotEmpty &&
                                                    userData[0]['permissions'][
                                                                'cloud_storage']
                                                            ['delete_files'] ==
                                                        true)
                                                ? (createdBy ==
                                                        currentUserEmail)
                                                    ? IconButton(
                                                        onPressed: () {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (context) =>
                                                                    AlertDialog(
                                                              title: const Text(
                                                                'Delete File',
                                                              ),
                                                              content: Text(
                                                                ' Are You Sure to delete "$fileName" form $folderName folder?',
                                                                style:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                              ),
                                                              actions: [
                                                                OutlinedButton(
                                                                  onPressed:
                                                                      () {
                                                                    Get.back();
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    'Cancel',
                                                                  ),
                                                                ),
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () async {
                                                                    cloudStorageFirestore
                                                                        .deleteFile(
                                                                          fileDocumentID:
                                                                              data.id,
                                                                          folderDocumentID: widget
                                                                              .documentID
                                                                              .id,
                                                                        )
                                                                        .whenComplete(() =>
                                                                            Navigator.of(context).pop());
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    'Delete',
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                        icon: const Icon(
                                                            Icons.delete),
                                                      )
                                                    : null
                                                : null,
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
