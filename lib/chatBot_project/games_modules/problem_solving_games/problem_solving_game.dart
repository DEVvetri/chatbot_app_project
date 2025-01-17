// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class SimulationGameScreen extends StatefulWidget {
  const SimulationGameScreen({super.key});

  @override
  _SimulationGameScreenState createState() => _SimulationGameScreenState();
}

class _SimulationGameScreenState extends State<SimulationGameScreen> {
  int _currentScenario = 0;
  int _score = 0;

  final List<Map<String, dynamic>> _scenarios = [
    {
      'question': 'You are lost in a forest. What do you do first?',
      'options': ['Build a shelter', 'Look for water', 'Panic'],
      'correct': 1, // Index of the correct answer
    },
    {
      'question': 'You see a fire starting in your home. What should you do?',
      'options': ['Call for help', 'Use water', 'Run away'],
      'correct': 0,
    },
    // Add more scenarios here
  ];

  void _answerQuestion(int selectedIndex) {
    setState(() {
      if (selectedIndex == _scenarios[_currentScenario]['correct']) {
        _score += 10; // Award points for correct answer
      }
      if (_currentScenario < _scenarios.length - 1) {
        _currentScenario++;
      } else {
        _showResultDialog();
      }
    });
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
                _currentScenario = 0;
                _score = 0;
              });
              Navigator.of(ctx).pop();
            },
            child: Text('Play Again'),
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
          backgroundColor: Colors.blueAccent, title: Text('Simulation Game')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _scenarios[_currentScenario]['question'],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ..._scenarios[_currentScenario]['options'].map<Widget>((option) {
              int index =
                  _scenarios[_currentScenario]['options'].indexOf(option);
              return ElevatedButton(
                onPressed: () => _answerQuestion(index),
                child: Text(option),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
