import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/task_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../data/models/task_model.dart';
import '../../../data/services/connectivity_service.dart';

class HomeView extends GetView<TaskController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final connectivity = Get.find<ConnectivityService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Tasks',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          Obx(
            () => Container(
              margin: const EdgeInsets.only(right: 16),
              child: Tooltip(
                message: connectivity.isOnline.value ? 'Online' : 'Offline',
                child: Icon(
                  connectivity.isOnline.value ? Icons.wifi : Icons.wifi_off,
                  color: connectivity.isOnline.value
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterBar(),
          Expanded(
            child: Obx(() {
              if (controller.filteredTasks.isEmpty) {
                return _buildEmptyState();
              }
              return ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: controller.filteredTasks.length,
                separatorBuilder: (context, index) =>
                const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final task = controller.filteredTasks[index];
                  return TaskItem(task: task);
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(Routes.TASK_FORM),
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: SearchBar(
        hintText: 'Search tasks...',
        onChanged: (value) => controller.searchQuery.value = value,
        leading: const Icon(Icons.search),
        elevation: WidgetStateProperty.all(0),
        backgroundColor: WidgetStateProperty.all(
          Get.theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _buildFilterChip('All'),
            const SizedBox(width: 8),
            _buildFilterChip('Pending'),
            const SizedBox(width: 8),
            _buildFilterChip('Completed'),
            const SizedBox(width: 16),
            const SizedBox(height: 20, child: VerticalDivider()),
            const SizedBox(width: 8),
            const Icon(Icons.sort, size: 20, color: Colors.grey),
            const SizedBox(width: 8),
            Obx(
              () => DropdownButton<String>(
                value: controller.sortBy.value,
                underline: const SizedBox(),
                style: TextStyle(
                  color: Get.theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
                items: ['Due Date', 'Priority']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => controller.sortBy.value = v!,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return Obx(
      () => ChoiceChip(
        label: Text(label),
        selected: controller.filterStatus.value == label,
        selectedColor: Get.theme.colorScheme.primary.withOpacity(0.1),
        labelStyle: TextStyle(
          color: controller.filterStatus.value == label
              ? Get.theme.colorScheme.primary
              : Get.theme.colorScheme.onSurface.withOpacity(0.8),
          fontWeight: controller.filterStatus.value == label
              ? FontWeight.bold
              : FontWeight.normal,
        ),
        onSelected: (selected) {
          if (selected) controller.filterStatus.value = label;
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_alt, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No tasks found',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class TaskItem extends StatelessWidget {
  final TaskModel task;
  const TaskItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TaskController>();

    Color priorityColor;
    switch (task.priority) {
      case 'High':
        priorityColor = Colors.red;
        break;
      case 'Medium':
        priorityColor = Colors.orange;
        break;
      case 'Low':
        priorityColor = Colors.green;
        break;
      default:
        priorityColor = Colors.grey;
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withOpacity(0.2)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Get.toNamed(Routes.TASK_DETAILS, arguments: task),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(width: 6, color: priorityColor),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              task.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: task.isCompleted ? Colors.grey : null,
                              ),
                            ),
                          ),
                          Icon(
                            task.isSynced
                                ? Icons.cloud_done
                                : Icons.cloud_upload_outlined,
                            size: 16,
                            color: task.isSynced ? Colors.green : Colors.orange,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        task.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('MMM d').format(task.dueDate),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          const Spacer(),
                          Transform.scale(
                            scale: 0.9,
                            child: Checkbox(
                              value: task.isCompleted,
                              shape: const CircleBorder(),
                              onChanged: (_) =>
                                  controller.toggleTaskCompletion(task),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
