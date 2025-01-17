// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:chatbot_app_project/chatBot_project/folder_module/cloud_storage/myfile_screen.dart';
import 'package:chatbot_app_project/chatBot_project/folder_module/cloud_storage/sharedwith_screen.dart';
import 'package:chatbot_app_project/firebase/cloud_folder_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class FilesScreen extends StatefulWidget {
  final DocumentSnapshot documentID;
  const FilesScreen({super.key, required this.documentID});

  @override
  State<FilesScreen> createState() => _FilesScreenState();
}

class _FilesScreenState extends State<FilesScreen> {
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

  

  Future<void> uploadDocuments(documentFiles) async {
    try {
      setState(() {
        documentUploadLoading = true;
      });

      if (kIsWeb) {
        for (PlatformFile file in documentFiles) {
          final fileBytes = file.bytes;
          if (fileBytes != null) {
            final fileName = file.name;

            Reference documentStorageReference = FirebaseStorage.instance
                .ref()
                .child('$currentUserEmail/$folderName/$fileName');

            UploadTask documentUploadTask =
                documentStorageReference.putData(fileBytes);

            documentUploadTasks.add(documentUploadTask);

            documentUploadTask.snapshotEvents.listen(
              (event) {
                double documentProgress =
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

              int documentFileSizeInBytes = fileBytes.length;
              debugPrint("---->Bytes$documentFileSizeInBytes");
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
        }
      } else {
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
            debugPrint("---->Bytes$documentFileSizeInBytes");

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

  Future<void> pickAndUploadDocuments() async {
    try {
      FilePickerResult? results = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
      );

      if (results != null && results.files.isNotEmpty && kIsWeb) {
        List<PlatformFile> documentFiles = results.files;
        await uploadDocuments(documentFiles);
      } else if (results != null && results.files.isNotEmpty) {
        documentFiles = results.files.map((file) => File(file.path!)).toList();
        await uploadDocuments(documentFiles);
      } else {}
    } catch (e) {
      debugPrint("Error picking and uploading documents: $e");
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

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton:  FloatingActionButton.extended(
                label: const Text(
                  'Files Upload',
                ),
                onPressed: () {
                  documentUploadLoading ? null : pickAndUploadDocuments();
                },
              ),
        appBar: AppBar(
            title: Text(folderName),
           
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
                              'Files',
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Shared With',
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ),
        body:
        //  (totalWidth > 1000)
            // ? Center(
            //     child: Column(
            //       children: [
            //         Expanded(
            //           child: Padding(
            //             padding: const EdgeInsets.all(10.0),
            //             child: Column(
            //               children: [
            //                 Expanded(
            //                   child: Column(
            //                     children: [
            //                       Expanded(
            //                         child: Row(
            //                           children: [
            //                             Expanded(
            //                               child: MyFilesScreen(
            //                                 documentID: widget.documentID,
            //                               ),
            //                             ),
            //                             SharedwithScreen(
            //                               documentID: widget.documentID,
            //                             ),
            //                           ],
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         )
            //       ],
            //     ),
            //   )
             TabBarView(
                children: [
                  SizedBox(
                      width: 300,
                      child: MyFilesScreen(documentID: widget.documentID)),
                  SharedwithScreen(documentID: widget.documentID)
                ],
              ),
      ),
    );
  }

  int calculateCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = (screenWidth / 200).floor();
    return crossAxisCount > 0 ? crossAxisCount : 1;
  }
}
