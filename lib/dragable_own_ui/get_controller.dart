import 'package:get/get.dart';

class TaskController2 extends GetxController {
  RxList<Map<String, dynamic>> tasks = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    tasks.addAll([
      {"taskName": "Task 1", "status": "todo"},
      {"taskName": "Task 2", "status": "inProgress"},
      {"taskName": "Task 3", "status": "done"},
      {"taskName": "Task 4", "status": "todo"},
      {"taskName": "Task 5", "status": "inProgress"},
      {"taskName": "Task 6", "status": "done"},
      {"taskName": "Task 7", "status": "todo"},
      {"taskName": "Task 8", "status": "inProgress"},
      {"taskName": "Task 9", "status": "done"},
    ]);
  }

  List<Map<String, dynamic>> getTasksByStatus(String status) {
    return tasks.where((task) => task["status"] == status).toList();
  }

  // Update task status
  void updateTaskStatus(String taskName, String newStatus) {
    int index = tasks.indexWhere((task) => task["taskName"] == taskName);
    if (index != -1) {
      tasks[index]["status"] = newStatus;
      tasks.refresh(); // notify listeners
    }
  }

  // Add a new task to the list
  void addTask(Map<String, dynamic> task) {
    tasks.add(task);
  }
}
