class TaskModel {
  final int id;
  final String description;
  final DateTime dateHour;
  final bool finished;
  TaskModel({
    required this.id,
    required this.description,
    required this.dateHour,
    required this.finished,
  });

  factory TaskModel.loadFromDB(Map<String, dynamic> task) {
    return TaskModel(
        id: task['id'],
        description: task['description'],
        dateHour: DateTime.parse(task['date_hour']),
        finished: task['finished'] == 1);
  }

  TaskModel copyWith({
    int? id,
    String? description,
    DateTime? dateHour,
    bool? finished,
  }) {
    return TaskModel(
      id: id ?? this.id,
      description: description ?? this.description,
      dateHour: dateHour ?? this.dateHour,
      finished: finished ?? this.finished,
    );
  }
}
