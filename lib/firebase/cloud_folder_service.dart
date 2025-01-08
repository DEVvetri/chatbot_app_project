
//Cloud Storage API
import 'package:cloud_firestore/cloud_firestore.dart';

class CloudStorageDataReferance {
  final CollectionReference coludStorage =
      FirebaseFirestore.instance.collection("Cloud-Storage");

//Add Folder
  Future<dynamic> addFolder({
    required String folderName,
    required String createdBy,
  }) async {
    final newDocument =
        FirebaseFirestore.instance.collection("Cloud-Storage").doc();

    await newDocument.set(
      {
        'folder_name': folderName,
        'created_at': FieldValue.serverTimestamp(),
        "created_by": createdBy,
        "sharing": [],
      },
    );
  }

//Update Folder Name
  Future<dynamic> updateFolderName({
    required String documentID,
    required String folderName,
  }) async {
    await coludStorage.doc(documentID).update(
      {
        'folder_name': folderName,
      },
    );
  }

//update count increment
  Future<dynamic> updateFolderCountIncrement({
    required String documentID,
  }) async {
    await // Increment the file_count field by 1
        coludStorage
            .doc(documentID)
            .update({'file_count': FieldValue.increment(1)});
  }

//update count increment
  Future<dynamic> updateFolderCountDecrement({
    required String documentID,
  }) async {
    await
// Decrement the file_count field by 1
        coludStorage
            .doc(documentID)
            .update({'file_count': FieldValue.increment(-1)});
  }

//Delete Folder
  Future<dynamic> deleteFolder({
    required String documentId,
  }) {
    return coludStorage.doc(documentId).delete();
  }

  //addfiles
  Future<dynamic> addFiles({
    required String documentID,
    required String downloadUrl,
    required int fileSize,
  }) async {
    await coludStorage.doc(documentID).collection("Files").doc().set(
      {
        'file_url': downloadUrl,
        'uploaded_at': FieldValue.serverTimestamp(),
        'file_size': fileSize,
      },
    );
    updateFolderCountIncrement(documentID: documentID);
  }

  //Delete File
  Future<dynamic> deleteFile({
    required String folderDocumentID,
    required String fileDocumentID,
  }) {
    return coludStorage
        .doc(folderDocumentID)
        .collection("Files")
        .doc(fileDocumentID)
        .delete();
  }

//Add User
  Future<dynamic> addUser({
    required String documentID,
    required String userEmail,
    required DateTime dataNow,
  }) async {
    List<String> userNames = [];
    await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: userEmail)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        userNames.add(querySnapshot.docs.first.get('name'));
      }
    });

    await coludStorage.doc(documentID).update({
      'sharing': FieldValue.arrayUnion([
        {
          'user_name': userNames[0],
          'email': userEmail,
          'added_time': dataNow,
        }
      ])
    });
  }

  List<String> list = [];
  List<String> listTime = [];

  late int founded;
  //Remove User
  Future<dynamic> removeUser({
    required String folderDocumentID,
    required Map<String, dynamic> sharedSetData,
  }) async {
    return coludStorage.doc(folderDocumentID).update({
      'sharing': FieldValue.arrayRemove([sharedSetData])
    });
  }
}