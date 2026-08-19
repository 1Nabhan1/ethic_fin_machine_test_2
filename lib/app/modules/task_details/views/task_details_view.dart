import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/task_details_controller.dart';
import '../../home/controllers/task_controller.dart';
import '../../../routes/app_pages.dart';

class TaskDetailsView extends GetView<TaskDetailsController> {
  const TaskDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              final currentTask = controller.task;
              if (currentTask != null) {
                Get.toNamed(Routes.TASK_FORM, arguments: currentTask);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          Obx(() {
            final task = controller.task;
            if (task == null) return const Center(child: Text('No Task Found'));

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          task.title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      Checkbox(
                        value: task.isCompleted,
                        onChanged: (_) => controller.toggleCompletion(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildBadgeRow(task),
                  const SizedBox(height: 32),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    task.description.isNotEmpty
                        ? task.description
                        : 'No description provided.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 16),
                  _buildDetailItem(
                    context,
                    Icons.calendar_today_outlined,
                    'Due Date',
                    DateFormat('EEEE, MMM d, y').format(task.dueDate),
                  ),
                  _buildDetailItem(
                    context,
                    Icons.access_time,
                    'Created At',
                    DateFormat('MMM d, y HH:mm').format(task.createdAt),
                  ),
                  _buildDetailItem(
                    context,
                    task.isSynced
                        ? Icons.cloud_done_outlined
                        : Icons.cloud_off_outlined,
                    'Cloud Status',
                    task.isSynced ? 'Synced with Cloud' : 'Waiting to Sync',
                    color: task.isSynced ? Colors.green : Colors.orange,
                  ),
                ],
              ),
            );
          }),
          Obx(() {
            final taskController = Get.find<TaskController>();
            return taskController.isLoading.value
                ? Container(
                    color: Colors.black26,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildBadgeRow(task) {
    Color priorityColor;
    switch (task.priority) {
      case 'High': priorityColor = Colors.red; break;
      case 'Medium': priorityColor = Colors.orange; break;
      case 'Low': priorityColor = Colors.green; break;
      default: priorityColor = Colors.grey;
    }

    return Wrap(
      spacing: 8,
      children: [
        Chip(
          label: Text(task.priority),
          backgroundColor: priorityColor.withOpacity(0.1),
          labelStyle: TextStyle(color: priorityColor, fontWeight: FontWeight.bold),
          side: BorderSide(color: priorityColor),
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
        ),
        Chip(
          label: Text(task.isCompleted ? 'Completed' : 'Pending'),
          backgroundColor:
              (task.isCompleted ? Get.theme.colorScheme.primary : Colors.grey)
                  .withOpacity(0.1),
          labelStyle: TextStyle(
            color: task.isCompleted ? Get.theme.colorScheme.primary : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
          side: BorderSide(
            color: task.isCompleted ? Get.theme.colorScheme.primary : Colors.grey,
          ),
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }

  Widget _buildDetailItem(BuildContext context, IconData icon, String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color ?? Colors.grey[600]),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.grey[600])),
              Text(value, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to permanently delete this task?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: controller.deleteTask,
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
