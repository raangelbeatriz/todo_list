import '../../models/task_model.dart';
import '../../models/week_tasks_model.dart';
import '../../repositories/tasks/tasks_repository.dart';
import 'tasks_service.dart';

class TasksServiceImpl implements TasksService {
  final TasksRepository _tasksRepository;
  TasksServiceImpl({required TasksRepository tasksRepository})
      : _tasksRepository = tasksRepository;

  @override
  Future<void> save(DateTime date, String description) =>
      _tasksRepository.save(date, description);

  @override
  Future<List<TaskModel>> getToday() =>
      _tasksRepository.findByPeriod(DateTime.now(), DateTime.now());

  @override
  Future<List<TaskModel>> getTomorrow() {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return _tasksRepository.findByPeriod(DateTime.now(), tomorrow);
  }

  @override
  Future<WeekTasksModel> getWeek() async {
    final today = DateTime.now();
    var startFilter = DateTime(today.year, today.month, today.day, 0, 0, 0);
    DateTime endFilter;
    if (startFilter.weekday != DateTime.monday) {
      startFilter =
          startFilter.subtract(Duration(days: (startFilter.weekday - 1)));
    }

    endFilter = startFilter.add(const Duration(days: 7));

    final tasks = await _tasksRepository.findByPeriod(startFilter, endFilter);
    return WeekTasksModel(
        startDate: startFilter, endDate: endFilter, tasks: tasks);
  }

  @override
  Future<void> checkOrUncheckTask(TaskModel task) =>
      _tasksRepository.checkOrUncheckTask(task);

  @override
  Future<void> delete(int id) => _tasksRepository.delete(id);

  @override
  Future<void> deleteAll() => _tasksRepository.deleteAll();
}
