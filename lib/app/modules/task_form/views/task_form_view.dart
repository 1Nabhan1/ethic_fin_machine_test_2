import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/task_form_controller.dart';

class TaskFormView extends GetView<TaskFormController> {
  const TaskFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.editingTask == null ? 'Create New Task' : 'Edit Task',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, 'What needs to be done?'),
            const SizedBox(height: 12),
            _buildTextField(
              controller: controller.titleController,
              label: 'Task Title',
              hint: 'Enter task title',
              icon: Icons.title_rounded,
            ),
            const SizedBox(height: 24),
            _buildSectionHeader(context, 'Additional Details'),
            const SizedBox(height: 12),
            _buildTextField(
              controller: controller.descriptionController,
              label: 'Description',
              hint: 'Enter task description',
              icon: Icons.description_outlined,
              maxLines: 4,
            ),
            const SizedBox(height: 24),
            _buildSectionHeader(context, 'Priority & Timeline'),
            const SizedBox(height: 12),
            _buildPrioritySelector(context),
            const SizedBox(height: 16),
            _buildDatePicker(context),
            const SizedBox(height: 48),
            _buildSubmitButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 22),
        filled: true,
        fillColor: Get.theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        contentPadding: const EdgeInsets.all(20),
      ),
    );
  }

  Widget _buildPrioritySelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: ['Low', 'Medium', 'High'].map((p) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Obx(() {
                  final isSelected = controller.priority.value == p;
                  Color color;
                  switch (p) {
                    case 'High': color = Colors.red; break;
                    case 'Medium': color = Colors.orange; break;
                    default: color = Colors.green;
                  }

                  return ChoiceChip(
                    label: Center(
                      child: Text(
                        p,
                        style: TextStyle(
                          color: isSelected ? Colors.white : color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: color,
                    backgroundColor: color.withOpacity(0.1),
                    side: BorderSide(color: color),
                    showCheckmark: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onSelected: (val) {
                      if (val) controller.priority.value = p;
                    },
                  );
                }),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: controller.dueDate.value,
          firstDate: DateTime.now().subtract(const Duration(days: 365)),
          lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
        );
        if (picked != null) {
          controller.dueDate.value = picked;
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_month_outlined, color: Get.theme.colorScheme.primary),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Due Date',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                Obx(() => Text(
                  DateFormat('EEEE, MMM d, y').format(controller.dueDate.value),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                )),
              ],
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: controller.saveTask,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
        ),
        child: Text(
          controller.editingTask == null ? 'CREATE TASK' : 'UPDATE TASK',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }
}
