import 'task_model.dart';

class WeekTasksModel {
  final DateTime startDate;
  final DateTime endDate;
  final List<TaskModel> tasks;
  WeekTasksModel({
    required this.startDate,
    required this.endDate,
    required this.tasks,
  });

  factory WeekTasksModel.loadFromDB(Map<String, dynamic> map) {
    return WeekTasksModel(
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']),
      endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate']),
      tasks: List<TaskModel>.from(
          map['tasks']?.map((x) => TaskModel.loadFromDB(x))),
    );
  }
}
