import '../../core/notifier/default_change_notifier.dart';
import '../../models/task_filter_enum.dart';
import '../../models/task_model.dart';
import '../../models/total_tasks_model.dart';
import '../../models/week_tasks_model.dart';
import '../../services/tasks/tasks_service.dart';

class HomeController extends DefaultChangeNotifier {
  final TasksService _tasksService;
  TotalTaskModel? todayTotalTask;
  TotalTaskModel? tomorrowTotalTask;
  TotalTaskModel? weekTotalTask;
  List<TaskModel> allTasks = [];
  List<TaskModel> filteredTasks = [];
  DateTime? initialDateOfWeek;
  DateTime? selectedDay;
  bool showFinishedTasks = false;
  String? infoMessage;
  HomeController({required TasksService tasksService})
      : _tasksService = tasksService;
  var _filterSelected = TaskFilterEnum.today;

  set filterSelected(TaskFilterEnum selected) {
    _filterSelected = selected;
    notifyListeners();
  }

  Future<void> findTasks(TaskFilterEnum filter) async {
    showLoading();
    infoMessage = null;
    filterSelected = filter;
    List<TaskModel> tasks;
    notifyListeners();

    switch (filter) {
      case TaskFilterEnum.today:
        tasks = await _tasksService.getToday();
        break;
      case TaskFilterEnum.tomorrow:
        tasks = await _tasksService.getTomorrow();
        break;
      case TaskFilterEnum.week:
        final week = await _tasksService.getWeek();
        initialDateOfWeek = week.startDate;
        print(initialDateOfWeek);
        tasks = week.tasks;
        break;
    }

    filteredTasks = tasks;
    allTasks = tasks;
    if (filter == TaskFilterEnum.week) {
      if (selectedDay != null) {
        filterByDay(selectedDay!);
      } else if (initialDateOfWeek != null) {
        print(initialDateOfWeek);
        filterByDay(initialDateOfWeek!);
      }
    } else {
      selectedDay = null;
    }

    if (!showFinishedTasks) {
      filteredTasks = filteredTasks.where((task) => !task.finished).toList();
    }
    await Future.delayed(const Duration(milliseconds: 200));
    hideLoading();
    notifyListeners();
  }

  TaskFilterEnum get filterSelected => _filterSelected;

  Future<void> loadTasks() async {
    infoMessage = null;
    final allTasks = await Future.wait([
      _tasksService.getToday(),
      _tasksService.getTomorrow(),
      _tasksService.getWeek()
    ]);

    final todayTasks = allTasks[0] as List<TaskModel>;
    final tomorrowTasks = allTasks[1] as List<TaskModel>;
    final weekTasks = allTasks[2] as WeekTasksModel;

    todayTotalTask = TotalTaskModel(
        totalTask: todayTasks.length,
        totalFinishedTasks: todayTasks.where((task) => task.finished).length);
    tomorrowTotalTask = TotalTaskModel(
        totalTask: tomorrowTasks.length,
        totalFinishedTasks:
            tomorrowTasks.where((task) => task.finished).length);

    weekTotalTask = TotalTaskModel(
        totalTask: weekTasks.tasks.length,
        totalFinishedTasks:
            weekTasks.tasks.where((task) => task.finished).length);
    notifyListeners();
  }

  void filterByDay(DateTime date) {
    infoMessage = null;
    selectedDay = date;
    if (!showFinishedTasks) {
      filteredTasks = allTasks
          .where((task) => task.dateHour == date && !task.finished)
          .toList();
    } else {
      filteredTasks = allTasks.where((task) => task.dateHour == date).toList();
    }

    notifyListeners();
  }

  Future<void> refreshPage() async {
    infoMessage = null;
    await findTasks(filterSelected);
    await loadTasks();
    notifyListeners();
  }

  Future<void> checkOrUncheckTask(TaskModel task) async {
    infoMessage = null;
    showLoadingAndResetState();
    notifyListeners();
    final taskUpdate = task.copyWith(finished: !task.finished);
    await _tasksService.checkOrUncheckTask(taskUpdate);
    hideLoading();
    refreshPage();
  }

  void showOrHideFinishedTasks() {
    infoMessage = null;
    showFinishedTasks = !showFinishedTasks;
    refreshPage();
  }

  Future<void> deleteTask(int id) async {
    print('teste');
    filteredTasks.removeWhere((task) => task.id == id);
    await _tasksService.delete(id);
    infoMessage = 'Task Deletada com sucesso';
    await loadTasks();
    notifyListeners();
  }
}
