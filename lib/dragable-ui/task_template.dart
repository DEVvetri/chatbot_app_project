import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String id;              
  final String assignedBy;
  final String assignedTo;
  final DateTime date;
  final String taskName;
  final String taskDescription;
  final String status;          

  TaskModel({
    required this.id,
    required this.assignedBy,
    required this.assignedTo,
    required this.date,
    required this.taskName,
    required this.taskDescription,
    required this.status,
  });

  factory TaskModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      id: doc.id,
      assignedBy: data['assignedBy'] ?? '',
      assignedTo: data['assignedTo'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      taskName: data['taskName'] ?? '',
      taskDescription: data['taskDescription'] ?? '',
      status: data['status'] ?? 'todo',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'assignedBy': assignedBy,
      'assignedTo': assignedTo,
      'date': date,
      'taskName': taskName,
      'taskDescription': taskDescription,
      'status': status,
    };
  }
}