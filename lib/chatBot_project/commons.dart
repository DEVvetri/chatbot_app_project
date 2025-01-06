// ignore_for_file: unused_field


import 'package:flutter/material.dart';

class Commons{
  Color black1Color = Color.fromARGB(255, 20, 20, 20);
  Color black2Color = Color.fromARGB(255, 35, 35, 35);
  Color blueColor = Color.fromARGB(255, 137, 217, 242);
  Color whiteColor = Color.fromARGB(255, 255, 255, 255);
  
   final Map<String, List<String>> _ideas = {
    "mobile app": [
      "Create a personal expense tracker app.",
      "Develop a habit tracker with gamification features.",
      "Build a social media app for niche communities.",
    ],
    "web app": [
      "Build a portfolio website generator.",
      "Create a task management tool for remote teams.",
      "Develop an AI-powered resume builder.",
    ],
    "AI/ML": [
      "Create a chatbot for mental health support.",
      "Build a machine learning model for predictive analytics.",
      "Develop an AI system to generate personalized learning paths for students.",
    ],
    "game": [
      "Build a simple puzzle game using Unity or Flutter.",
      "Create an educational game for kids.",
      "Develop a multiplayer trivia quiz app.",
    ],
    "general": [
      "Work on an open-source project.",
      "Create a productivity tool for developers.",
      "Build an app that integrates multiple APIs (e.g., weather, maps, etc.).",
    ],
  };



  double getSizeOf(BuildContext context, String giveMe) {
    double widthSize = MediaQuery.of(context).size.width;
    double heightSize = MediaQuery.of(context).size.height;
    if (giveMe == "w") {
      return widthSize;
    }
    return heightSize;
  }

 
}

