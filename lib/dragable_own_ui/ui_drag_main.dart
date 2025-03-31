// ignore_for_file: deprecated_member_use

import 'package:chatbot_app_project/dragable_own_ui/get_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UiDragMain extends StatefulWidget {
  const UiDragMain({super.key});

  @override
  State<UiDragMain> createState() => _UiDragMainState();
}

class _UiDragMainState extends State<UiDragMain> {
  // Retrieve the TaskController using GetX
  final TaskController2 taskController = Get.put(TaskController2());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Manager"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Open a simple dialog to add a new task
              _showAddTaskDialog(context);
            },
          )
        ],
      ),
      body: Row(
        children: [
          _buildStatusColumn("todo", "List TODO"),
          _buildStatusColumn("inProgress", "List In Progress"),
          _buildStatusColumn("done", "List Done"),
        ],
      ),
    );
  }

  // Build a column for a given status
  Widget _buildStatusColumn(String status, String title) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.white),
              padding: const EdgeInsets.all(8),
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Display tasks of that status using GetX Obx
            Expanded(
              child: Obx(() {
                final tasksForStatus = taskController.getTasksByStatus(status);
                return ListView.builder(
                  itemCount: tasksForStatus.length,
                  itemBuilder: (context, index) {
                    final task = tasksForStatus[index];
                    return _buildDraggableTask(task);
                  },
                );
              }),
            ),
            const SizedBox(height: 10),
            DragTarget<Map<String, dynamic>>(
              onWillAccept: (data) => data != null,
              onAccept: (data) {
                // Update the task's status
                taskController.updateTaskStatus(data["taskName"], status);
              },
              builder: (context, candidateData, rejectedData) {
                return Container(
                  width: double.infinity,
                  height: 50,
                  color: candidateData.isNotEmpty
                      ? Colors.blueAccent
                      : Colors.grey.shade300,
                  child: Center(
                    child: Text(candidateData.isNotEmpty
                        ? "Release to change to $status"
                        : "Drag here to set as $status"),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  // Build a draggable task card
  Widget _buildDraggableTask(Map<String, dynamic> task) {
    return Draggable<Map<String, dynamic>>(
      data: task,
      feedback: _buildTaskCard(task, isDragging: true),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: _buildTaskCard(task),
      ),
      child: _buildTaskCard(task),
    );
  }

  // Task card widget
  Widget _buildTaskCard(Map<String, dynamic> task, {bool isDragging = false}) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      color: isDragging ? Colors.orange.shade100 : Colors.blueAccent.shade100,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          task["taskName"],
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  // Simple dialog to add a new task
  void _showAddTaskDialog(BuildContext context) {
    final taskNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Task"),
        content: TextField(
          controller: taskNameController,
          decoration: const InputDecoration(labelText: "Task Name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              // Create a new task with status 'todo'
              final newTask = {
                "taskName": taskNameController.text.trim(),
                "status": "todo"
              };
              taskController.addTask(newTask);
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}
