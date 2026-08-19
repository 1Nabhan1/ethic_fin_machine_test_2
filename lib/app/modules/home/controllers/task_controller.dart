import 'dart:async';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/task_model.dart';
import '../../../data/services/hive_service.dart';
import '../../../data/services/firebase_service.dart';
import '../../../data/services/connectivity_service.dart';

class TaskController extends GetxController {
  final HiveService _hiveService = Get.find<HiveService>();
  final FirebaseService _firebaseService = Get.find<FirebaseService>();
  final ConnectivityService _connectivityService =
      Get.find<ConnectivityService>();

  final allTasks = <TaskModel>[].obs;
  final filteredTasks = <TaskModel>[].obs;
  final isLoading = false.obs;

  final searchQuery = ''.obs;
  final filterStatus = 'All'.obs; // All, Completed, Pending
  final sortBy = 'Due Date'.obs; // Due Date, Priority

  StreamSubscription? _remoteSubscription;

  @override
  void onInit() {
    super.onInit();
    _loadLocalTasks();
    _setupRemoteSync();

    // Listen to changes for filtering and sorting
    everAll([
      searchQuery,
      filterStatus,
      sortBy,
      allTasks,
    ], (_) => _applyFilters());

    // Auto-sync when coming back online
    ever(_connectivityService.isOnline, (bool online) {
      if (online) {
        syncOfflineTasks();
      }
    });
  }

  void _loadLocalTasks() {
    allTasks.value = _hiveService.getAllTasks();
    _applyFilters();
  }

  void _setupRemoteSync() {
    _remoteSubscription = _firebaseService.getTasksStream().listen((
      remoteTasks,
    ) {
      // Very simple conflict resolution: remote wins for existing tasks,
      // but we keep local unsynced tasks
      for (var remoteTask in remoteTasks) {
        _hiveService.saveTask(remoteTask.copyWith(isSynced: true));
      }
      _loadLocalTasks();
    });
  }

  Future<void> syncOfflineTasks() async {
    if (!_connectivityService.isOnline.value) return;

    final unsynced = allTasks.where((task) => !task.isSynced).toList();
    for (var task in unsynced) {
      try {
        await _firebaseService.upsertTask(task);
        final updatedTask = task.copyWith(isSynced: true);
        await _hiveService.saveTask(updatedTask);
      } catch (e) {
        print('Sync error for task ${task.id}: $e');
      }
    }
    _loadLocalTasks();
  }

  void _applyFilters() {
    var result = List<TaskModel>.from(allTasks);

    // Search
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      result = result
          .where(
            (t) =>
                t.title.toLowerCase().contains(query) ||
                t.description.toLowerCase().contains(query),
          )
          .toList();
    }

    // Status Filter
    if (filterStatus.value == 'Completed') {
      result = result.where((t) => t.isCompleted).toList();
    } else if (filterStatus.value == 'Pending') {
      result = result.where((t) => !t.isCompleted).toList();
    }

    // Sort
    if (sortBy.value == 'Due Date') {
      result.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    } else if (sortBy.value == 'Priority') {
      final priorityMap = {'High': 0, 'Medium': 1, 'Low': 2};
      result.sort(
        (a, b) => (priorityMap[a.priority] ?? 3).compareTo(
          priorityMap[b.priority] ?? 3,
        ),
      );
    }

    filteredTasks.value = result;
  }

  Future<void> addTask({
    required String title,
    required String description,
    required String priority,
    required DateTime dueDate,
  }) async {
    isLoading.value = true;
    try {
      final task = TaskModel(
        id: const Uuid().v4(),
        title: title,
        description: description,
        priority: priority,
        dueDate: dueDate,
        createdAt: DateTime.now(),
        isSynced: false,
      );

      await _hiveService.saveTask(task);
      _loadLocalTasks();

      if (_connectivityService.isOnline.value) {
        try {
          await _firebaseService.upsertTask(task);
          await _hiveService.saveTask(task.copyWith(isSynced: true));
          _loadLocalTasks();
        } catch (e) {
          print('Remote add error: $e');
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateTask(TaskModel task) async {
    isLoading.value = true;
    try {
      final updatedTask = task.copyWith(isSynced: false);
      await _hiveService.saveTask(updatedTask);
      _loadLocalTasks();

      if (_connectivityService.isOnline.value) {
        try {
          await _firebaseService.upsertTask(updatedTask);
          await _hiveService.saveTask(updatedTask.copyWith(isSynced: true));
          _loadLocalTasks();
        } catch (e) {
          print('Remote update error: $e');
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleTaskCompletion(TaskModel task) async {
    final updatedTask = task.copyWith(
      isCompleted: !task.isCompleted,
      isSynced: false,
    );
    await updateTask(updatedTask);
  }

  Future<void> deleteTask(String id) async {
    isLoading.value = true;
    try {
      await _hiveService.deleteTask(id);
      _loadLocalTasks();

      if (_connectivityService.isOnline.value) {
        try {
          await _firebaseService.deleteTask(id);
        } catch (e) {
          print('Remote delete error: $e');
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _remoteSubscription?.cancel();
    super.onClose();
  }
}
