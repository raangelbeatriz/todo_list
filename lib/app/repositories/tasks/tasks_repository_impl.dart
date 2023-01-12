import '../../core/database/sqlite_connection_factory.dart';
import '../../models/task_model.dart';
import 'tasks_repository.dart';

class TasksRepositoryImpl implements TasksRepository {
  final SqliteConnectionFactory _sqliteConnectionFactory;

  TasksRepositoryImpl(
      {required SqliteConnectionFactory sqliteConnectionFactory})
      : _sqliteConnectionFactory = sqliteConnectionFactory;

  @override
  Future<void> save(DateTime date, String description) async {
    final connection = await _sqliteConnectionFactory.openConnection();
    await connection.insert('todo', {
      'id': null,
      'description': description,
      'date_hour': date.toIso8601String(),
      'finished': 0
    });
  }

  @override
  Future<List<TaskModel>> findByPeriod(DateTime start, DateTime end) async {
    final startFilter = DateTime(start.year, start.month, start.day, 0, 0, 0);
    final endFilter = DateTime(end.year, end.month, end.day, 23, 59, 59);

    final connection = await _sqliteConnectionFactory.openConnection();
    final result = await connection.rawQuery('''
      select *
      from todo
      where date_hour between ? and ?
      order by date_hour
''', [startFilter.toIso8601String(), endFilter.toIso8601String()]);
    return result.map((e) => TaskModel.loadFromDB(e)).toList();
  }

  @override
  Future<void> checkOrUncheckTask(TaskModel task) async {
    final connection = await _sqliteConnectionFactory.openConnection();
    final finished = task.finished ? 1 : 0;
    await connection.rawUpdate(''' 
    update todo set finished = ? where id = ?
    ''', [finished, task.id]);
  }

  @override
  Future<void> delete(int id) async {
    final connection = await _sqliteConnectionFactory.openConnection();
    await connection.rawDelete('delete from todo where id = ?', [id]);
  }

  @override
  Future<void> deleteAll() async {
    final connection = await _sqliteConnectionFactory.openConnection();
    await connection.rawDelete('delete from todo');
  }
}
