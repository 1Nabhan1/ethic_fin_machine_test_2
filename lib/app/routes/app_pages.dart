import 'package:get/get.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/task_form/views/task_form_view.dart';
import '../modules/task_form/bindings/task_form_binding.dart';
import '../modules/task_details/views/task_details_view.dart';
import '../modules/task_details/bindings/task_details_binding.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.TASK_FORM,
      page: () => const TaskFormView(),
      binding: TaskFormBinding(),
    ),
    GetPage(
      name: _Paths.TASK_DETAILS,
      page: () => const TaskDetailsView(),
      binding: TaskDetailsBinding(),
    ),
  ];
}
