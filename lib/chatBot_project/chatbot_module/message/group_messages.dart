import 'package:cloud_firestore/cloud_firestore.dart';

class GroupMessage {
  final String senderEmail;
  final String message;
  final Timestamp timestamp;
  final String senderName;

  GroupMessage({
      required this.senderEmail,
      required this.message,
      required this.timestamp,required this.senderName});
  Map<String, dynamic> toMap() {
    return {
      "sender_name":senderName,
      "sender_email": senderEmail,
      "message": message,
      "timestamp": timestamp
    };
  }
}
