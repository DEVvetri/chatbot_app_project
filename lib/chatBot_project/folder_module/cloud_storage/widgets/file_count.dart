import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FilesDocumentCount extends StatelessWidget {
  final String foldersCollection;
  final String documentId;
  final String filescollection;
  final bool iscount;

  const FilesDocumentCount(
      {super.key,
      required this.foldersCollection,
      required this.documentId,
      required this.filescollection,
      required this.iscount});

  @override
  Widget build(BuildContext context) {
    if (iscount) {
      return FutureBuilder<int>(
        future: getFilesDocumentCount(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            int count = snapshot.data ?? 0;
            return Text(
              count == 1 || count == 0 ? "$count File" : "$count Files",
              overflow: TextOverflow.ellipsis,
            );
          }
        },
      );
    } else {
      return FutureBuilder<int>(
        future: getTotalSize(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Text(
              // count == 1 || count == 0 ? "$count File" : "$count Files",
              "",
              overflow: TextOverflow.ellipsis,
            );
          }
        },
      );
    }
  }

  Future<int> getFilesDocumentCount() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(foldersCollection)
        .doc(documentId)
        .collection(filescollection)
        .get();

    return querySnapshot.size;
  }

  Future<int> getTotalSize() async {
     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(foldersCollection)
        .doc(documentId)
        .collection(filescollection)
        .get();

    return querySnapshot.size;
    // double totalSize = 0;

    // final querySnapshot = await FirebaseFirestore.instance
    //     .collection(foldersCollection)
    //     .doc(documentId)
    //     .collection(filescollection)
    //     .get();
    // final List<Map<String, dynamic>> files =
    //     querySnapshot.docs.map((doc) => doc.data()).toList();
    // List<String> sizelist = [];
    // for (var element in files) {
    //   sizelist.add(element['file_size']);
    // }
    // for (var sizes in sizelist) {
    //   totalSize += int.parse(sizes);
    // }
    // print(totalSize);

    // return int.parse(totalSize.toString());
  }
}
