import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/task_model.dart';
import '../../home/controllers/task_controller.dart';

class TaskFormController extends GetxController {
  final TaskController _taskController = Get.find<TaskController>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  
  final priority = 'Medium'.obs;
  final dueDate = DateTime.now().obs;
  
  TaskModel? editingTask;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is TaskModel) {
      editingTask = args;
      titleController.text = args.title;
      descriptionController.text = args.description;
      priority.value = args.priority;
      dueDate.value = args.dueDate;
    }
  }

  Future<void> saveTask() async {
    if (titleController.text.isEmpty) {
      Get.snackbar('Error', 'Title is required');
      return;
    }

    if (editingTask != null) {
      final updated = editingTask!.copyWith(
        title: titleController.text,
        description: descriptionController.text,
        priority: priority.value,
        dueDate: dueDate.value,
      );
      await _taskController.updateTask(updated);
    } else {
      await _taskController.addTask(
        title: titleController.text,
        description: descriptionController.text,
        priority: priority.value,
        dueDate: dueDate.value,
      );
    }
    Get.back();
  }
}
