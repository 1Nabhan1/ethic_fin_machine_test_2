import 'package:hive_flutter/hive_flutter.dart';
import '../models/task_model.dart';

class HiveService {
  static const String taskBoxName = 'tasks_box';

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TaskModelAdapter());
    await Hive.openBox<TaskModel>(taskBoxName);
  }

  Box<TaskModel> get taskBox => Hive.box<TaskModel>(taskBoxName);

  List<TaskModel> getAllTasks() {
    return taskBox.values.toList();
  }

  Future<void> saveTask(TaskModel task) async {
    await taskBox.put(task.id, task);
  }

  Future<void> deleteTask(String id) async {
    await taskBox.delete(id);
  }

  Future<void> clearAll() async {
    await taskBox.clear();
  }
}
