import 'package:get/get.dart';
import '../../../data/models/task_model.dart';
import '../../home/controllers/task_controller.dart';

class TaskDetailsController extends GetxController {
  final TaskController _taskController = Get.find<TaskController>();
  
  final _taskId = ''.obs;

  // Use a getter to find the task in the main controller's observable list
  // This ensures that when the task is updated in TaskController, it reflects here.
  TaskModel? get task {
    try {
      return _taskController.allTasks.firstWhere((t) => t.id == _taskId.value);
    } catch (e) {
      return null;
    }
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is TaskModel) {
      _taskId.value = args.id;
    }
  }

  void deleteTask() {
    final currentTask = task;
    if (currentTask != null) {
      _taskController.deleteTask(currentTask.id);
      Get.back();
    }
  }

  void toggleCompletion() {
    final currentTask = task;
    if (currentTask != null) {
      _taskController.toggleTaskCompletion(currentTask);
    }
  }
}
