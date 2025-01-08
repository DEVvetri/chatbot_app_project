import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PDfViewScreen extends StatefulWidget {
  final DocumentSnapshot documentID;
  final String fileName;

  const PDfViewScreen(
      {super.key, required this.documentID, required this.fileName});

  @override
  State<PDfViewScreen> createState() => _PDfViewScreenState();
}

class _PDfViewScreenState extends State<PDfViewScreen> {
  String pdffileUrl = '';
  List<Map<String, dynamic>> userData = [];
  final currentUser = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    pdffileUrl = widget.documentID.get('file_url');

    super.initState();
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(Uri.parse(pdffileUrl))) {
      throw Exception('Could not launch ${Uri.parse(pdffileUrl)}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.fileName),
          actions: [
            IconButton(onPressed: _launchUrl, icon: const Icon(Icons.download))
          ],
        ),
        body: Center(
          child: Text(pdffileUrl),
        ));
  }
}
