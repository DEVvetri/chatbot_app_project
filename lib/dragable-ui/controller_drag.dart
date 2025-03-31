import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'task_template.dart';

class TaskController extends GetxController {
  RxList<TaskModel> tasks = <TaskModel>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference get _tasksCollection => _firestore.collection('Tasks');

  @override
  void onInit() {
    super.onInit();
    // Listen to Firestore changes
    _tasksCollection.snapshots().listen((snapshot) {
      tasks.value = snapshot.docs.map((doc) => TaskModel.fromDocument(doc)).toList();
    });
  }

  Future<void> addTask(TaskModel task) async {
    // Add the task to Firestore. The snapshot listener should update the task's id.
    await _tasksCollection.add(task.toMap());
  }

  Future<void> updateTaskStatus(String taskId, String newStatus) async {
    if (taskId.isNotEmpty) {
      await _tasksCollection.doc(taskId).update({'status': newStatus});
    } else {
      print('Task ID is empty. Cannot update status.');
    }
  }

  List<TaskModel> getTasksByStatus(String status) {
    return tasks.where((task) => task.status == status).toList();
  }
}
