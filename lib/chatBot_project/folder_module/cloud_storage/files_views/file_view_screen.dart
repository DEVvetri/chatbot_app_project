import 'package:flutter/material.dart';

class FileViewScreen extends StatelessWidget {
  final String fileLink;
  const FileViewScreen({super.key,required this.fileLink});


  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      body: Center(child: Column(children: [
        const BackButton(),
        Text(fileLink)
      ]),),
    );
  }
}