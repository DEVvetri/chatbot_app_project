import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel2 {
  final String id;
  final String assignedBy;
  final String assignedTo;
  final DateTime date;
  final String status;
  final String taskDescription;
  final String taskName;

  TaskModel2({
    required this.id,
    required this.assignedBy,
    required this.assignedTo,
    required this.date,
    required this.status,
    required this.taskDescription,
    required this.taskName,
  });

  // Create TaskModel from Firestore doc
  factory TaskModel2.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TaskModel2(
      id: doc.id,
      assignedBy: data['assignedBy'] ?? '',
      assignedTo: data['assignedTo'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      status: data['status'] ?? 'todo',
      taskDescription: data['taskDescription'] ?? '',
      taskName: data['taskName'] ?? '',
    );
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'assignedBy': assignedBy,
      'assignedTo': assignedTo,
      'date': date,
      'status': status,
      'taskDescription': taskDescription,
      'taskName': taskName,
    };
  }
}
