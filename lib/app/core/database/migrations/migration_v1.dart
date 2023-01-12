import 'package:sqflite/sqflite.dart';

import 'migration.dart';

class MigrationV1 implements Migration {
  @override
  void create(Batch batch) {
    batch.execute('''
    create table todo(
      id Integer primary key autoincrement,
      description varchar(500) not null,
      date_hour dateTime,
      finished int
    )
''');
  }

  @override
  void update(Batch batch) {}
}
