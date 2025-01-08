import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

class ImageViewScreen extends StatefulWidget {
  final DocumentSnapshot documentID;
  final String fileName;

  const ImageViewScreen(
      {super.key, required this.documentID, required this.fileName});

  @override
  State<ImageViewScreen> createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  String imgfileUrl = '';
  List<Map<String, dynamic>> userData = [];
  final currentUser = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    imgfileUrl = widget.documentID.get('file_url');
   
    super.initState();
  }

  

  Future<void> _launchUrl() async {
    if (!await launchUrl(Uri.parse(imgfileUrl))) {
      throw Exception('Could not launch ${Uri.parse(imgfileUrl)}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.fileName),
          actions: [
            if (userData.isNotEmpty &&
                userData[0]['permissions']['cloud_storage']['download_files'] ==
                    true)
              IconButton(
                  onPressed: _launchUrl,
                  icon: const Icon(Icons.download))
          ],
        ),
        body: PhotoView(
          enablePanAlways: true,
          imageProvider: NetworkImage(imgfileUrl),
        ));
  }
}
