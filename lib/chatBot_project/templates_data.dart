import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  String message;
  bool isMe;
  ChatMessage({required this.isMe, required this.message});
}

class UserProfile {
  String username;
  String name;
  String profilePicture;
  bool isPrivate;
  String selectedDomain;
  List<String> interestedDomains;
  double highestScore;
  double lowestScore;
  String levelOfDifficulty;

  UserProfile({
    required this.username,
    required this.name,
    required this.profilePicture,
    required this.isPrivate,
    required this.selectedDomain,
    required this.interestedDomains,
    required this.highestScore,
    required this.lowestScore,
    required this.levelOfDifficulty,
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return UserProfile(
      username: data['username'] ?? '',
      name: data['name'] ?? '',
      profilePicture: data['profilePicture'] ?? '',
      isPrivate: data['isPrivate'] ?? false,
      selectedDomain: data['selectedDomain'] ?? '',
      interestedDomains: List<String>.from(data['interestedDomains'] ?? []),
      highestScore: (data['highestScore'] ?? 0).toDouble(),
      lowestScore: (data['lowestScore'] ?? 0).toDouble(),
      levelOfDifficulty: data['levelOfDifficulty'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'username': username,
      'name': name,
      'profilePicture': profilePicture,
      'isPrivate': isPrivate,
      'selectedDomain': selectedDomain,
      'interestedDomains': interestedDomains,
      'highestScore': highestScore,
      'lowestScore': lowestScore,
      'levelOfDifficulty': levelOfDifficulty,
    };
  }
}

