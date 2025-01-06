class ChatMessage {
  String message;
  bool isMe;
  ChatMessage({required this.isMe, required this.message});
}

class UserProfile {
  String username;
  String name;
  String profilePicture;
  String isPrivate;
  UserProfile(
      {required this.username,
      required this.name,
      required this.profilePicture,
      required this.isPrivate});
      
}

