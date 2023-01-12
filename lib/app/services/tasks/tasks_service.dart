import '../../models/task_model.dart';
import '../../models/week_tasks_model.dart';

abstract class TasksService {
  Future<void> save(DateTime date, String description);
  Future<List<TaskModel>> getToday();
  Future<List<TaskModel>> getTomorrow();
  Future<WeekTasksModel> getWeek();
  Future<void> checkOrUncheckTask(TaskModel task);
  Future<void> delete(int id);
  Future<void> deleteAll();
}
