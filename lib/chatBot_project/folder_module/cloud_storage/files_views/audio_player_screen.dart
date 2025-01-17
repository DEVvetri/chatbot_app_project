// ignore_for_file: deprecated_member_use

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AudioPlayerForFile extends StatefulWidget {
  final DocumentSnapshot documentID;
  final String audioName;
  const AudioPlayerForFile(
      {super.key, required this.documentID, required this.audioName});

  @override
  State<AudioPlayerForFile> createState() => _AudioPlayerForFileState();
}

class _AudioPlayerForFileState extends State<AudioPlayerForFile> {
  String audioLink = '';

  Color dynamicBackgroundColor = Colors.white;
  Color dynamicTextColor = Colors.black;

  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration audioDuration = const Duration();
  Duration audioPosition = const Duration();
    List<Map<String, dynamic>> userData = [];
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    audioLink = widget.documentID.get('file_url');

    audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        audioDuration = d;
      });
    });

      

    audioPlayer.onPositionChanged.listen((Duration p) {
      if (mounted) {
        setState(() {
          audioPosition = p;
        });
      }
      if (audioPosition >= audioDuration) {
        setState(() {
          isPlaying = false;
        });
      }
    });
 
    super.initState();
  }

 

  @override
  void dispose() {
    audioPlayer.stop();
    super.dispose();
  }

  // Future<void> _launchUrl() async {
  //   if (!await _launchUrl(Uri.parse(audioLink))) {
  //     throw Exception('Could not launch ${Uri.parse(audioLink)}');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: (){}, icon: const Icon(Icons.download))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(),
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: double.infinity,
                  height: 250,
                ),
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: dynamicBackgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment:MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                         ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.audioName,
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: (totalWidth > 1000) ? dynamicTextColor : null,
                        ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            const SizedBox(
              height: 20,
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${audioPosition.inMinutes}:${(audioPosition.inSeconds % 60).toString().padLeft(2, '0')}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${audioDuration.inMinutes}:${(audioDuration.inSeconds % 60).toString().padLeft(2, '0')}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Slider(
                      value: audioPosition.inSeconds.toDouble(),
                      onChanged: (double value) {
                        audioPlayer.seek(Duration(seconds: value.toInt()));
                      },
                      min: 0.0,
                      max: audioDuration.inSeconds.toDouble(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        (isPlaying == true)
                            ? IconButton(
                                icon: const Icon(Icons.pause),
                                onPressed: () {
                                  audioPlayer.pause();
                                  setState(() {
                                    isPlaying = false;
                                  });
                                },
                              )
                            : IconButton(
                                icon: const Icon(Icons.play_arrow),
                                onPressed: () {
                                  audioPlayer.play(
                                    UrlSource(
                                      widget.documentID
                                          .get('file_url')
                                          .toString(),
                                    ),
                                  );
                                  setState(() {
                                    isPlaying = true;
                                  });
                                },
                              ),
                        IconButton(
                          icon: const Icon(Icons.stop),
                          onPressed: () {
                            audioPlayer.stop();
                            setState(() {
                              isPlaying = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
