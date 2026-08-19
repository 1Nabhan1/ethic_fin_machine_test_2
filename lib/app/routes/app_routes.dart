part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const TASK_FORM = _Paths.TASK_FORM;
  static const TASK_DETAILS = _Paths.TASK_DETAILS;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const TASK_FORM = '/task-form';
  static const TASK_DETAILS = '/task-details';
}
