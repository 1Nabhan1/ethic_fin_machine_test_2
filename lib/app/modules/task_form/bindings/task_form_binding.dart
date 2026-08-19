import 'package:get/get.dart';
import '../controllers/task_form_controller.dart';

class TaskFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskFormController>(() => TaskFormController());
  }
}
