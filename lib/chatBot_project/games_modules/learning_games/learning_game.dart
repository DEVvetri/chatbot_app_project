// ignore_for_file: library_private_types_in_public_api

import 'dart:math';

import 'package:flutter/material.dart';

class AdaptiveGameScreen extends StatefulWidget {
  const AdaptiveGameScreen({super.key});

  @override
  _AdaptiveGameScreenState createState() => _AdaptiveGameScreenState();
}

class _AdaptiveGameScreenState extends State<AdaptiveGameScreen> {
  int _score = 0;
  int _level = 1;
  late int _num1;
  late int _num2;
  late int _answer;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  void _generateQuestion() {
    setState(() {
      _num1 = Random().nextInt(10 * _level) + 1;
      _num2 = Random().nextInt(10 * _level) + 1;
      _answer = _num1 + _num2;
    });
  }

  void _submitAnswer() {
    if (int.tryParse(_controller.text) == _answer) {
      setState(() {
        _score += 10;
        if (_score % 50 == 0) {
          _level++; // Increase level every 50 points
        }
        _generateQuestion();
      });
    } else {
      _showResultDialog();
    }
    _controller.clear();
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.transparent,
        content: SizedBox(
          height: 300,
          child: Column(
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/gameOver.png'))),
              ),
              Text('Your score is $_score'),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                _score = 0;
                _level = 1;
                _generateQuestion();
              });
              Navigator.of(ctx).pop();
            },
            child: Text('Restart'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text('Adaptive Learning Game')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Level: $_level',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Solve: $_num1 + $_num2 = ?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                enabledBorder: UnderlineInputBorder(),
                labelText: 'Your Answer',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitAnswer,
              child: Text('Submit Answer'),
            ),
            SizedBox(height: 20),
            Text(
              'Score: $_score',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
